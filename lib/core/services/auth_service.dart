import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:shortly_provider/core/network/network_config.dart';
import '../../features/auth/data/auth_provider.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define a model class to hold provider data
class ProviderData {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? photo;
  final bool isProvider;
  final bool? isVerified;
  final String token;

  ProviderData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.photo,
    required this.isProvider,
    this.isVerified,
    required this.token,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'photo': photo,
    'isProvider': isProvider,
    'isVerified': isVerified,
    'token': token,
  };

  // Create from JSON
  factory ProviderData.fromJson(Map<String, dynamic> json, String token) {
    return ProviderData(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      photo: json['photo'],
      isProvider: json['isProvider'] ?? true,
      isVerified: json['isVerified'],
      token: token,
    );
  }
}

String? getMimeType(String path) {
  final ext = path.split('.').last.toLowerCase();
  switch (ext) {
    case 'jpg':
    case 'jpeg':
      return 'image/jpeg';
    case 'png':
      return 'image/png';
    case 'pdf':
      return 'application/pdf';
    default:
      return null;
  }
}

Future<http.MultipartFile> fileToMultipart(String field, File file) async {
  final mime = getMimeType(file.path);
  return await http.MultipartFile.fromPath(
    field,
    file.path,
    contentType: mime != null ? MediaType.parse(mime) : null,
  );
}

class AuthService {
  // Store keys for shared preferences
  static const String _authTokenKey = 'userToken';
  static const String _userDataKey = 'userData';

  // Save auth data to shared preferences
  static Future<void> _saveAuthData(String token, Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, token);
    await prefs.setString(_userDataKey, jsonEncode(userData));
  }

  // Get auth data from shared preferences
  static Future<ProviderData?> getAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_authTokenKey);
    final userDataStr = prefs.getString(_userDataKey);

    if (token == null || userDataStr == null) {
      return null;
    }

    try {
      final userData = jsonDecode(userDataStr) as Map<String, dynamic>;
      // Make sure it's a provider account
      if (!(userData['isProvider'] ?? false)) {
        return null;
      }
      return ProviderData.fromJson(userData, token);
    } catch (e) {
      return null;
    }
  }

  // Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    final providerData = await getAuthData();
    return providerData != null;
  }

  // Logout - clear local storage
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authTokenKey);
    await prefs.remove(_userDataKey);
  }

  static Future<Map<String, dynamic>> requestProviderOTP(String phone) async {
    final url = '${NetworkConfig.baseUrl}/provider/auth/register/request-otp';
    final fullPhone = '+91$phone';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'fullPhone': fullPhone}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        return jsonDecode(response.body);
      } catch (_) {
        return {'success': true};
      }
    } else {
      try {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to send OTP'
        };
      } catch (_) {
        return {'success': false, 'message': 'Failed to send OTP'};
      }
    }
  }

  static Future<Map<String, dynamic>> verifyProviderOTP(
      String phone, String otp) async {
    final url = '${NetworkConfig.baseUrl}/provider/auth/register/verify-otp';
    final fullPhone = '+91$phone';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'otp': otp, 'fullPhone': fullPhone}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        return jsonDecode(response.body);
      } catch (_) {
        return {'success': true};
      }
    } else {
      try {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'OTP verification failed'
        };
      } catch (_) {
        return {'success': false, 'message': 'OTP verification failed'};
      }
    }
  }

  static Future<Map<String, dynamic>> submitProviderRegistration(
      ProviderRegistrationProvider provider) async {
    final url = '${NetworkConfig.baseUrl}/provider/auth/register/verify';
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add text fields
    request.fields['phone'] = provider.phone;
    request.fields['name'] = provider.name;
    request.fields['email'] = provider.email;
    request.fields['password'] = provider.password;
    request.fields['has_salon'] = provider.hasSalon.toString();
    request.fields['salon_address'] = provider.salonAddress;
    if (provider.salonLocation != null) {
      request.fields['salon_location'] = jsonEncode(provider.salonLocation);
    }
    for (final cat in provider.categories) {
      request.fields['categories'] = cat;
    }
    request.fields['subcategories'] =
        jsonEncode(provider.selectedSubcategories);
    request.fields['service_areas'] = jsonEncode(provider.serviceAreas
        .map((a) => {
      'name': a.name,
      'city': a.city,
      'coordinates': a.coordinates,
    })
        .toList());

    // Add files
    if (provider.photo != null) {
      request.files.add(await fileToMultipart('photo', provider.photo!));
    }
    if (provider.aadharCard != null) {
      request.files
          .add(await fileToMultipart('aadhar_card', provider.aadharCard!));
    }
    if (provider.panCard != null) {
      request.files.add(await fileToMultipart('pan_card', provider.panCard!));
    }

    // Send request
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);

      // If registration is successful and returns token and user data, save it
      if (responseData['token'] != null) {
        // Create user data object
        final userData = {
          '_id': responseData['_id'] ?? '',
          'name': responseData['name'] ?? '',
          'phone': responseData['phone'] ?? '',
          'email': responseData['email'] ?? '',
          'photo': responseData['photo'] ?? '',
          'isProvider': true,
          'isVerified': responseData['isVerified'] ?? false,
        };

        // Save to local storage
        await _saveAuthData(responseData['token'], userData);
      }

      return responseData;
    } else {
      try {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Registration failed'
        };
      } catch (_) {
        return {'success': false, 'message': 'Registration failed'};
      }
    }
  }

  static Future<Map<String, dynamic>> requestProviderLoginOTP(
      String phone) async {
    final url = '${NetworkConfig.baseUrl}/provider/auth/login/request-otp';
    final fullPhone = '+91$phone';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'fullPhone': fullPhone}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        return jsonDecode(response.body);
      } catch (_) {
        return {'success': true};
      }
    } else {
      try {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to send OTP'
        };
      } catch (_) {
        return {'success': false, 'message': 'Failed to send OTP'};
      }
    }
  }

  static Future<Map<String, dynamic>> verifyProviderLoginOTP(
      String phone, String otp) async {
    final url = '${NetworkConfig.baseUrl}/provider/auth/login/verify';
    final fullPhone = '+91$phone';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'otp': otp, 'fullPhone': fullPhone}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        final responseData = jsonDecode(response.body);

        // If login is successful and returns token, save auth data
        if (responseData['token'] != null) {
          // Create user data object
          final userData = {
            '_id': responseData['_id'] ?? '',
            'name': responseData['name'] ?? '',
            'phone': responseData['phone'] ?? '',
            'email': responseData['email'] ?? '',
            'photo': responseData['photo'] ?? '',
            'isProvider': true,
            'isVerified': responseData['isVerified'] ?? false,
          };

          // Save to local storage
          await _saveAuthData(responseData['token'], userData);

          // Add success flag to response
          responseData['success'] = true;
        }

        return responseData;
      } catch (_) {
        return {'success': true};
      }
    } else {
      try {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'OTP verification failed'
        };
      } catch (_) {
        return {'success': false, 'message': 'OTP verification failed'};
      }
    }
  }

  // Get auth token (convenience method)
  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey);
  }

  // Add auth header to request (utility method for other services)
  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getAuthToken();
    final headers = {
      'Content-Type': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }
}