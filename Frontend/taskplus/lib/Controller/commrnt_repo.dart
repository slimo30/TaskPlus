import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:taskplus/Controller/Authentification.dart';
import 'package:taskplus/Model/CommentModel.dart';
import 'package:taskplus/utils/link.dart';

class CommentRepository {
  Future<List<Comment>> fetchComments(int taskId) async {
    final response = await http.get(
      Uri.parse('$baseurl/comments/task/$taskId/'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((json) => Comment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<void> updateComment(Comment comment) async {
    final response = await http.post(
      Uri.parse('$baseurl/comments/${comment.id}/'),
      headers: await getHeaders(),
      body: jsonEncode(comment.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update comment');
    }
  }

  Future<void> createComment(Comment comment) async {
    final response = await http.post(
      Uri.parse('$baseurl/comments/'),
      headers: await getHeaders(),
      body: jsonEncode(comment.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create comment');
    }
  }
}
