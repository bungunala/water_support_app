import 'package:flutter/material.dart';
import 'models/node.dart';
import 'services/fake_api.dart';

void main() {
  runApp(const WaterSupportApp());
}

class WaterSupportApp extends StatelessWidget {
  const WaterSupportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Water Support',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DiagnoseScreen(),
    );
  }
}

class DiagnoseScreen extends StatefulWidget {
  const DiagnoseScreen({super.key});

  @override
  State<DiagnoseScreen> createState() => _DiagnoseScreenState();
}

class _DiagnoseScreenState extends State<DiagnoseScreen> {
  Node? currentNode;
  bool isLoading = true;

  // 🔙 Navigation history
  List<int> history = [];

  // 🌍 Language
  String currentLang = "en";

  @override
  void initState() {
    super.initState();
    loadNode(1);
  }

  // 🌐 Translation helper
  String t(Map<String, dynamic> textMap) {
    return textMap[currentLang] ?? textMap["en"];
  }

  Future<void> loadNode(int id, {bool addToHistory = true}) async {
    if (currentNode != null && addToHistory) {
      history.add(currentNode!.id);
    }

    setState(() => isLoading = true);

    try {
      final data = await getNode(id);
      final node = Node.fromJson(data);

      setState(() {
        currentNode = node;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  void goBack() {
    if (history.isEmpty) return;

    final previousId = history.removeLast();
    loadNode(previousId, addToHistory: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnose'),
        centerTitle: true,
        leading: history.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: goBack,
              )
            : null,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                currentLang = currentLang == "en" ? "es" : "en";
              });
            },
            child: Text(
              currentLang.toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : currentNode == null
              ? const Center(child: Text('No data available'))
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    final node = currentNode!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            t(node.text),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),

          if (!node.isFinal)
            ...node.options.map(
              (opt) => Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: _buildOptionButton(
                  text: t(opt.text),
                  onTap: () => loadNode(opt.nextId),
                ),
              ),
            ),

          if (node.isFinal) ...[
            const SizedBox(height: 30),
            Text(
              currentLang == "en"
                  ? "Need more help?"
                  : "¿Necesitas más ayuda?",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                print("Go to contact form");
              },
              child: Text(
                currentLang == "en" ? "Contact Us" : "Contáctanos",
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildOptionButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}