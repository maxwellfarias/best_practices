import 'package:dio/dio.dart';
import 'package:mastering_tests/data/services/api/api_serivce.dart';
import 'package:mastering_tests/exceptions/app_exception.dart';
import 'package:mastering_tests/utils/result.dart';
import '../../models/task_api_model.dart';

/// Interface para o serviço de API de tarefas
/// 
/// Define o contrato para comunicação com a API REST.
/// Separado do repositório para permitir diferentes implementações
/// (Supabase, Firebase, REST API customizada, etc.)


/// Implementação do serviço usando Supabase REST API
class ApiClientImpl implements ApiClient {
  final Dio _dio;

  ApiClientImpl({ required Dio dio})  : _dio = dio;

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
    } catch (e) {
      // AppLogger.error( 'Erro inesperado na requisição ${metodo.name} para $url', tag: _logTag, error: e, stackTrace: stackTrace);
      return Result.error(UnknownErrorException());
    }
  }

  Result<dynamic> _handleResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        // AppLogger.debug('Resposta HTTP 200 - Sucesso', tag: _logTag);
        return Result.ok(response.data);
      case 204:
        // AppLogger.debug('Resposta HTTP 204 - Sem conteúdo', tag: _logTag);
        return Result.ok(null);
      case 400:
        // AppLogger.warning('Resposta HTTP 400 - Requisição inválida', tag: _logTag);
        return Result.error(ErroDeComunicacaoException());
      case 401:
        // AppLogger.warning('Resposta HTTP 401 - Não autorizado', tag: _logTag);
        return Result.error(SessaoExpiradaException());
      case 403:
        // AppLogger.warning('Resposta HTTP 403 - Acesso negado', tag: _logTag);
        return Result.error(AcessoNegadoException());
      case 404:
        // AppLogger.warning('Resposta HTTP 404 - Recurso não encontrado', tag: _logTag);
        return Result.error(RecursoNaoEncontradoException());
      case 500:
        // AppLogger.error('Resposta HTTP 500 - Erro interno do servidor', tag: _logTag);
        return Result.error(ErroInternoServidorException());
      case 503:
        // AppLogger.error('Resposta HTTP 503 - Servidor indisponível', tag: _logTag);
        return Result.error(ServidorIndisponivelException());
      default:
        // AppLogger.error('Resposta HTTP ${response.statusCode} - Erro desconhecido', tag: _logTag);
        return Result.error(UnknownErrorException());
    }
  }
  
}
