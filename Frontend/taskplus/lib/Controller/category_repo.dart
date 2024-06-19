// lib/repository/category_repository.dart

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:taskplus/Controller/Authentification.dart';
import 'package:taskplus/Controller/workspaceService.dart';
import 'package:taskplus/Model/Category.dart';
import 'package:taskplus/utils/link.dart';

class CategoryRepository {
  final String baseUrl = baseurl;

  Future<List<Category>> fetchCategories() async {
    var workspace = await getWorkspaceId();
    final response = await http.get(
        Uri.parse("$baseUrl/categories/workspace/$workspace/"),
        headers: await getHeaders());
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<void> addCategory(Category category) async {
    final response = await http.post(
      Uri.parse("$baseUrl/categories/"),
      headers: await getHeaders(),
      body: json.encode(category.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add category');
    }
  }
}
