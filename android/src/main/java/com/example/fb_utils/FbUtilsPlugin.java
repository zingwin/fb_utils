package com.example.fb_utils;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import java.io.*;
import java.io.UnsupportedEncodingException;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.*;

/** FbUtilsPlugin */
public class FbUtilsPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "fb_utils");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if("getFileMD5".equals(call.method)){
      String path = call.argument("file_path");
      result.success(getFileChecksum(path));
    }else if("getStringMD5".equals(call.method)){
      String path= call.argument("target");
      result.success(getStringMd5(path));
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }


  private String getStringMd5(String target) {
    byte[] hash;
    try {
      hash = MessageDigest.getInstance("MD5").digest(target.getBytes("UTF-8"));
    } catch (NoSuchAlgorithmException e) {
      throw new RuntimeException("NoSuchAlgorithmException",e);
    } catch (UnsupportedEncodingException e) {
      throw new RuntimeException("UnsupportedEncodingException", e);
    }

    StringBuilder hex = new StringBuilder(hash.length * 2);
    for (byte b : hash) {
      if ((b & 0xFF) < 0x10){
        hex.append("0");
      }
      hex.append(Integer.toHexString(b & 0xFF));
    }
    return hex.toString();
  }

  private String getFileChecksum(String filePath) {
    int buffersize = 1024 * 8;
    FileInputStream fis = null;
    DigestInputStream dis = null;

    try {
      //??????MD5?????????????????????
      MessageDigest messageDigest =MessageDigest.getInstance("MD5");
      fis = new FileInputStream(filePath);
      dis = new DigestInputStream(fis,messageDigest);

      byte[] buffer = new byte[buffersize];
      //DigestInputStream?????????????????????????????????????????????????????????????????????
      while (dis.read(buffer) > 0);

      //??????DigestInputStream???????????????????????????MessageDigest?????????
      messageDigest = dis.getMessageDigest();

      // ??????messageDigest??????????????????????????????????????????16?????????
      byte[] array = messageDigest.digest();
      // ??????????????????????????????????????????
      StringBuilder hex = new StringBuilder(array.length * 2);
      for (byte b : array) {
        if ((b & 0xFF) < 0x10){
          hex.append("0");
        }
        hex.append(Integer.toHexString(b & 0xFF));
      }
      return hex.toString();
    } catch (FileNotFoundException e) {
      e.printStackTrace();
    } catch (NoSuchAlgorithmException e) {
      e.printStackTrace();
    } catch (IOException e) {
      e.printStackTrace();
    }

    return null;
  }
}
