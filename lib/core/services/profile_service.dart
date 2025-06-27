import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shortly_provider/core/network/network_config.dart';
import 'package:shortly_provider/core/managers/shared_preference_manager.dart';
import 'package:shortly_provider/core/constants/app_strings.dart';

class ProfileService {
  static Future<String?> _getToken() async {
    // Get token from shared preferences
    return SharedPreferencesManager.getString(STRING_KEY_APPTOKEN);
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

  static Future<Map<String, dynamic>> updateProfile(
      Map<String, dynamic> data) async {
    final token = await _getToken();
    final url = '${NetworkConfig.baseUrl}/auth/provider-profile';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update profile');
    }
  }

  static Future<List<dynamic>> getProviderServices() async {
    final token = await _getToken();
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
      return data['services'] ?? [];
    } else {
      throw Exception('Failed to load services');
    }
  }

  static Future<Map<String, dynamic>> addProviderService(
      Map<String, dynamic> serviceData) async {
    final token = await _getToken();
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
    } else {
      throw Exception('Failed to add service');
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
}
