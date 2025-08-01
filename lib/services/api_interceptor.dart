import 'dart:async';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'auth_service.dart';
import 'unauthorized_exception.dart';

class ApiInterceptor implements InterceptorContract {
  final AuthService authService;

  ApiInterceptor(this.authService);

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    final token = await authService.getToken();
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    if (request is Request) {
      request.headers['Content-Type'] = 'application/json';
    }
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse(
      {required BaseResponse response}) async {
    if (response.statusCode == 401) {
      authService.logout();
      throw UnauthorizedException('Session expired. Please log in again.');
    }
    return response;
  }

  @override
  FutureOr<bool> shouldInterceptRequest() {
    return true;
  }

  @override
  FutureOr<bool> shouldInterceptResponse() {
    return true;
  }
} 