// import 'package:http/http.dart' as http;
// import 'package:taskplus/Controller/workspaceService.dart';

// void main() async {
//   // Fetch workspaces
//   print('Fetching workspaces...');
//   try {
//     final workspaces = await WorkspaceService.fetchWorkspaces();
//     print('Fetched workspaces: $workspaces');
//   } catch (e) {
//     print('Error fetching workspaces: $e');
//   }

//   // Fetch a single workspace
//   print('\nFetching workspace...');
//   try {
//     final workspace = await WorkspaceService.fetchWorkspace(1);
//     print('Fetched workspace: $workspace');
//   } catch (e) {
//     print('Error fetching workspace: $e');
//   }

//   // Create a workspace
//   print('\nCreating workspace...');
//   try {
//     await WorkspaceService.createWorkspace('test', 'test');
//     print('Workspace created successfully');
//   } catch (e) {
//     print('Error creating workspace: $e');
//   }
// }
