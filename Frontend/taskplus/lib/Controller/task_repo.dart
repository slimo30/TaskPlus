import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:taskplus/Controller/Authentification.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http; // Importing http package with an alias
import 'package:taskplus/Model/TaskModel.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:taskplus/utils/link.dart';

import 'package:path_provider/path_provider.dart'; // For getting the download directory
import 'package:path/path.dart' as path; // For handling file paths

class TaskRepository {
  final String baseUrl;

  TaskRepository({required this.baseUrl});

  Future<List<Task>> getTasks() async {
    final response = await http.get(
      Uri.parse('$baseUrl/tasks/'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((task) => Task.fromJson(task)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<Task> getTaskDetail(int taskId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/tasks/$taskId/'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load task detail');
    }
  }

  Future<List<Task>> getTasksByMission(int missionId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/missions/$missionId/tasks/'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((task) => Task.fromJson(task)).toList();
    } else {
      throw Exception('Failed to load tasks by mission');
    }
  }

  Future<List<Task>> getTasksByMember(int memberId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/members/$memberId/tasks/'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((task) => Task.fromJson(task)).toList();
    } else {
      throw Exception('Failed to load tasks by member');
    }
  }

  Future<List<Task>> getTasksByHistorymember(int memberId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/tasks/member/history/$memberId/'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((task) => Task.fromJson(task)).toList();
    } else {
      throw Exception('Failed to load tasks by member');
    }
  }

  Future<Task> createTask(Task task) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tasks/'),
      headers: await getHeaders(),
      body: json.encode(task.toJson()),
    );

    if (response.statusCode == 201) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create task');
    }
  }

  Future<Task> updateTask(Task task) async {
    final response = await http.put(
      Uri.parse('$baseUrl/tasks/${task.taskId}/'),
      headers: await getHeaders(),
      body: json.encode(task.toJson()),
    );

    if (response.statusCode == 200) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update task');
    }
  }

  Future<void> deleteTask(int taskId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/tasks/$taskId/'),
      headers: await getHeaders(),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete task');
    }
  }
}

Future<void> createTaskWithAttachment({
  required Task task,
  required File file,
}) async {
  var uri = Uri.parse('$baseurl/tasks/${task.taskId}/');
  var request = http.MultipartRequest('PUT', uri);

  // Add headers
  var headers = await getHeaders();
  headers.forEach((key, value) {
    request.headers[key] = value;
  });

  // Add form fields
  request.fields['title'] = task.title;
  request.fields['description'] = task.description;
  request.fields['priority'] = task.priority;
  request.fields['state'] = task.state;
  request.fields['deadline'] = task.deadline.toIso8601String();
  request.fields['time_created'] = task.timeCreated.toIso8601String();
  request.fields['time_to_alert'] = task.timeToAlert.toString();
  request.fields['task_owner'] = task.taskOwner.toString();
  request.fields['mission'] = task.mission.toString();

  // Add file
  var fileStream = http.ByteStream(DelegatingStream.typed(file.openRead()));
  var length = await file.length();
  var multipartFile = http.MultipartFile('file_attachment', fileStream, length,
      filename: basename(file.path));
  request.files.add(multipartFile);

  // Send request and handle response
  try {
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      print('File added to task successfully.');
    } else {
      print('Failed to add file to task: ${response.statusCode}');
      print(response.body);
    }
  } catch (e) {
    print('Error adding file to task: $e');
  }
}

Future<String> downloadFile(int taskId) async {
  final response = await http.get(
    Uri.parse('$baseurl/tasks/$taskId/download_file/'),
    headers: await getHeaders(),
  );

  if (response.statusCode == 200) {
    // Get the downloads directory
    Directory? downloadsDirectory = await getDownloadsDirectory();

    if (downloadsDirectory != null) {
      // Extract file name from response headers or URL
      String? contentDisposition = response.headers['content-disposition'];
      String fileName;

      if (contentDisposition != null &&
          contentDisposition.contains('filename=')) {
        fileName = contentDisposition
            .split('filename=')[1]
            .replaceAll('"', '')
            .replaceAll("'", "");
      } else {
        fileName =
            path.basename(Uri.parse(response.request!.url.toString()).path);
      }

      // Create a file path for the downloaded file
      String filePath = path.join(downloadsDirectory.path, fileName);

      // Write the response bytes to a file
      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      print('File saved to $filePath');
      return filePath;
    } else {
      throw Exception('Could not get downloads directory');
    }
  } else {
    throw Exception('Failed to download file: ${response.statusCode}');
  }
}

Future<Directory?> getDownloadsDirectory() async {
  return await getExternalStorageDirectory(); // This works for Android
  // For iOS, you might need to use getApplicationDocumentsDirectory()
}

Future<int> completeTask(int taskId) async {
  try {
    var response = await http.post(
      Uri.parse('$baseurl/task/$taskId/complete/'),
      headers: await getHeaders(),
      body: jsonEncode(<String, dynamic>{
        // If your API requires any data in the body, add it here
      }),
    );

    return response.statusCode;
  } catch (e) {
    print('Failed to complete task. Exception: $e');
    return 500; // Return a custom status code or handle the exception as needed
  }
}
