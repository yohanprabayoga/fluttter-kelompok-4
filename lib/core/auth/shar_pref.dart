import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PumpMonitoringSharedPref {
  PumpMonitoringSharedPref._privateConstructor();

  static final PumpMonitoringSharedPref instance =
      PumpMonitoringSharedPref._privateConstructor();

  // To save StringValue, call :
  // KlixSharedPreference.instance.setStringValue("key", value);
  // for example :
  //
  // KlixSharedPreference.instance.setStringValue("token", response['token']);
  //
  // this mean, you save token from response['token']

  setStringValue(String key, String value) async {
    SharedPreferences klixPrefs = await SharedPreferences.getInstance();
    klixPrefs.setString(key, value);
  }

  // To get StringValue, call :
  // KlixSharedPreference.instance.getStringValue("token").((value) => setState(() { token = value; }));
  // or
  // KlixSharedPreference.instance.getStringValue("token").((value) => token = value; );

  Future<String?> getStringValue(String key) async {
    SharedPreferences gapPrefs = await SharedPreferences.getInstance();
    return gapPrefs.getString(key);
  }

  // KlixSharedPreference.instance.setIntegerValue("key", value);
  setIntegerValue(String key, int? value) async {
    SharedPreferences gapPrefs = await SharedPreferences.getInstance();
    gapPrefs.setInt(key, value!);
  }

  // KlixSharedPreference.instance.getIntegerValue("token").((value) => setState(() { token = value; }));
  Future<int?> getIntegerValue(String? key) async {
    SharedPreferences gapPrefs = await SharedPreferences.getInstance();
    return gapPrefs.getInt(key!);
  }

  // KlixSharedPreference.instance.setBooleanValue("key", value);
  setBooleanValue(String key, bool? value) async {
    SharedPreferences gapPrefs = await SharedPreferences.getInstance();
    gapPrefs.setBool(key, value!);
  }

  // KlixSharedPreference.instance.containsKey("token").((value) => setState(() { token = value; }));
  Future<bool?> containsKey(String? key) async {
    SharedPreferences gapPrefs = await SharedPreferences.getInstance();
    return gapPrefs.getBool(key!) ?? false;
  }

  // KlixSharedPreference.instance.removeSharPrefValue("token");
  removeSharPrefValue(String? key) async {
    SharedPreferences klixPrefs = await SharedPreferences.getInstance();
    return klixPrefs.remove(key!);
  }

  // KlixSharedPreference.instance.removeAllSharPref("token");
  removeAllSharPref() async {
    SharedPreferences gapPrefs = await SharedPreferences.getInstance();
    return gapPrefs.clear();
  }

  static Future<bool> saveImageToPrefs(String key, String? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return await prefs.setString(key, value!);
  }

  static Future<bool> emptyPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return await prefs.clear();
  }

  static Future<String?> loadImageFromPrefs(String? key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key!);
  }

  // encodes bytes list as string
  static String base64String(Uint8List? data) {
    return base64Encode(data!);
  }

  // decode bytes from a string
  static imageFrom64BaseString(String? base64String) {
    return Image.memory(
      base64Decode(base64String!),
      fit: BoxFit.fill,
    );
  }

  static imageProfileFrom64BaseString(String? base64String) {
    return Image.memory(
      base64Decode(base64String!),
      fit: BoxFit.fill,
    );
  }

  // decode bytes from a string 2
  static imageFrom64BaseString2(Uint8List? base64String) {
    return base64Encode(base64String!);
  }
}
