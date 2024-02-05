import 'dart:convert';

import 'package:client/src/design/domain/block_model.dart';
import 'package:client/src/project/data/project_model.dart';
import 'package:client/src/project/domain/base_project_repository.dart';
import 'package:http/http.dart' as http;

class ProjectRepository extends BaseProjectRepository {
  static const baseUrl = 'http://127.0.0.1:8080/project';

  @override
  Future<Project> createProject(
      String userName, String password, Project project) async {
    final url = Uri.parse("$baseUrl/$userName/$password");

    try {
      final response = await http.post(
        url,
        headers: {
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Credentials":
              'true', // Required for cookies, authorization headers with HTTPS
          "Access-Control-Allow-Headers":
              "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
          "Access-Control-Allow-Methods": "POST, OPTIONS",
          'Content-Type': 'application/json',
          'Accept': '*/*'
        },
        body: jsonEncode(project.toJson()),
      );
      if (response.statusCode == 200) {
        // Başarılı bir şekilde oluşturulan proje
        final Map<String, dynamic> responseData = json.decode(response.body);
        return Project.fromJson(responseData);
      } else {
        throw Exception('Failed to . Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  @override
  Future<List<Project>> getAllProjectsWithUser(
      String userName, String password) async {
    final url = Uri.parse("$baseUrl/$userName/$password");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        List<Project> projects =
            responseData.map((data) => Project.fromJson(data)).toList();
        return projects;
      } else {
        throw Exception(
            'Failed to fetch projects. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  @override
  Future<void> getOneProject(int projectId) {
    // TODO: implement getOneProject
    throw UnimplementedError();
  }

  @override
  Future<void> updateProject(Project project) {
    // TODO: implement updateProject
    throw UnimplementedError();
  }

  @override
  Future<Project> getOneProjectWithBlocks(int projectId) async {
    final url = Uri.parse("$baseUrl/withBlocks/$projectId");

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        return Project.fromJson(jsonData);
      } else {
        throw Exception(
            'Failed to fetch project with blocks. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  @override
  Future<Project> saveBlocks(int projectId, List<Block> blocks) async {
    final url = Uri.parse("$baseUrl/$projectId");

    final response = await http.post(
      url,
      headers: {
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials":
            'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":
            "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      },
      body: jsonEncode(blocks.map((block) => block.toJson()).toList()),
    );

    if (response.statusCode == 200) {
      // Giriş başarılı
      return Project.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to save blocks');
    }
  }

  @override
  Future<void> deleteBlocks(int projectId) async {
    final url = Uri.parse("$baseUrl/$projectId/clear");
    final response = await http.delete(
      url,
      headers: {
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials":
            'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":
            "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      },
    );
    if (response.statusCode == 200) {
      print('Blocks cleared successfully.');
    } else {
      print('Failed to clear blocks. Status code: ${response.statusCode}');
    }
  }
}
