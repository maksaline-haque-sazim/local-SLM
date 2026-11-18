import 'package:flutter/foundation.dart';
import 'package:flutter_getx_starter_template/data/repositories/repository_error_handlers.dart';
import 'package:flutter_getx_starter_template/network/service/api_client.service.dart';
import 'package:flutter_getx_starter_template/shared/services/token.service.dart';
import 'package:get/get.dart';


abstract class BaseRepository with RepositoryErrorHandlers {
  HttpClientAdapter get _httpClient =>
      ApiClientService.instance.httpClientInstance;
  final TokenService tokenService = TokenService.instance;

  Future<Response<T>> getRequest<T>(
    String endpoint, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    String? phoneNumber,
    bool shouldHandleError = true,
    bool? enableLog,
  }) async {
    try {
      Response<T> response = await _httpClient
            .get(endpoint, query: query, headers: headers, enableLog: enableLog);
      if (!shouldHandleError) return response;
      if (!response.isOk) {
        String errorResponse = processErrorResponse(response);
        throw Exception(errorResponse);
      }
      return response;
    } catch (e) {
      debugPrint("Endpoint: $endpoint, query: $query, error: $e");
      throw Exception(e);
    }
  }

  Future<Response<T>> postRequest<T>(
    String endpoint,
    dynamic body, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    String? phoneNumber,
    bool shouldHandleError = true,
    bool? enableLog,
  }) async {
    try {
      Response<T> response = await _httpClient.post(endpoint, body,
          query: query,
          headers: headers,
          enableLog: enableLog);

      if (!shouldHandleError) return response;
      if (!response.isOk) {
        String errorResponse = processErrorResponse(response);
        throw Exception(errorResponse);
      }
      return response;
    } catch (e) {
      debugPrint("Endpoint: $endpoint, body: $body, query: $query, error: $e");
      throw Exception(e);
    }
  }

  Future<Response<T>> putRequest<T>(
    String endpoint,
    dynamic body, {
    Map<String, dynamic>? query,
    String? phoneNumber,
    bool shouldHandleError = true,
    bool? enableLog,
  }) async {
    try {
      Response<T> response = await _httpClient
          .put(endpoint, body, query: query, enableLog: enableLog);
      if (!shouldHandleError) return response;
      if (!response.isOk) {
        String errorResponse = processErrorResponse(response);
        throw Exception(errorResponse);
      }
      return response;
    } catch (e) {
      debugPrint("Endpoint: $endpoint, body: $body, query: $query, error: $e");
      throw Exception(e);
    }
  }

  Future<Response<T>> patchRequest<T>(
    String endpoint,
    dynamic body, {
    Map<String, dynamic>? query,
    String? phoneNumber,
    bool shouldHandleError = true,
    bool? enableLog,
  }) async {
    try {
      Response<T> response = await _httpClient
          .patch(endpoint, body, query: query, enableLog: enableLog);
      if (!shouldHandleError) return response;
      if (!response.isOk) {
        String errorResponse = processErrorResponse(response);
        throw Exception(errorResponse);
      }
      return response;
    } catch (e) {
      debugPrint("Endpoint: $endpoint, body: $body, query: $query, error: $e");
      throw Exception(e);
    }
  }

  Future<Response<T>> deleteRequest<T>(
    String endpoint, {
    Map<String, dynamic>? query,
    String? phoneNumber,
    bool shouldHandleError = true,
    bool? enableLog,
  }) async {
    try {
      Response<T> response = await _httpClient
          .delete(endpoint, query: query, enableLog: enableLog);
      if (!shouldHandleError) return response;
      if (!response.isOk) {
        String errorResponse = processErrorResponse(response);
        throw Exception(errorResponse);
      }
      return response;
    } catch (e) {
      debugPrint("Endpoint: $endpoint, query: $query, error: $e");
      throw Exception(e);
    }
  }
}
