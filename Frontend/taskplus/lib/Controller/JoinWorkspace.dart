import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:taskplus/Controller/Authentification.dart';
import 'package:taskplus/utils/link.dart';

Future<int> joinWorkspace(String inviteCode) async {
  final url = Uri.parse('$baseurl/join-workspace/');
  final response = await http.post(
    url,
    headers: await getHeaders(),
    body: jsonEncode(<String, dynamic>{
      'member_id': await getMemberIdFromPrefs(),
      'invite_code': inviteCode,
    }),
  );

  if (response.statusCode == 200) {
    print('Joined workspace successfully');
  } else {
    print('Failed to join workspace');
    print('Response body: ${response.body}');
  }

  return response.statusCode;
}