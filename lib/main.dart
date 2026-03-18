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

class _DiagnoseScreenState extends State<DiagnoseScreen>
    with SingleTickerProviderStateMixin {
  Node? currentNode;
  bool isLoading = true;

  // 🔙 Navigation history
  List<int> history = [];

  // 🌍 Language
  String currentLang = "en";

  // 💧 Animation
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    loadNode(1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
          ? const Center(
              child: Opacity(
                opacity: 0.7,
                child: CircularProgressIndicator(),
              ),
            )
          : currentNode == null
              ? const Center(child: Text('No data available'))
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    final node = currentNode!;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: const [
                Color(0xFFE3F2FD),
                Color(0xFF90CAF9),
                Color(0xFF42A5F5)
              ],
              begin: Alignment(-1 + _animation.value * 2, -1),
              end: Alignment(1 - _animation.value * 2, 1),
            ),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, animation) {
              final slide = Tween<Offset>(
                begin: const Offset(0.2, 0),
                end: Offset.zero,
              ).animate(animation);

              return FadeTransition(
                opacity: animation,
                child: SlideTransition(position: slide, child: child),
              );
            },
            child: Column(
              key: ValueKey(node.id),
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
                    (opt) => _buildOptionButton(
                      text: t(opt.text),
                      onTap: () => loadNode(opt.nextId),
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
          ),
        );
      },
    );
  }

  Widget _buildOptionButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Material(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          splashColor: Colors.lightBlueAccent.withOpacity(0.4),
          highlightColor: Colors.white.withOpacity(0.1),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            alignment: Alignment.center,
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}