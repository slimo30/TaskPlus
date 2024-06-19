import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:taskplus/Controller/Authentification.dart';
import 'package:taskplus/Controller/MmberServices.dart';
import 'package:taskplus/Model/workspace.dart';
import 'package:taskplus/Model/workspca2.dart';
import 'package:taskplus/utils/link.dart';

class WorkspaceService {
  static String baseUrl = '$baseurl/workspaces';

  static Future<List<Workspace>> fetchWorkspaces() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => Workspace.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load workspaces');
    }
  }

  static Future<Workspace> fetchWorkspace(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return Workspace.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load workspace');
    }
  }

  static Future<void> creatWorkspcae(Workspace2 workspace) async {
    var memberId = await getMemberIdFromPrefs();
    final url = Uri.parse('$baseUrl/create/$memberId/');

    final response = await http.post(
      url,
      headers: await getHeaders(),
      body: jsonEncode(workspace.toJson()),
    );

    if (response.statusCode == 201) {
      print('Data posted successfully');
    } else {
      throw Exception('Failed to post data');
    }
  }
}

Future<int> getWorkspaceId() async {
  var memberId = await getMemberIdFromPrefs();
  var memberService = MemberService(baseUrl: baseurl);
  var member = await memberService.getMember(memberId);
  return member.workspace!;
}
