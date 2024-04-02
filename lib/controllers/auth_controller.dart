import 'dart:convert';

import 'package:eit/helpers/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class AuthController extends GetxController {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> serverFormKey = GlobalKey<FormState>();
  TextEditingController usernameTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  RxBool passwordVisibility = false.obs;
  UserModel? userModel;
  //apiURL = https://mobiletest.itgenesis.app/GetUserInfo
  TextEditingController apiURLTextController = TextEditingController();
  //serviceKey = 1357
  TextEditingController secretKeyTextController = TextEditingController();

  Future<void> fetchUserData(
      {required String apiURL,
      required String username,
      required String password,
      required String secretKey}) async {
    final url = Uri.parse(
        'https://$apiURL/GetUserInfo?ServiceKey=$secretKey&u=$username&p=$password');
    // try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['Success']) {
        setUserToPrefs(userData: json.encode(data['data']));
        userModel = UserModel.fromJson(data['data']);
        Get.offNamed('/index-screen');
      } else {
        AppToasts.errorToast('Incorrect Credentials'.tr);
      }
    } else {
      AppToasts.errorToast('Connection Error'.tr);
    }
    // } catch (e) {
    //   AppToasts.errorToast(e.toString());
    // }
  }

  Future<void> setApiConnectionToPrefs(
      {required String apiURL, required String secretKey}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('apiURL', apiURL);
    await prefs.setString('secretKey', secretKey.toString());
  }

  Future<void> setUserToPrefs({required String userData}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userData', userData);
    } catch (e) {
      AppToasts.errorToast(e.toString());
    }
  }

  // returns a map of a single record with key is api url and value is secret key
  Future<Map> readApiConnectionFromPrefs() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String apiURL = prefs.getString('apiURL') ?? '';
      final String secretKey = prefs.getString('secretKey') ?? '';
      return {apiURL: secretKey};
    } catch (e) {
      AppToasts.errorToast('Unknown Server'.tr);
      return {'': ''};
    }
  }

  Future<bool> readUserFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('userData');
    if (userData != null) {
      final data = json.decode(userData);
      userModel = UserModel.fromJson(data);
      return true;
    }
    return false;
  }

  Future<void> clearDataFromPrefs(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
