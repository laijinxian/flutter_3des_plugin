package com.example.flutter_3des_plugin;

import android.os.Bundle;
import android.util.Base64;
import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** Flutter3desPlugin */
public class Flutter3desPlugin implements FlutterPlugin, MethodCallHandler {
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    final MethodChannel channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "flutter_3des_plugin");
    channel.setMethodCallHandler(new Flutter3desPlugin());
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_3des_plugin");
    channel.setMethodCallHandler(new Flutter3desPlugin());
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
      switch (call.method) {
        case "getPlatformVersion":
          result.success("Android " + android.os.Build.VERSION.RELEASE);
          break;
        case "encrypt":
            String body = call.argument("data");
            String keys = call.argument("key");
            String key = keys + keys.substring(0,16);
            byte [] text = encrypt(hexStr2Bytes(key),hexStr2Bytes(body));
            result.success(bytes2HexStr(text));
          break;
        default:
          result.notImplemented();
          break;
    }
  }
  private static final String algorithm = "DESede";

  // 方法的实现
  public static byte[] encrypt(byte[] key, byte[] body) {
      try {
          SecretKey deskey = new SecretKeySpec(key, algorithm);
          Cipher c1 = Cipher.getInstance(algorithm);
          c1.init(Cipher.ENCRYPT_MODE, deskey);
          return c1.doFinal(body);
      } catch (java.security.NoSuchAlgorithmException e1) {
          e1.printStackTrace();
      } catch (javax.crypto.NoSuchPaddingException e2) {
          e2.printStackTrace();
      } catch (java.lang.Exception e3) {
          e3.printStackTrace();
      }
      return null;
  }

  public static byte[] hexStr2Bytes(String s) {
      int len = s.length();
      byte[] data = new byte[len / 2];
      for (int i = 0; i < len; i += 2) {
          data[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4)
                  + Character.digit(s.charAt(i+1), 16));
      }
      return data;
  }

  public static String bytes2HexStr(byte[] data) {
      final StringBuilder stringBuilder = new StringBuilder(data.length);
      for (byte byteChar : data)
          stringBuilder.append(String.format("%02X", byteChar));
      return stringBuilder.toString();
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
  }
}
