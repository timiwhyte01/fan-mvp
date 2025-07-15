import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../../core/services/api_service.dart';
import '../../core/constants/app_constants.dart';

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState()) {
    _checkAuthStatus();
  }

  final ApiService _apiService = ApiService();

  Future<void> _checkAuthStatus() async {
    await _apiService.loadToken();
    if (_apiService.hasToken) {
      try {
        final response = await _apiService.get(ApiEndpoints.me);
        final user = User.fromJson(response.data);
        state = state.copyWith(user: user, isAuthenticated: true);
      } catch (e) {
        state = state.copyWith(isAuthenticated: false);
      }
    }
  }

  Future<bool> sendOtp(String phone) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _apiService.post(ApiEndpoints.sendOtp, data: {'phone': phone});
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _getErrorMessage(e),
      );
      return false;
    }
  }

  Future<bool> verifyOtp(String phone, String otpCode) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _apiService.post(ApiEndpoints.verifyOtp, data: {
        'phone': phone,
        'otp_code': otpCode,
      });
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _getErrorMessage(e),
      );
      return false;
    }
  }

  Future<bool> register({
    required String phone,
    required String firstName,
    required String lastName,
    required String pin,
    String? email,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _apiService.post(ApiEndpoints.register, data: {
        'phone': phone,
        'first_name': firstName,
        'last_name': lastName,
        'pin': pin,
        'email': email,
      });

      final token = response.data['access_token'];
      final user = User.fromJson(response.data['user']);

      await _apiService.setToken(token);
      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _getErrorMessage(e),
      );
      return false;
    }
  }

  Future<bool> login(String phone, String pin) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _apiService.post(ApiEndpoints.login, data: {
        'phone': phone,
        'pin': pin,
      });

      final token = response.data['access_token'];
      final user = User.fromJson(response.data['user']);

      await _apiService.setToken(token);
      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _getErrorMessage(e),
      );
      return false;
    }
  }

  Future<void> logout() async {
    await _apiService.setToken('');
    state = AuthState();
  }

  String _getErrorMessage(dynamic error) {
    if (error is DioException) {
      if (error.response?.data is Map) {
        return error.response?.data['detail'] ?? 'An error occurred';
      }
      return error.message ?? 'Network error';
    }
    return error.toString();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
