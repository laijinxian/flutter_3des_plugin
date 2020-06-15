# flutter_3des_plugin

A new flutter plugin project.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.

## Add Dependency （引入）
```
dependencies:
  flutter_3des: ^0.0.1
```

## Implementation (使用)

```
import 'package:flutter_3des_plugin/flutter_3des_plugin.dart';

void example() async {
  const string = "my name is flutter";
  const key = "702040801020305070B0D1101020305070B0D1112110D0B0";
  const iv = "070B0D1101020305";

  Flutter3desPlugin.encrypt(_key, _data).then((res) {
    // res就是加密完成的数据， 这时你需要对 res 做点什么
    setState(() {
      _result = res.substring(0,16); // android 下需要截取前16位就是要的结果，  ios 不用截取
    });
  });
}
```