import 'package:get/get.dart';

mixin RepositoryErrorHandlers {
  String processErrorResponse(Response response) {
    final body = response.body;
    if (body is Map && body['statusMessage'] is String) {
      return body['statusMessage'];
    }
    if (body is Map && body['error_description'] is String) {
      return body['error_description'];
    }
    if (body is Map && body['errors'] is List && body['errors'].isNotEmpty) {
      final first = body['errors'].first;
      if (first is String) return first;
      if (first is Map && first['message'] is String) return first['message'];
    }
    return response.statusText ?? 'Request failed';
  }
}



