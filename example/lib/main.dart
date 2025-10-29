import 'package:flutter/material.dart';
import 'package:flutter_pda_scanner_v2/flutter_pda_scanner_v2.dart';
import 'package:flutter_pda_scanner_v2_example/widget_example.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PdaScanner.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: const WidgetAlpha(),
      ),
    );
  }
}

class WidgetAlpha extends StatefulWidget {
  const WidgetAlpha({super.key});

  @override
  State<StatefulWidget> createState() => WidgetAlphaState();
}

class WidgetAlphaState extends State<WidgetAlpha>
    with PdaListenerMixin<WidgetAlpha> {
  String _code = '';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Text('Scanning result: $_code\n'),
          ElevatedButton(
            child: const Text('Got to Beta'),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const WidgetExample(),
              ),
            ),
          ),
          ElevatedButton(
            child: const Text('Check listener'),
            onPressed: () {
              // Check if scanner is listening.
              if (isListening) {
                print('Scanner still listening');
              } else {
                print('Scanner is not listening');
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    disposeScanner();
    super.dispose();
  }

  @override
  void onEvent(String data) {
    setState(() {
      _code = data;
      print('Scanner scan result: $_code');
    });
  }

  @override
  void onError(Object error) {
    print('Scanner error: $error');
  }
}
