import 'dart:async';
import 'package:flutter/services.dart';

abstract class NetworkService {
  Future<bool> isConnected();
  Stream<bool> get connectivityStream;
}

class NetworkServiceImpl implements NetworkService {
  static const EventChannel _channel = EventChannel('connectivity');

  bool _connectionStatus = true;
  final StreamController<bool> _connectivityController = StreamController<bool>.broadcast();

  bool get connectionStatus => _connectionStatus;

  @override
  Stream<bool> get connectivityStream => _connectivityController.stream;

  NetworkServiceImpl() {
    _init();
  }

  Future<void> _init() async {
    try {
      _channel.receiveBroadcastStream().listen((result) {
        final connected = result == 'connected' || result == true;
        if (_connectionStatus != connected) {
          _connectionStatus = connected;
          _connectivityController.add(_connectionStatus);
        }
      });
    } catch (e) {
      _connectionStatus = false;
    }
  }

  @override
  Future<bool> isConnected() async {
    try {
      const methodChannel = MethodChannel('network_info');
      final result = await methodChannel.invokeMethod('isConnected');
      _connectionStatus = result == true;
    } catch (e) {
      _connectionStatus = true;
    }
    return _connectionStatus;
  }

  void dispose() {
    _connectivityController.close();
  }
}

class MockNetworkService implements NetworkService {
  bool _connectionStatus = true;

  bool get connectionStatus => _connectionStatus;

  @override
  Stream<bool> get connectivityStream => Stream.value(_connectionStatus);

  void setConnected(bool value) {
    _connectionStatus = value;
  }

  @override
  Future<bool> isConnected() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _connectionStatus;
  }
}
