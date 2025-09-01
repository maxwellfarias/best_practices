import 'package:dio/dio.dart';
import 'package:mastering_tests/exceptions/app_exception.dart';
import 'package:mastering_tests/utils/result.dart';
import '../../../domain/models/task.dart';
import '../../models/task_api_model.dart';

/// Interface para o serviço de API de tarefas
/// 
/// Define o contrato para comunicação com a API REST.
/// Separado do repositório para permitir diferentes implementações
/// (Supabase, Firebase, REST API customizada, etc.)

enum MetodoHttp {
  get,
  post,
  put,
  delete,
}
abstract interface class ApiClient {

  Future<Result<dynamic>> request({required String url, required MetodoHttp metodo, Map? body, Map? headers});


  /// Busca todas as tarefas da API
  Future<List<TaskApiModel>> getTasks();

  /// Busca uma tarefa específica por ID
  Future<TaskApiModel> getTask(String id);

  /// Cria uma nova tarefa na API
  Future<TaskApiModel> createTask(Task data);

  /// Atualiza uma tarefa existente na API
  Future<TaskApiModel> updateTask(String id, Task data);

  /// Remove uma tarefa da API
  Future<void> deleteTask(String id);
}

/// Implementação do serviço usando Supabase REST API
class ApiClientImpl implements ApiClient {
  final Dio _dio;
  final String _baseUrl;

  ApiClientImpl({
    required Dio dio,
    required String baseUrl,
  })  : _dio = dio,
        _baseUrl = baseUrl;

  final timeOutDuration = Duration(seconds: 10);
  final String _logTag = 'ApiClient';

  @override
  Future<List<TaskApiModel>> getTasks() async {
    try {
      final response = await _dio.get('$_baseUrl/tasks');
      
      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          message: 'Failed to fetch tasks: ${response.statusCode}',
        );
      }

      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => TaskApiModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '$_baseUrl/tasks'),
        message: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<TaskApiModel> getTask(String id) async {
    try {
      final response = await _dio.get('$_baseUrl/tasks/$id');
      
      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          message: 'Failed to fetch task: ${response.statusCode}',
        );
      }

      return TaskApiModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '$_baseUrl/tasks/$id'),
        message: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<TaskApiModel> createTask(Task data) async {
    try {
      final requestData = {
        'title': data.title,
        'description': data.description,
        'is_completed': false,
        'created_at': DateTime.now().toIso8601String(),
      };

      final response = await _dio.post(
        '$_baseUrl/tasks',
        data: requestData,
      );
      
      if (response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          message: 'Failed to create task: ${response.statusCode}',
        );
      }

      return TaskApiModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '$_baseUrl/tasks'),
        message: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<TaskApiModel> updateTask(String id, Task data) async {
    try {
      final requestData = <String, dynamic>{};
      
      requestData['title'] = data.title;
      requestData['description'] = data.description;
      requestData['is_completed'] = data.isCompleted;
      if (data.isCompleted == true) {
        requestData['completed_at'] = DateTime.now().toIso8601String();
      } else {
        requestData['completed_at'] = null;
      }
    
      final response = await _dio.patch(
        '$_baseUrl/tasks/$id',
        data: requestData,
      );
      
      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          message: 'Failed to update task: ${response.statusCode}',
        );
      }

      return TaskApiModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '$_baseUrl/tasks/$id'),
        message: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      final response = await _dio.delete('$_baseUrl/tasks/$id');
      
      if (response.statusCode != 204 && response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          message: 'Failed to delete task: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '$_baseUrl/tasks/$id'),
        message: 'Unexpected error: $e',
      );
    }
  }
  
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
        default:  
          // AppLogger.error('Método HTTP não suportado: ${metodo.name}', tag: _logTag);
          return Result.error(ErroDeComunicacaoException());
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
