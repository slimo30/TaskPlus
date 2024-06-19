import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:taskplus/Controller/Authentification.dart';
import 'package:taskplus/Model/Member.dart';
import 'package:taskplus/utils/link.dart';

class MemberService {
  String baseUrl = baseurl;

  MemberService({required this.baseUrl});

  Future<List<Member>> getMembers() async {
    final url = Uri.parse('$baseUrl/members/');
    final response = await http.get(
      url,
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      // If the server returns 200 OK, parse the response body
      final List<dynamic> responseData = json.decode(response.body);
      // Map the response data to List<Member>
      List<Member> members =
          responseData.map((data) => Member.fromJson(data)).toList();
      return members;
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to fetch members');
    }
  }

  Future<Member> getMember(int id) async {
    final url = Uri.parse('$baseUrl/members/$id');
    final response = await http.get(
      url,
      headers:
          await getHeaders(), // Assuming getHeaders() provides necessary headers
    );

    if (response.statusCode == 200) {
      // If the server returns 200 OK, parse the response body
      final data = json.decode(response.body);
      // Create a Member from the response data
      Member member = Member.fromJson(data);
      return member;
    } else {
      throw Exception('Failed to fetch member');
    }
  }

  Future<Member> updateMember(Member member) async {
    final url = Uri.parse('$baseUrl/members/${member.id}/');
    final response = await http.put(
      url,
      headers:
          await getHeaders(), // Assuming getHeaders() provides necessary headers
      body: jsonEncode(member.toJson()),
    );

    if (response.statusCode == 200) {
      // If the server returns 200 OK, parse the response body
      final data = json.decode(response.body);
      // Create a Member from the response data
      Member updatedMember = Member.fromJson(data);
      return updatedMember;
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to update member');
    }
  }
}
