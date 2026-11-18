import 'dart:async';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:flutter_getx_starter_template/network/api_constants.dart';
import 'package:flutter_getx_starter_template/network/api_endpoints.dart';
import 'package:flutter_getx_starter_template/routes.dart';
import 'package:flutter_getx_starter_template/shared/services/auth.service.dart';
import 'package:flutter_getx_starter_template/shared/services/token.service.dart';
import 'package:flutter_getx_starter_template/utils/helpers/refresh_lock.dart';
import 'package:flutter_getx_starter_template/utils/managers/network_manager.dart';
import 'package:flutter_getx_starter_template/utils/theme/snackbar.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart'
    as get_response;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClientService extends GetxService {
  static ApiClientService get instance => Get.find<ApiClientService>();

  static const String enableLogExtraKey = 'enableLog';

  final dio.Dio _dio = dio.Dio();
  final RefreshLock _refreshLock = RefreshLock();
  final TokenService _tokenService = TokenService.instance;

  bool _globalLoggingEnabled = false;
  bool _loginRedirectInFlight = false;

  Future<ApiClientService> init({bool enableGlobalLogging = false}) async {
    _globalLoggingEnabled = enableGlobalLogging;
    await _initializeDio();
    return this;
  }

  Future<void> _initializeDio() async {
    _dio.options
      ..connectTimeout = const Duration(seconds: 30)
      ..receiveTimeout = const Duration(seconds: 30)
      ..sendTimeout = const Duration(seconds: 30)
      ..responseType = dio.ResponseType.json
      ..followRedirects = false;

    _dio.interceptors.clear();

    _dio.interceptors.add(
      dio.InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            final connected =
                await NetworkManager.instance.isConnected(withSnackbar: false);
            if (!connected) {
              return handler.reject(
                dio.DioException(
                  requestOptions: options,
                  type: dio.DioExceptionType.connectionError,
                  error: 'No internet connection',
                ),
              );
            }
          } catch (_) {}

          final requestPath = options.uri.path;
          if (!ApiConstants.isUnauthenticatedPath(requestPath)) {
            final token = _tokenService.authToken;
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }

          options.headers['content-type'] ??= 'application/json';
          options.headers['Accept'] ??= 'application/json';
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) async {
          final response = error.response;

          if (response?.statusCode == 502) {
            await _forceLogout();
            AppSnackbar.errorSnackBar(
              title: TranslationKeys.serverErrorTitle.tr,
              message: TranslationKeys.serverMaintenanceMessage.tr,
            );
            _redirectToLoginOnce();
            return handler.next(error);
          }

          if (response?.statusCode == 401) {
            final requestPath = response?.requestOptions.path ?? '';
            final isRefreshRequest =
                requestPath.contains(ApiEndpoints.authRefresh);

            if (isRefreshRequest) {
              await _forceLogout();
              _redirectToLoginOnce();
              return handler.next(error);
            }

            final alreadyRetried =
                response?.requestOptions.extra['__retried401__'] == true;
            if (!alreadyRetried) {
              await _refreshLock.lock();
              try {
                final refreshSuccess =
                    await TokenService.instance.attemptRefreshToken();
                if (!refreshSuccess) {
                  await _forceLogout();
                  _redirectToLoginOnce();
                  return handler.next(error);
                }

                final reqOptions = response!.requestOptions;
                final newOptions = reqOptions.copyWith(
                  headers: {
                    ...reqOptions.headers,
                    'Authorization': 'Bearer ${_tokenService.authToken}',
                  },
                  extra: {
                    ...reqOptions.extra,
                    '__retried401__': true,
                  },
                );
                try {
                  final retryResponse = await _dio.fetch(newOptions);
                  return handler.resolve(retryResponse);
                } catch (_) {
                  return handler.next(error);
                }
              } finally {
                _refreshLock.unlock();
              }
            } else if (_tokenService.authToken == null) {
              await _forceLogout();
              _redirectToLoginOnce();
              return handler.next(error);
            }
          }

          handler.next(error);
        },
      ),
    );

    if (!kReleaseMode) {
      _dio.interceptors.add(_createLogger());
    }
  }

  PrettyDioLogger _createLogger() {
    return PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: true,
      maxWidth: 120,
      filter: (options, _) {
        final perRequest = options.extra[enableLogExtraKey];
        if (perRequest is bool) return perRequest;
        return _globalLoggingEnabled;
      },
    );
  }

  void enableGlobalLogging(bool enabled) {
    _globalLoggingEnabled = enabled;
  }

  bool get isGlobalLoggingEnabled => _globalLoggingEnabled;

  HttpClientAdapter get httpClientInstance => HttpClientAdapter(_dio);

  Future<void> _forceLogout() async {
    if (Get.isRegistered<AuthService>()) {
      await AuthService.instance.logoutWithoutRefreshToken();
    } else {
      await TokenService.instance.clearTokens();
    }
  }

  void _redirectToLoginOnce() {
    if (_loginRedirectInFlight || Get.currentRoute == Routes.login) {
      return;
    }
    _loginRedirectInFlight = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (Get.currentRoute == Routes.login) {
        _loginRedirectInFlight = false;
        return;
      }
      Get.offAllNamed(Routes.login)?.whenComplete(() {
        _loginRedirectInFlight = false;
      });
    });
  }
}

class HttpClientAdapter {
  final dio.Dio _dio;

  HttpClientAdapter(this._dio);

  String get defaultContentType =>
      _dio.options.headers['content-type']?.toString() ?? '';

  Map<String, dynamic> _extraWithLogTag(
    Map<String, dynamic>? extra,
    bool? enableLog,
  ) {
    final merged = Map<String, dynamic>.from(extra ?? const {});
    if (enableLog != null) {
      merged[ApiClientService.enableLogExtraKey] = enableLog;
    }
    return merged;
  }

  Future<get_response.Response<T>> get<T>(
    String url, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    Map<String, dynamic>? extra,
    bool? enableLog,
  }) async {
    try {
      final res = await _dio.get(
        url,
        queryParameters: query,
        options: dio.Options(
          headers: headers,
          extra: _extraWithLogTag(extra, enableLog),
        ),
      );
      return _toGetxResponse<T>(res);
    } on dio.DioException catch (e) {
      return _toGetxErrorResponse<T>(e);
    }
  }

  Future<get_response.Response<T>> post<T>(
    String url,
    dynamic body, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    Map<String, dynamic>? extra,
    bool? enableLog,
  }) async {
    try {
      final res = await _dio.post(
        url,
        data: body,
        queryParameters: query,
        options: dio.Options(
          headers: headers,
          extra: _extraWithLogTag(extra, enableLog),
        ),
      );
      return _toGetxResponse<T>(res);
    } on dio.DioException catch (e) {
      return _toGetxErrorResponse<T>(e);
    }
  }

  Future<get_response.Response<T>> put<T>(
    String url,
    dynamic body, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    Map<String, dynamic>? extra,
    bool? enableLog,
  }) async {
    try {
      final res = await _dio.put(
        url,
        data: body,
        queryParameters: query,
        options: dio.Options(
          headers: headers,
          extra: _extraWithLogTag(extra, enableLog),
        ),
      );
      return _toGetxResponse<T>(res);
    } on dio.DioException catch (e) {
      return _toGetxErrorResponse<T>(e);
    }
  }

  Future<get_response.Response<T>> patch<T>(
    String url,
    dynamic body, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    Map<String, dynamic>? extra,
    bool? enableLog,
  }) async {
    try {
      final res = await _dio.patch(
        url,
        data: body,
        queryParameters: query,
        options: dio.Options(
          headers: headers,
          extra: _extraWithLogTag(extra, enableLog),
        ),
      );
      return _toGetxResponse<T>(res);
    } on dio.DioException catch (e) {
      return _toGetxErrorResponse<T>(e);
    }
  }

  Future<get_response.Response<T>> delete<T>(
    String url, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    Map<String, dynamic>? extra,
    bool? enableLog,
  }) async {
    try {
      final res = await _dio.delete(
        url,
        queryParameters: query,
        options: dio.Options(
          headers: headers,
          extra: _extraWithLogTag(extra, enableLog),
        ),
      );
      return _toGetxResponse<T>(res);
    } on dio.DioException catch (e) {
      return _toGetxErrorResponse<T>(e);
    }
  }

  Future<void> download(
    String url,
    String savePath, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    Map<String, dynamic>? extra,
    void Function(int received, int total)? onProgress,
    dio.CancelToken? cancelToken,
    bool? enableLog,
  }) async {
    await _dio.download(
      url,
      savePath,
      queryParameters: query,
      options: dio.Options(
        headers: headers,
        extra: _extraWithLogTag(extra, enableLog),
      ),
      onReceiveProgress: onProgress,
      cancelToken: cancelToken,
    );
  }

  get_response.Response<T> _toGetxResponse<T>(dio.Response res) {
    final data = res.data;
    if (data is Map) {
      data['api_status_code'] = res.statusCode;
    }
    return get_response.Response<T>(
      body: data,
      statusCode: res.statusCode,
      headers: res.headers.map.map((k, v) => MapEntry(k, v.join(','))),
      statusText: res.statusMessage,
    );
  }

  get_response.Response<T> _toGetxErrorResponse<T>(dio.DioException e) {
    final res = e.response;
    if (res != null) {
      return _toGetxResponse<T>(res);
    }
    return get_response.Response<T>(
      body: {'message': e.message} as dynamic,
      statusCode: 0,
      statusText: e.message,
    );
  }
}
