import 'package:best_practices/exceptions/app_exception.dart';
import 'package:best_practices/infra/api/clients/http_get_client.dart';
import 'package:best_practices/infra/types/json.dart';
import 'package:best_practices/utils/logger/custom_logger.dart';
import 'package:best_practices/utils/result.dart';
import 'package:dio/dio.dart';

/// Cliente HTTP que gerencia requisições da API usando Dio
///
/// Responsabilidades:
/// - Executar requisições HTTP (GET, POST, PATCH, DELETE)
/// - Construir URIs e headers dinamicamente
/// - Tratar erros e converter em exceções específicas
/// - Logar operações para debug

final class HttpAdapter implements HttpGetClient {
  final Dio client;
  final CustomLogger? logger;
  static const String _logTag = 'HttpAdapter';

  const HttpAdapter({required this.client, this.logger});

  @override
  Future<Result<dynamic>> get({required String url, Json? headers, Json? params, Json? queryString}) async {
    try {
      final urlBuilt = _buildUrl(url: url, params: params, queryString: queryString);
      final requestHeaders = _buildHeaders(url: urlBuilt, headers: headers);

      logger?.info('GET request: $urlBuilt', tag: _logTag);

      final response = await client.get(
        urlBuilt,
        options: Options(headers: requestHeaders),
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (error, stackTrace) {
      logger?.error(
        'Erro inesperado: $error',
        tag: _logTag,
        error: error,
        stackTrace: stackTrace,
      );
      return Result.error(UnknownErrorException());
    }
  }

  /// Processa a resposta HTTP e converte em Result
  Result<dynamic> _handleResponse(Response response) {
    final statusCode = response.statusCode ?? 0;
    final exception = _getExceptionForStatusCode(statusCode);

    // Resposta com erro
    if (exception != null) {
      logger?.error('Erro HTTP $statusCode', tag: _logTag);
      return Result.error(exception);
    }

    // Resposta sem conteúdo (204 No Content)
    if (statusCode == 204) {
      logger?.info('Sucesso (sem conteúdo)', tag: _logTag);
      return Result.ok(null);
    }

    // Resposta com sucesso (200, 201, etc)
    logger?.info('Sucesso: $statusCode', tag: _logTag);

    // Verifica se o body está vazio
    if (response.data == null ||
        (response.data is String && (response.data as String).isEmpty)) {
      return Result.ok(null);
    }

    return Result.ok(response.data);
  }

  /// Trata erros do Dio e converte em Result
  Result<dynamic> _handleDioException(DioException e) {
    logger?.error('DioException: ${e.type}', tag: _logTag, error: e);

    // Se há resposta do servidor, processar status code
    if (e.response != null) {
      return _handleResponse(e.response!);
    }

    // Erros de timeout
    if (_isTimeoutError(e.type)) {
      return Result.error(TimeoutDeRequisicaoException());
    }

    // Erros de conexão
    if (e.type == DioExceptionType.connectionError) {
      return Result.error(SemConexaoException());
    }

    // Outros erros
    return Result.error(ServidorIndisponivelException());
  }

  /// Retorna a exceção apropriada para cada status code
  AppException? _getExceptionForStatusCode(int statusCode) {
    return switch (statusCode) {
      200 || 201 || 204 || 206 => null, // Sucesso
      401 => SessaoExpiradaException(),
      403 => AcessoNegadoException(),
      404 => RecursoNaoEncontradoException(),
      500 => ErroInternoServidorException(),
      503 => ServidorIndisponivelException(),
      _ => ServidorIndisponivelException(),
    };
  }

  /// Verifica se é erro de timeout
  bool _isTimeoutError(DioExceptionType type) {
    return type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.receiveTimeout ||
        type == DioExceptionType.sendTimeout;
  }

  Map<String, String> _buildHeaders({required String url, Json? headers}) {
    final defaultHeaders = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    return defaultHeaders..addAll({
      for (final key in (headers ?? {}).keys) key: headers![key].toString(),
    });
  }

  /// Constrói a URI com parâmetros e query string
  String _buildUrl({required String url, Json? params, Json? queryString}) {
    // Substitui path parameters (ex: /users/:id)
    if (params != null && params.isNotEmpty) {
      url = params.keys.fold(
        url,
        (result, key) =>
            result.replaceFirst(':$key', params[key]?.toString() ?? ''),
      );
    }

    // Remove trailing slash
    if (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }

    // Adiciona query string
    if (queryString != null && queryString.isNotEmpty) {
      final queryParts = queryString.keys
          .map((key) => '$key=${queryString[key]}')
          .join('&');
      url = '$url?$queryParts';
    }

    return url;
  }
}
