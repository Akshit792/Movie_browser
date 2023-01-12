import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class MBNetworkException {
  final int statusCode;

  MBNetworkException({required this.statusCode});
}

class ApiClient {
  final http.Client httpClient;
  final Logger logger = Logger();

  Future<Map<String, dynamic>> getResource(
    String path, {
    Map<String, String>? queryParams,
  }) async {
    Uri uri = createUri(path, queryParams: queryParams);
    print('URI: ' + uri.toString());

    final http.Response response = await httpClient.get(uri);
    print('Response: ' + response.body);

    return _handleResponse(response);
  }

  Uri createUri(
    String path, {
    Map<String, dynamic>? queryParams,
    int? pageSize,
    int? pageNumber,
  }) {
    Map<String, dynamic> _queryParams = {};
    if (queryParams != null) {
      _queryParams.addAll(queryParams);
    }

    final uri = Uri(
      scheme: 'https',
      host: 'api.themoviedb.org',
      path: "/3/$path",
      queryParameters: _queryParams,
    );
    return uri;
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if ((response.statusCode < 200 || response.statusCode > 204)) {
      logger.e("_handleResponse, HTTPS", response.statusCode);
      logger.e(response.body.toString());
      throw MBNetworkException(statusCode: response.statusCode);
    }
    try {
      if (response.body.isNotEmpty) {
        String responseBody = response.body;
        final body = jsonDecode(responseBody);
        return body;
      } else {
        Map<String, dynamic> map = {};
        return map;
      }
    } catch (e, s) {
      logger.e("_handleResponse, HTTPS", e, s);
      return {};
    }
  }

  ApiClient({required this.httpClient});
}
