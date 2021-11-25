import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class FbUtils {
  static const MethodChannel _channel = const MethodChannel('fb_utils');

  ///Method to get MD5 String
  ///- [filePath] : path of local file
  static Future<String> getMD5WithPath(String filePath) async {
    var map = {
      'file_path': filePath,
    };
    var checksum = await _channel.invokeMethod<String>('getFileMD5', map);
    return checksum;
  }

  ///Method to get MD5 String
  ///- [target] : to md5 target
  static Future<String> getMD5WithSring(String target) async {
    var map = {
      'target': target,
    };
    var checksum = await _channel.invokeMethod<String>('getStringMD5', map);
    return checksum;
  }

  /// 隐藏键盘 iOS
  static Future<void> hideKeyboard() async {
    if (Platform.isIOS) {
      _channel.invokeMethod<String>('hideKeyboard', null);
    }
  }
}
