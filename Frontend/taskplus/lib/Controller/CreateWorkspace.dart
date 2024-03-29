// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class WorkspaceService {
//   final String _baseUrl = 'http://your-api-url.com';

//   Future<void> createWorkspace(String name, String sector) async {
//     final response = await http.post(
//       Uri.parse('$_baseUrl/workspaces/create'),
//       headers: await 
//       body: jsonEncode(<String, String>{
//         'name': name,
//         'sector': sector,
//       }),
//     );

//     if (response.statusCode == 200) {
//       // If the server returns a 200 OK response,
//       // then parse the JSON.
//       print('Workspace created successfully');
//     } else {
//       // If the server returns an unexpected response,
//       // then throw an exception.
//       throw Exception('Failed to create workspace');
//     }
//   }
// }