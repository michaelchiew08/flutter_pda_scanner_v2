import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Mixin for handling PDA scanner events
mixin PdaListenerMixin<T extends StatefulWidget> on State<T> {
  bool _isListening = false;

  bool get isListening => _isListening;

  void initScanner() {
    PdaScanner.instance.registerListener(this);
    _isListening = true;
    debugPrint('Scanner initialized');
  }

  void disposeScanner() {
    PdaScanner.instance.unregisterListener(this);
    _isListening = false;
    debugPrint('Scanner disposed');
  }

  @override
  void initState() {
    super.initState();
    initScanner();
  }

  @override
  void dispose() {
    disposeScanner();
    super.dispose();
  }

  void onEvent(String data);
  void onError(Object error);
}

/// Main scanner class implementing singleton pattern
class PdaScanner {
  static const String _channelName = 'com.ztt.flutter_pda_scanner_v2/plugin';

  PdaScanner._();
  static final PdaScanner instance = PdaScanner._();

  EventChannel? _scannerPlugin;
  StreamSubscription? _subscription;
  final List<PdaListenerMixin> _listeners = [];
  bool _isInitialized = false;

  /// Initialize the scanner
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _scannerPlugin = const EventChannel(_channelName);
      _subscription = _scannerPlugin!
          .receiveBroadcastStream()
          .listen(_onEvent, onError: _onError);
      _isInitialized = true;
    } catch (e) {
      _isInitialized = false;
      rethrow;
    }
  }

  /// Register a listener for scanner events
  void registerListener(PdaListenerMixin listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  /// Unregister a listener
  void unregisterListener(PdaListenerMixin listener) {
    _listeners.remove(listener);
  }

  /// Dispose the scanner and clean up resources
  Future<void> dispose() async {
    _listeners.clear();
    await _subscription?.cancel();
    _subscription = null;
    _scannerPlugin = null;
    _isInitialized = false;
  }

  void _onEvent(dynamic data) {
    if (data is String) {
      for (final listener in _listeners) {
        if (listener.isListening) {
          listener.onEvent(data);
        }
      }
    }
  }

  void _onError(Object error) {
    for (final listener in _listeners) {
      if (listener.isListening) {
        listener.onError(error);
      }
    }
  }
}
