import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://tamem.gamcoiraq.com/api';
  
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _token;
  
  // Create HTTP client that bypasses SSL verification (for development only)
  http.Client _createHttpClient() {
    final httpClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    return IOClient(httpClient);
  }

  // Get token from storage
  Future<String?> getToken() async {
    if (_token != null) return _token;
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    return _token;
  }

  // Save token to storage
  Future<void> saveToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Clear token (logout)
  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Login - Send OTP to phone
  Future<ApiResponse> login(String phone) async {
    final client = _createHttpClient();
    try {
      print('🔄 Calling login API with phone: $phone');
      
      final response = await client.post(
        Uri.parse('$baseUrl/auth/login'),
        body: {'phone': phone},
      );

      print('📡 Response status: ${response.statusCode}');
      print('📦 Response body: ${response.body}');

      // Try to parse response
      dynamic data;
      try {
        data = json.decode(response.body);
      } catch (e) {
        data = {'message': response.body};
      }
      
      // Accept 200, 201, and other 2xx status codes as success
      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('✅ Login successful');
        return ApiResponse(
          success: true,
          message: data['message'] ?? 'تم إرسال رمز التحقق بنجاح',
          data: data,
        );
      } else {
        print('❌ Login failed: ${response.statusCode}');
        return ApiResponse(
          success: false,
          message: data['message'] ?? 'حدث خطأ، يرجى المحاولة مرة أخرى',
          data: data,
        );
      }
    } catch (e) {
      print('🚨 Exception: $e');
      return ApiResponse(
        success: false,
        message: 'خطأ في الاتصال بالخادم: $e',
        error: e.toString(),
      );
    }
  }

  // Verify OTP
  Future<ApiResponse> verifyOtp(String phone, String otpCode) async {
    final client = _createHttpClient();
    try {
      print('🔄 Verifying OTP for phone: $phone');
      
      final response = await client.post(
        Uri.parse('$baseUrl/auth/verify-otp'),
        body: {
          'phone': phone,
          'otp_code': otpCode,
        },
      );

      print('📡 Response status: ${response.statusCode}');
      print('📦 Response body: ${response.body}');

      dynamic data;
      try {
        data = json.decode(response.body);
      } catch (e) {
        data = {'message': response.body};
      }
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Save token if provided
        if (data['token'] != null) {
          await saveToken(data['token']);
        }
        print('✅ OTP verified successfully');
        return ApiResponse(
          success: true,
          message: data['message'] ?? 'تم التحقق بنجاح',
          data: data,
        );
      } else {
        print('❌ OTP verification failed');
        return ApiResponse(
          success: false,
          message: data['message'] ?? 'رمز التحقق غير صحيح',
          data: data,
        );
      }
    } catch (e) {
      print('🚨 Exception: $e');
      return ApiResponse(
        success: false,
        message: 'خطأ في الاتصال بالخادم: $e',
        error: e.toString(),
      );
    }
  }

  // Get headers with auth token
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await getToken();
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Get index (dashboard data)
  Future<ApiResponse> getIndex() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/index'),
        headers: headers,
      );

      final data = json.decode(response.body);
      
      if (response.statusCode == 200) {
        return ApiResponse(success: true, data: data);
      } else {
        return ApiResponse(
          success: false,
          message: data['message'] ?? 'حدث خطأ',
          data: data,
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'خطأ في الاتصال بالخادم',
        error: e.toString(),
      );
    }
  }

  // Get all documents
  Future<ApiResponse> getAllDocuments() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/all/documents'),
        headers: headers,
      );

      final data = json.decode(response.body);
      
      if (response.statusCode == 200) {
        return ApiResponse(success: true, data: data);
      } else {
        return ApiResponse(
          success: false,
          message: data['message'] ?? 'حدث خطأ',
          data: data,
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'خطأ في الاتصال بالخادم',
        error: e.toString(),
      );
    }
  }

  // Get read documents
  Future<ApiResponse> getReadDocuments() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/read/documents'),
        headers: headers,
      );

      final data = json.decode(response.body);
      
      if (response.statusCode == 200) {
        return ApiResponse(success: true, data: data);
      } else {
        return ApiResponse(
          success: false,
          message: data['message'] ?? 'حدث خطأ',
          data: data,
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'خطأ في الاتصال بالخادم',
        error: e.toString(),
      );
    }
  }

  // Get unread documents
  Future<ApiResponse> getUnreadDocuments() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/unread/documents'),
        headers: headers,
      );

      final data = json.decode(response.body);
      
      if (response.statusCode == 200) {
        return ApiResponse(success: true, data: data);
      } else {
        return ApiResponse(
          success: false,
          message: data['message'] ?? 'حدث خطأ',
          data: data,
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'خطأ في الاتصال بالخادم',
        error: e.toString(),
      );
    }
  }

  // Send OTP for document
  Future<ApiResponse> sendDocumentOtp(int documentId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/document/send-otp'),
        headers: headers,
        body: {'document_id': documentId.toString()},
      );

      final data = json.decode(response.body);
      
      if (response.statusCode == 200) {
        return ApiResponse(
          success: true,
          message: data['message'] ?? 'تم إرسال رمز التحقق',
          data: data,
        );
      } else {
        return ApiResponse(
          success: false,
          message: data['message'] ?? 'حدث خطأ',
          data: data,
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'خطأ في الاتصال بالخادم',
        error: e.toString(),
      );
    }
  }

  // Verify document OTP
  Future<ApiResponse> verifyDocumentOtp(int documentId, String otpCode) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/document/verify-otp'),
        headers: headers,
        body: {
          'document_id': documentId.toString(),
          'otp_code': otpCode,
        },
      );

      final data = json.decode(response.body);
      
      if (response.statusCode == 200) {
        return ApiResponse(success: true, data: data);
      } else {
        return ApiResponse(
          success: false,
          message: data['message'] ?? 'رمز التحقق غير صحيح',
          data: data,
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'خطأ في الاتصال بالخادم',
        error: e.toString(),
      );
    }
  }

  // Confirm document receipt
  Future<ApiResponse> confirmDocumentReceipt(int documentId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/document/confirm-receipt'),
        headers: headers,
        body: {
          'document_id': documentId.toString(),
          'confirm': 'true',
        },
      );

      final data = json.decode(response.body);
      
      if (response.statusCode == 200) {
        return ApiResponse(
          success: true,
          message: data['message'] ?? 'تم تأكيد الاستلام بنجاح',
          data: data,
        );
      } else {
        return ApiResponse(
          success: false,
          message: data['message'] ?? 'حدث خطأ',
          data: data,
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'خطأ في الاتصال بالخادم',
        error: e.toString(),
      );
    }
  }
}

class ApiResponse {
  final bool success;
  final String? message;
  final dynamic data;
  final String? error;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.error,
  });
}
