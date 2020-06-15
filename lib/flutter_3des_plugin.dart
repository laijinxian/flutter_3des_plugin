import 'dart:async';

import 'package:flutter/services.dart';

class Flutter3desPlugin {
  static const MethodChannel _channel =
      const MethodChannel('flutter_3des_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> encrypt(String key, String data) async{
    return await _channel.invokeMethod('encrypt' , <String,dynamic>{'data':data,'key':key});
  }
}
