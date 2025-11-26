import 'package:best_practices/infra/types/json.dart';
import 'package:best_practices/utils/result.dart';

abstract interface class HttpGetClient {
  Future<Result<dynamic>> get({
    required String url,
    Json? headers,
    Json? params,
    Json? queryString,
  });
}
