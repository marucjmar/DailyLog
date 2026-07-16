import 'package:daily_log/auth/data/api/errors.dart';
import 'package:daily_log/auth/data/dto/session_response.dart';
import 'package:dio/dio.dart';

class AuthApi {
  final Dio _dio;

  AuthApi({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 10),
                sendTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 15),
                headers: const {
                  'Content-Type': 'application/vnd.api+json',
                  'Accept': 'application/vnd.api+json',
                },
              ),
            );

  Future<SessionResponseDto> login({
    required Uri serverUri,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        serverUri.resolve('/api/json/sessions/password').toString(),
        data: {
          'data': {
            'type': 'session',
            'attributes': {
              'email': email,
              'password': password,
            },
          },
        },
      );

      final body = response.data;

      if (body == null) {
        throw const ApiException.invalidResponse();
      }

      try {
        return SessionResponseDto.fromJson(body);
      } on FormatException catch (error) {
        throw ApiException.invalidResponse(
          cause: error,
        );
      } on TypeError catch (error) {
        throw ApiException.invalidResponse(
          cause: error,
        );
      }
    } on ApiException {
      rethrow;
    } on DioException catch (error) {
      throw _mapDioException(error);
    } catch (error) {
      throw ApiException.unknown(
        cause: error,
      );
    }
  }

  ApiException _mapDioException(DioException error) {
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout =>
        ApiException.timeout(cause: error),

      DioExceptionType.connectionError =>
        ApiException.network(cause: error),

      DioExceptionType.badCertificate =>
        ApiException.badCertificate(cause: error),

      DioExceptionType.cancel =>
        const ApiException.cancelled(),

      DioExceptionType.badResponse =>
        _mapResponseError(error),

      DioExceptionType.unknown =>
        ApiException.network(cause: error),
    };
  }

  ApiException _mapResponseError(DioException error) {
    final statusCode = error.response?.statusCode;
    final parsedError = _extractJsonApiError(
      error.response?.data,
    );

    return switch (statusCode) {
      400 => ApiException.badRequest(
          code: parsedError.code,
          details: parsedError.detail,
        ),

      // Specyficzne mapowanie dla endpointu logowania.
      401 || 403 => const ApiException.invalidCredentials(),

      404 => const ApiException.notFound(),

      422 => ApiException.validation(
          code: parsedError.code,
          field: parsedError.field,
          details: parsedError.detail,
        ),

      final int code => ApiException.server(
          statusCode: code,
          code: parsedError.code,
          details: parsedError.detail,
        ),

      null => ApiException.network(cause: error),
    };
  }

  JsonApiErrorData _extractJsonApiError(Object? responseBody) {
    if (responseBody is! Map<String, dynamic>) {
      return JsonApiErrorData(
        detail: responseBody?.toString(),
      );
    }

    final errors = responseBody['errors'];

    if (errors is! List || errors.isEmpty) {
      return const JsonApiErrorData();
    }

    final firstError = errors.first;

    if (firstError is! Map<String, dynamic>) {
      return const JsonApiErrorData();
    }

    final source = firstError['source'];

    String? pointer;

    if (source is Map<String, dynamic>) {
      pointer = source['pointer'] as String?;
    }

    return JsonApiErrorData(
      code: firstError['code'] as String?,
      detail: firstError['detail'] as String?,
      field: _fieldFromPointer(pointer),
    );
  }

  String? _fieldFromPointer(String? pointer) {
    if (pointer == null || pointer.isEmpty) {
      return null;
    }

    final segments = pointer.split('/');

    return segments.isEmpty ? null : segments.last;
  }
}

class JsonApiErrorData {
  final String? code;
  final String? detail;
  final String? field;

  const JsonApiErrorData({
    this.code,
    this.detail,
    this.field,
  });
}