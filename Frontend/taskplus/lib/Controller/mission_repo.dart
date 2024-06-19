// lib/repository/mission_repository.dart
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:taskplus/Controller/Authentification.dart';
import 'package:taskplus/Controller/workspaceService.dart';
import 'package:taskplus/Model/Messions.dart';
import 'package:taskplus/utils/link.dart';

class MissionRepository {
  final String baseUrl = baseurl;

  Future<List<Mission>> fetchMissions() async {
    int workspace = await getWorkspaceId();

    final response = await http.get(
      Uri.parse("$baseUrl/workspace/$workspace/missions/"),
      headers: await getHeaders(),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Mission.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load missions');
    }
  }

  Future<void> addMission(Mission mission) async {
    final response = await http.post(
      Uri.parse("$baseUrl/missions/"),
      headers: await getHeaders(),
      body: json.encode(mission.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add mission');
    }
  }

  Future<void> updateMission(Mission mission) async {
    final response = await http.put(
      Uri.parse('$baseUrl/missions/${mission.id}/'),
      headers: await getHeaders(),
      body: json.encode(mission.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update mission');
    }
  }

  Future<void> deleteMission(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/missions/$id/'),
      headers: await getHeaders(),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete mission');
    }
  }
}
