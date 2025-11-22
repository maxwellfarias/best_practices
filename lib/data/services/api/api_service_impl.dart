import 'package:dio/dio.dart';
import 'package:best_practices/data/services/api/api_serivce.dart';
import 'package:best_practices/exceptions/app_exception.dart';
import 'package:best_practices/utils/logger/custom_logger.dart';
import 'package:best_practices/utils/result.dart';

class ApiClientImpl implements ApiClient {
  final Dio _dio;
  final CustomLogger _logger;

  ApiClientImpl({required Dio dio, required CustomLogger logger})  : _dio = dio, _logger = logger;

  final timeOutDuration = Duration(seconds: 10);
  // final String _logTag = 'ApiClient';

 @override
  Future<Result<dynamic>> request({required String url, required MetodoHttp metodo, Map? body, Map? headers}) async {
    //construção dos headers
    final defaultHeaders = headers?.cast<String, String>() ?? {}
          ..addAll({
            'content-type': 'application/json',
            'accept': 'application/json',
          });
    try {
      Response response;
      switch (metodo) {
        case MetodoHttp.post:
          response = await _dio.post(url, options: Options(headers: defaultHeaders), data: body)
              .timeout(timeOutDuration);
          break;
        case MetodoHttp.get:
          response = await _dio.get(url, options: Options(headers: defaultHeaders))
              .timeout(timeOutDuration);
          break;
        case MetodoHttp.put:
          response = await _dio.put(url, options: Options(headers: defaultHeaders), data: body)
              .timeout(timeOutDuration);
          break;
        case MetodoHttp.delete:
          response = await _dio.delete(url, options: Options(headers: defaultHeaders))
              .timeout(timeOutDuration);
          break;
      }
      return _handleResponse(response);
    } catch (e, stackTrace) {
      _logger.error('Erro inesperado na requisição ${metodo.name} para $url: $e', error: e, stackTrace: stackTrace);
      return Result.error(UnknownErrorException());
    }
  }

  Result<dynamic> _handleResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        _logger.debug('Resposta HTTP 200 - Sucesso');
        return Result.ok(response.data);
      case 204:
        _logger.debug('Resposta HTTP 204 - Sem conteúdo');
        return Result.ok(null);
      case 400:
        _logger.warning('Resposta HTTP 400 - Requisição inválida');
        return Result.error(ErroDeComunicacaoException());
      case 401:
        _logger.warning('Resposta HTTP 401 - Não autorizado');
        return Result.error(SessaoExpiradaException());
      case 403:
        _logger.warning('Resposta HTTP 403 - Acesso negado');
        return Result.error(AcessoNegadoException());
      case 404:
        _logger.warning('Resposta HTTP 404 - Recurso não encontrado');
        return Result.error(RecursoNaoEncontradoException());
      case 500:
        _logger.error('Resposta HTTP 500 - Erro interno do servidor');
        return Result.error(ErroInternoServidorException());
      case 503:
        _logger.error('Resposta HTTP 503 - Servidor indisponível');
        return Result.error(ServidorIndisponivelException());
      default:
        _logger.error('Resposta HTTP ${response.statusCode} - Erro desconhecido');
        return Result.error(UnknownErrorException());
    }
  }
  
}
