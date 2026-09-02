import 'dart:convert';

import 'package:faceui/utils/consts.dart';
import 'package:http/http.dart' as http;

/// Backend API service for face recognition operations.
///
/// Integrates with the FastAPI backend endpoints for person registration
/// (single/multi image), face reference management, and person queries.
class ApiService {
  static String get _baseUrl => 'http://$url:$port';

  /// Upload an image for face detection/cropping.
  ///
  /// Returns `{'fileLocation': ..., 'imageData': Uint8List, 'mediaType': ...}`
  /// or null on failure.
  static Future<Map<String, dynamic>?> uploadImage(
      List<int> fileBytes, String filename,
      {bool isSearch = false}) async {
    try {
      final uri = Uri.parse('$_baseUrl/upload?isSearch=$isSearch');
      final request = http.MultipartRequest('POST', uri)
        ..files.add(http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: filename,
        ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return {
          'fileLocation': responseData['file_location'],
          'imageData': base64Decode(responseData['image_data']),
          'mediaType': responseData['media_type'],
        };
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Register a new person with a single image via `/insertKToDp`.
  static Future<Map<String, dynamic>> insertPersonSingle({
    required String name,
    required String imagePath,
    required String age,
    required String gender,
    required String role,
    required String socialnumber,
    String description = '',
    String userwhom = '',
  }) async {
    final uri = Uri.parse('$_baseUrl/insertKToDp');
    final body = {
      'name': name,
      'imagePath': imagePath,
      'age': age,
      'gender': gender,
      'role': role,
      'socialnumber': socialnumber,
    };
    final response = await http.post(uri,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to add person: ${response.body}');
  }

  /// Register a new person with multiple images via `/insertKToDpMulti`.
  static Future<Map<String, dynamic>> insertPersonMulti({
    required String name,
    required List<String> imagePaths,
    required String age,
    required String gender,
    required String role,
    required String socialnumber,
  }) async {
    final uri = Uri.parse('$_baseUrl/insertKToDpMulti');
    final body = {
      'name': name,
      'imagePaths': imagePaths,
      'age': age,
      'gender': gender,
      'role': role,
      'socialnumber': socialnumber,
    };
    final response = await http.post(uri,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to add person: ${response.body}');
  }

  /// Add a face reference image to an existing person via `/addFaceReference`.
  static Future<Map<String, dynamic>> addFaceReference({
    required String name,
    required String imagePath,
  }) async {
    final uri = Uri.parse('$_baseUrl/addFaceReference');
    final body = {
      'name': name,
      'imagePath': imagePath,
    };
    final response = await http.post(uri,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to add face reference: ${response.body}');
  }

  /// Remove a face reference by embedding index via `/removeFaceReference`.
  static Future<Map<String, dynamic>> removeFaceReference({
    required String name,
    required int embeddingIndex,
  }) async {
    final uri = Uri.parse('$_baseUrl/removeFaceReference');
    final body = {
      'name': name,
      'embeddingIndex': embeddingIndex,
    };
    final response = await http.post(uri,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to remove face reference: ${response.body}');
  }

  /// Get face details for a person via `/known-persons/{name}/faces`.
  static Future<Map<String, dynamic>?> getPersonFaces(String name) async {
    final uri = Uri.parse('$_baseUrl/known-persons/${Uri.encodeComponent(name)}/faces');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return null;
  }

  /// Get all known persons via `/known-persons`.
  static Future<List<Map<String, dynamic>>> getKnownPersons() async {
    final uri = Uri.parse('$_baseUrl/known-persons');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['persons'] ?? []);
    }
    return [];
  }

  /// Delete a known person via `/known-persons/{name}`.
  static Future<bool> deletePerson(String name) async {
    final uri =
        Uri.parse('$_baseUrl/known-persons/${Uri.encodeComponent(name)}');
    final response = await http.delete(uri);
    return response.statusCode == 200;
  }

  /// Refresh the known face database via `/util/refreshDb`.
  static Future<void> refreshDb() async {
    final uri = Uri.parse('$_baseUrl/util/refreshDb');
    await http.get(uri);
  }

  /// Take a picture from RTSP camera via `/takePicture`.
  static Future<Map<String, dynamic>?> takePicture(
      String rtspUrl, String camName) async {
    final uri = Uri.parse('$_baseUrl/takePicture');
    final body = {'rtspUrl': rtspUrl, 'camName': camName};
    final response = await http.post(uri,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return null;
  }
}
