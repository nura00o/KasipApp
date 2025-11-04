import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiClient {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000';
    } else {
      return 'http://10.0.2.2:3000';
    }
  }

  static Future<Map<String, String>> _authHeaders() async {
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user?.getIdToken(true);
    return {
      "Content-Type": "application/json",
      if (idToken != null) "Authorization": "Bearer $idToken",
    };
  }

  static Future<http.Response> get(String path) async {
    final headers = await _authHeaders();
    return http.get(Uri.parse("$baseUrl$path"), headers: headers);

  }

  static Future<http.Response> post(String path, Map<String, dynamic> body) async {
    final headers = await _authHeaders();
    return http.post(
      Uri.parse("$baseUrl$path"),
      headers: headers,
      body: jsonEncode(body),
    );
  }
}
