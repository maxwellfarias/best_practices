import 'package:best_practices/infra/api/clients/http_get_client.dart';
import 'package:best_practices/infra/types/json.dart';
import 'package:dio/dio.dart';

final class HttpAdapter implements HttpGetClient {
  final Dio client;

  const HttpAdapter({
    required this.client
  });

  @override
  Future<dynamic> get({ required String url, Json? headers, Json? params, Json? queryString }) async {
    final response = await client.get(
      _buildUri(url: url, params: params, queryString: queryString),
      options: Options(headers: _buildHeaders(url: url, headers: headers))
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(Response response) {
    switch (response.statusCode) {
      case 200: {
        if (response.body.isEmpty) return null;
        return jsonDecode(response.body);
      }
      case 204: return null;
      case 401: throw SessionExpiredError();
      default: throw UnexpectedError();
    }
  }

  Map<String, String> _buildHeaders({ required String url, Json? headers }) {
    final defaultHeaders = { 'content-type': 'application/json', 'accept': 'application/json' };
    return defaultHeaders..addAll({ for (final key in (headers ?? {}).keys) key: headers![key].toString() });
  }

  String _buildUri({ required String url, Json? params, Json? queryString }) {
    url = params?.keys.fold(url, (result, key) => result.replaceFirst(':$key', params[key]?.toString() ?? '')).removeSuffix('/') ?? url;
    url = queryString?.keys.fold('$url?', (result, key) => '$result$key=${queryString[key]}&').removeSuffix('&') ?? url;
    return url;
  }
}