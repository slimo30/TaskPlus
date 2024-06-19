import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:taskplus/Controller/Authentification.dart';
import 'package:taskplus/Controller/workspaceService.dart';
import 'package:taskplus/Model/Member.dart';

class MemberRepository {
  final String baseUrl;

  MemberRepository(this.baseUrl);

  Future<List<Member>> fetchMembers() async {
    int workspace = await getWorkspaceId();
    final url = Uri.parse('$baseUrl/workspaces/$workspace/members/');
    final response = await http.get(
      url,
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      Iterable jsonResponse = jsonDecode(response.body);
      List<Member> members =
          jsonResponse.map((model) => Member.fromJson(model)).toList();
      return members;
    } else {
      throw Exception('Failed to fetch members');
    }
  }

  Future<void> updateMember(Member member) async {
    final url = Uri.parse('$baseUrl/members/${member.id}/');
    final response = await http.put(
      url,
      headers: await getHeaders(),
      body: jsonEncode(member.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update member');
    }
  }
}
