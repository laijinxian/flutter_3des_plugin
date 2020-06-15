import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_3des_plugin/flutter_3des_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

/*
 * 1. 目的： 该 3des 加密插件为解决 flutter => java后台 => 硬件 相联系的需求 （需保证App端、服务端、硬件三方加密结果一致）结果为16进制数据；
 * 2. 现有的 pub.dev 插件如（flutter_3des， flutter_des， des_plugin）加密后的结果均和 java、硬件加密的结果不一致， 故单独搞了个3des加密插件。
 * 3. 后续开发上传解密， 以及base64加密、解密
 */

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
 
  // _data， _key 数据为测试数据， 实际开发根据项目需求规则生成
  final String  _data = '2005261620000123';
  final String _key = '702040801020305070B0D11010203050';
  String _result  = '';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // 3des 加密
  encrypt () {
    Flutter3desPlugin.encrypt(_key, _data).then((res) {
      setState(() {
        _result = res.substring(0,16); // android 下需要截取前16位就是要的结果，  ios 不用截取
      });
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await Flutter3desPlugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('flutter 3des plugin example'),
        ),
        body: Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text('Running on: $_platformVersion'),
              new Text('加密的data： $_data'),
              new Text('加密的key： $_key'),
              RaisedButton(
              onPressed: _result.isEmpty ? (){
                encrypt();
              } : null,
              child: Text("执行3des加密"),
            ),
              new Text('加密的结果： $_result'),
            ],
          ),
        ),
      ),
    );
  }
}
