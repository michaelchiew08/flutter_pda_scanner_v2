import 'package:flutter/material.dart';
import 'package:flutter_pda_scanner_v2/flutter_pda_scanner_v2.dart';

class WidgetExample extends StatefulWidget {
  const WidgetExample({super.key});

  @override
  State<StatefulWidget> createState() => WidgetExampleState();
}

class WidgetExampleState extends State<WidgetExample>
    with PdaListenerMixin<WidgetExample> {
  String _code = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Example'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Scanning result: $_code\n'),
            ElevatedButton(
              child: const Text('Back to main'),
              onPressed: () => Navigator.of(context).pop(),
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
            ElevatedButton(
              child: const Text('Manual dispose scanner'),
              onPressed: () => disposeScanner(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onEvent(String data) {
    setState(() {
      _code = data;
      print('Beta scan result: $_code');
    });
  }

  @override
  void onError(Object error) {
    print('Beta scan error: $error');
  }
}
