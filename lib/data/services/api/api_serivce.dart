import 'package:mastering_tests/utils/result.dart';

enum MetodoHttp {
  get,
  post,
  put,
  delete,
}
abstract interface class ApiClient {
  Future<Result<dynamic>> request({required String url, required MetodoHttp metodo, Map? body, Map? headers});
}