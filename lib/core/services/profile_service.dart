import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shortly_provider/core/network/network_config.dart';
import 'package:shortly_provider/core/services/auth_service.dart';
import 'package:shortly_provider/core/constants/app_strings.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

class ProfileService {
  static final CloudinaryPublic _cloudinary = CloudinaryPublic(
    'dsh447lvk', // cloud name
    'mindbend_alumni_gallery', // upload preset
  );

  static Future<String?> _getToken() async {
    // Get token from secure storage
    return await AuthService.getToken();
  }

  static Future<Map<String, dynamic>> getProfile() async {
    final token = await _getToken();
    final url = '${NetworkConfig.baseUrl}/auth/provider-profile';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  static Future<String?> _uploadProfileImage(
      File imageFile, String userId) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'provider_${userId}_$timestamp';
      CloudinaryResponse response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          folder: 'provider_profile_images',
          publicId: fileName,
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      String transformedUrl = response.secureUrl
          .replaceFirst('upload/', 'upload/w_400,h_400,c_fill,q_auto,f_auto/');
      return transformedUrl;
    } catch (e) {
      return null;
    }
  }

  static Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data,
      {File? photo, bool removePhoto = false, String? userId}) async {
    final token = await _getToken();
    final url = '${NetworkConfig.baseUrl}/auth/provider-profile';
    final updateData = Map<String, dynamic>.from(data);
    if (removePhoto) {
      updateData['photo'] = '';
    } else if (photo != null && userId != null) {
      final photoUrl = await _uploadProfileImage(photo, userId);
      if (photoUrl != null) {
        updateData['photo'] = photoUrl;
      }
    }
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updateData),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update profile');
    }
  }

  static Future<List<dynamic>> getProviderServices() async {
    final token = await _getToken();

    // Check if token exists
    if (token == null || token.isEmpty) {
      throw Exception('No authentication token found. Please login again.');
    }

    final url = '${NetworkConfig.baseUrl}/providers/services';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // API returns a list directly, not a map with 'services' key
      return data is List ? data : [];
    } else if (response.statusCode == 401) {
      // Handle authentication errors specifically
      final errorData = jsonDecode(response.body);
      throw Exception(
          'Authentication failed: ${errorData['message'] ?? 'Please login again'}');
    } else {
      // Handle other errors
      final errorData = jsonDecode(response.body);
      throw Exception(
          'Failed to load services: ${errorData['message'] ?? 'Unknown error'}');
    }
  }

  static Future<Map<String, dynamic>> addProviderService(
      Map<String, dynamic> serviceData) async {
    final token = await _getToken();

    // Check if token exists
    if (token == null || token.isEmpty) {
      throw Exception('No authentication token found. Please login again.');
    }

    final url = '${NetworkConfig.baseUrl}/providers/services';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(serviceData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      // Handle authentication errors specifically
      final errorData = jsonDecode(response.body);
      throw Exception(
          'Authentication failed: ${errorData['message'] ?? 'Please login again'}');
    } else {
      // Handle other errors
      final errorData = jsonDecode(response.body);
      throw Exception(
          'Failed to add service: ${errorData['message'] ?? 'Unknown error'}');
    }
  }

  static Future<Map<String, dynamic>> removeProviderService(
      String serviceId) async {
    final token = await _getToken();
    final url = '${NetworkConfig.baseUrl}/providers/services/$serviceId';
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to remove service');
    }
  }

  static Future<List<dynamic>> getProviderServiceAreas() async {
    final token = await _getToken();
    final url = '${NetworkConfig.baseUrl}/providers/service-areas';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['serviceAreas'] ?? [];
    } else {
      throw Exception('Failed to load service areas');
    }
  }

  static Future<Map<String, dynamic>> addProviderServiceArea(
      Map<String, dynamic> areaData) async {
    final token = await _getToken();
    final url = '${NetworkConfig.baseUrl}/providers/service-areas';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(areaData),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add service area');
    }
  }

  static Future<Map<String, dynamic>> removeProviderServiceArea(
      String areaId) async {
    final token = await _getToken();
    final url = '${NetworkConfig.baseUrl}/providers/service-areas/$areaId';
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to remove service area');
    }
  }

  static Future<List<dynamic>> getAllServices() async {
    final token = await _getToken();
    final url = '${NetworkConfig.baseUrl}/services';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data is List ? data : [];
    } else {
      throw Exception('Failed to load available services');
    }
  }
}
