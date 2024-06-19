// authentication_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskplus/Model/user.dart';
import 'package:taskplus/utils/link.dart';

class AuthenticationService {
  String loginUrl = '$baseurl/login/';
  String signupUrl = '$baseurl/signup/';
  Future<Map<String, dynamic>?> login(User user) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        body: {
          'username': user.username,
          'password': user.password,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Check if the 'token' key exists in the response
        if (data.containsKey('token')) {
          final String token = data['token'];
          saveTokenLocally(token);

          // Check if the 'id' key exists in the response
          if (data.containsKey('id')) {
            final String id = data['id'].toString();
            print(id.toString());
            saveMemberIdLocally(id);
          } else {
            debugPrint('Member id not found in the response');
          }

          return data;
        } else {
          debugPrint('Token not found in the response');
          return null;
        }
      } else {
        debugPrint('Login failed: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Error during login: $e');
      return null;
    }
  }

  Future<int> signup(User2 user) async {
    final response = await http.post(
      Uri.parse(signupUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': user.username,
        'password': user.password,
        'name': user.name,
      }),
    );

    print('Status code: ${response.statusCode}');
    if (response.statusCode == 201) {
      print('Signup successful');
    } else {
      print('Signup failed');
      print('Response body: ${response.body}');
    }

    return response.statusCode;
  }

  Future<void> saveTokenLocally(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    debugPrint('Token saved securely: $token');
  }

  Future<void> saveMemberIdLocally(String memberId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('MemberId', memberId);
    print(memberId);
    debugPrint('Member id saved');
  }
}

Future<String?> getTokenFromPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth_token');
}

Future<int> getMemberIdFromPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? memberId = prefs.getString('MemberId');
  return memberId != null ? int.parse(memberId) : 0;
}

Future<Map<String, String>> getHeaders() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? authToken = prefs.getString('auth_token');

  return {
    'Content-Type': 'application/json',
    'Authorization': 'Token $authToken',
  };
}

Future<void> removeAllInfoFromPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  debugPrint('All information removed from SharedPreferences');
}

Future<String?> getDeviceTokenFromPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('device_token');
}
