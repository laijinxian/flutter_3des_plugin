import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_3des_plugin/flutter_3des_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
 
  // _data， _key 数据为测试数据， 实际开发根据项目需求规则生成
  final String _data = '2005261620000123';
  final String _key = 'FC1900000123200526162055AA5A5AA5';
  String _result  = '';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // 3des 加密
  encrypt () {
    Flutter3desPlugin.encrypt(_key, _data).then((res) {
      // TODO: res就是加密后的数据
      setState(() {
        _result = res; 
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
