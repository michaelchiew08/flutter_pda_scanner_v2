# Flutter PDA Scanner V2
  
[![License][license-image]][license-url]

Flutter plugin that supports wide range of 📱 PDA handheld scanner devices.

## Installation

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  flutter_pda_scanner_v2: ^0.0.2
```

## Supported Device Models

-  [x] SEUIC(小码哥)-PDA
-  [x] IData(盈达聚力)-PDA
-  [x] UROVO(优博讯)-PDA
-  [x] HONEYWELL(霍尼韦尔)-PDA
-  [x] PL(攀凌)-PDA
-  [x] NEWLAND(新大陆)-PDA
-  [x] KAICOM(凯立)-PDA

## Usage
```dart
/// Import package of `pda_lifecycle_mixin.dart`
import 'package:flutter_pda_scanner_v2/pda_lifecycle_mixin.dart';

///
class RootApp extends ConsumerStatefulWidget {
  const RootApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> with PdaLifecycleMixin<RootApp> {
  @override
  Widget build(BuildContext context) {
    // Return rest of your code such as MaterialApp, Scaffold, your root widget and etc.
  }
}

/// Import package of `pda_listener_mixin.dart`
import 'package:flutter_pda_scanner_v2/pda_listener_mixin.dart';
class ScreenExampleState extends State<ScreenExample> with PdaListenerMixin<ScreenExample> {
  var _code;

  @override
  Widget build(BuildContext context) {
    return null;
    // Or return your own widget.
  }

  @override
  void onEvent(Object event) {
      // Process the value of the `event.toString()` here.
  }
  
    @override
  void onError(Object error) {
      // Process the value of the `error.toString()` here such as show toast or dialog.
  }
}
```

## License

Distributed under the MIT license. See `LICENSE` for more information.

## About

Originally fork and reference via [pda_scanner](https://github.com/wu9007/pda_scanner) and [flutter_pda_scanner](https://github.com/uupy/pda_scanner) by Shusheng or the original creator.

Currently this repo is maintained by [Michael Chiew](https://github.com/michaelchiew08) to include support for Android V2 Embedding.

[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE