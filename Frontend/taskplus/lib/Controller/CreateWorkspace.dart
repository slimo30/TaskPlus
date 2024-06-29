import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:taskplus/Controller/Authentification.dart';
import 'package:taskplus/utils/link.dart';

Future<void> createWorkspace(String name, String sector, int memberId) async {
  final String apiUrl = '$baseurl/create_workspace/';
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: await getHeaders(),
    body: jsonEncode(<String, dynamic>{
      'name': name,
      'sector': sector,
      'member_id': memberId,
    }),
  );

  if (response.statusCode == 201) {
    // Workspace created successfully
  } else {
    // Handle error
    throw Exception('Failed to create workspace');
  }
}
