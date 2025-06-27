import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:shortly_provider/core/network/network_config.dart';
import '../../features/auth/data/auth_provider.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  static final FlutterSecureStorage _secureStorage =
      const FlutterSecureStorage();

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
      return jsonDecode(response.body);
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
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          await saveToken(data['token']);
        }
        return data;
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

  static Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  static Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  static Future<void> logout() async {
    await _secureStorage.delete(key: 'auth_token');
  }

  static Future<bool> isTokenValid() async {
    final token = await getToken();
    if (token == null || token.isEmpty) return false;
    try {
      final parts = token.split('.');
      if (parts.length != 3) return false;
      final payload =
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final payloadMap = json.decode(payload);
      if (payloadMap is! Map<String, dynamic>) return false;
      final exp = payloadMap['exp'];
      if (exp == null) return false;
      final expiry = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return DateTime.now().isBefore(expiry);
    } catch (e) {
      return false;
    }
  }
}
