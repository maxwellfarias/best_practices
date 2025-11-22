import 'package:best_practices/utils/result.dart';

enum MetodoHttp {
  get,
  post,
  put,
  delete,
}
abstract interface class ApiClient {
  Future<Result<dynamic>> request({required String url, required MetodoHttp metodo, Map? body, Map? headers});
}