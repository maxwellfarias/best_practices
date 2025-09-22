import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mastering_tests/data/services/api/api_serivce.dart';
import 'package:mastering_tests/data/services/api/api_service_impl.dart';
import 'package:mastering_tests/exceptions/app_exception.dart';
import 'package:mastering_tests/utils/result.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockResponse extends Mock implements Response {}

class MockOptions extends Mock implements Options {}

void main() {
  late ApiClientImpl apiClient;
  late MockDio mockDio;
  late MockResponse mockResponse;

  // Test data
  const testUrl = 'https://api.example.com/tasks';
  const testData = {'id': '1', 'title': 'Test Task'};
  final testHeaders = {'Authorization': 'Bearer token'};

  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(Options());
  });

  setUp(() {
    mockDio = MockDio();
    mockResponse = MockResponse();
    apiClient = ApiClientImpl(dio: mockDio);
  });

  group('ApiClientImpl', () {
    group('constructor', () {
      test('should initialize with provided Dio instance', () {
        // Arrange & Act
        final client = ApiClientImpl(dio: mockDio);

        // Assert
        expect(client, isA<ApiClient>());
        expect(client.timeOutDuration, equals(const Duration(seconds: 10)));
      });
    });

    group('request method', () {
      group('POST requests', () {
        test('should make successful POST request with correct parameters', () async {
          // Arrange
          when(() => mockResponse.statusCode).thenReturn(200);
          when(() => mockResponse.data).thenReturn(testData);
          when(() => mockDio.post(
                any(),
                options: any(named: 'options'),
                data: any(named: 'data'),
              )).thenAnswer((_) async => mockResponse);

          // Act
          final result = await apiClient.request(
            url: testUrl,
            metodo: MetodoHttp.post,
            body: testData,
            headers: testHeaders,
          );

          // Assert
          expect(result.isOk, isTrue);
          expect(result.valueOrNull, equals(testData));

          verify(() => mockDio.post(
                testUrl,
                options: any(named: 'options'),
                data: testData,
              )).called(1);
        });

        test('should make POST request with default headers when no custom headers provided', () async {
          // Arrange
          when(() => mockResponse.statusCode).thenReturn(200);
          when(() => mockResponse.data).thenReturn(testData);
          when(() => mockDio.post(
                any(),
                options: any(named: 'options'),
                data: any(named: 'data'),
              )).thenAnswer((_) async => mockResponse);

          // Act
          await apiClient.request(
            url: testUrl,
            metodo: MetodoHttp.post,
            body: testData,
          );

          // Assert
          final captured = verify(() => mockDio.post(
                testUrl,
                options: captureAny(named: 'options'),
                data: testData,
              )).captured;

          final options = captured.first as Options;
          expect(options.headers!['content-type'], equals('application/json'));
          expect(options.headers!['accept'], equals('application/json'));
        });

        test('should merge custom headers with default headers', () async {
          // Arrange
          when(() => mockResponse.statusCode).thenReturn(200);
          when(() => mockResponse.data).thenReturn(testData);
          when(() => mockDio.post(
                any(),
                options: any(named: 'options'),
                data: any(named: 'data'),
              )).thenAnswer((_) async => mockResponse);

          // Act
          await apiClient.request(
            url: testUrl,
            metodo: MetodoHttp.post,
            body: testData,
            headers: testHeaders,
          );

          // Assert
          final captured = verify(() => mockDio.post(
                testUrl,
                options: captureAny(named: 'options'),
                data: testData,
              )).captured;

          final options = captured.first as Options;
          expect(options.headers!['content-type'], equals('application/json'));
          expect(options.headers!['accept'], equals('application/json'));
          expect(options.headers!['Authorization'], equals('Bearer token'));
        });
      });

      group('GET requests', () {
        test('should make successful GET request with correct parameters', () async {
          // Arrange
          when(() => mockResponse.statusCode).thenReturn(200);
          when(() => mockResponse.data).thenReturn(testData);
          when(() => mockDio.get(
                any(),
                options: any(named: 'options'),
              )).thenAnswer((_) async => mockResponse);

          // Act
          final result = await apiClient.request(
            url: testUrl,
            metodo: MetodoHttp.get,
            headers: testHeaders,
          );

          // Assert
          expect(result.isOk, isTrue);
          expect((result as Ok).value, equals(testData));

          verify(() => mockDio.get(
                testUrl,
                options: any(named: 'options'),
              )).called(1);
        });

        test('should make GET request without body parameter', () async {
          // Arrange
          when(() => mockResponse.statusCode).thenReturn(200);
          when(() => mockResponse.data).thenReturn(testData);
          when(() => mockDio.get(
                any(),
                options: any(named: 'options'),
              )).thenAnswer((_) async => mockResponse);

          // Act
          await apiClient.request(
            url: testUrl,
            metodo: MetodoHttp.get,
          );

          // Assert
          verify(() => mockDio.get(
                testUrl,
                options: any(named: 'options'),
              )).called(1);
          verifyNever(() => mockDio.post(any(), data: any(named: 'data')));
        });
      });

      group('PUT requests', () {
        test('should make successful PUT request with correct parameters', () async {
          // Arrange
          when(() => mockResponse.statusCode).thenReturn(200);
          when(() => mockResponse.data).thenReturn(testData);
          when(() => mockDio.put(
                any(),
                options: any(named: 'options'),
                data: any(named: 'data'),
              )).thenAnswer((_) async => mockResponse);

          // Act
          final result = await apiClient.request(
            url: testUrl,
            metodo: MetodoHttp.put,
            body: testData,
            headers: testHeaders,
          );

          // Assert
          expect(result.isOk, isTrue);
          expect((result as Ok).value, equals(testData));

          verify(() => mockDio.put(
                testUrl,
                options: any(named: 'options'),
                data: testData,
              )).called(1);
        });
      });

      group('unsupported methods', () {
        test('should return success for DELETE method', () async {
          
          //Arrange
          when(() => mockResponse.statusCode)
            .thenReturn(200);
          when(() => mockDio.delete(any(), options: any(named: 'options')))
          .thenAnswer((_) async => mockResponse);
          
          // Act
          final result = await apiClient.request(
            url: testUrl,
            metodo: MetodoHttp.delete,
          );

          // Assert
          expect(result.isOk, isTrue);
        });
      });

      group('timeout handling', () {
        test('should apply timeout to POST requests', () async {
          // Arrange
          when(() => mockResponse.statusCode).thenReturn(200);
          when(() => mockResponse.data).thenReturn(testData);
          when(() => mockDio.post(
                any(),
                options: any(named: 'options'),
                data: any(named: 'data'),
              )).thenAnswer((_) async => mockResponse);

          // Act
          await apiClient.request(
            url: testUrl,
            metodo: MetodoHttp.post,
            body: testData,
          );

          // Assert
          verify(() => mockDio.post(
                any(),
                options: any(named: 'options'),
                data: any(named: 'data'),
              ).timeout(const Duration(seconds: 10))).called(1);
        });

        test('should apply timeout to GET requests', () async {
          // Arrange
          when(() => mockResponse.statusCode).thenReturn(200);
          when(() => mockResponse.data).thenReturn(testData);
          when(() => mockDio.get(
                any(),
                options: any(named: 'options'),
              )).thenAnswer((_) async => mockResponse);

          // Act
          await apiClient.request(
            url: testUrl,
            metodo: MetodoHttp.get,
          );

          // Assert
          verify(() => mockDio.get(
                any(),
                options: any(named: 'options'),
              ).timeout(const Duration(seconds: 10))).called(1);
        });

        test('should apply timeout to PUT requests', () async {
          // Arrange
          when(() => mockResponse.statusCode).thenReturn(200);
          when(() => mockResponse.data).thenReturn(testData);
          when(() => mockDio.put(
                any(),
                options: any(named: 'options'),
                data: any(named: 'data'),
              )).thenAnswer((_) async => mockResponse);

          // Act
          await apiClient.request(
            url: testUrl,
            metodo: MetodoHttp.put,
            body: testData,
          );

          // Assert
          verify(() => mockDio.put(
                any(),
                options: any(named: 'options'),
                data: any(named: 'data'),
              ).timeout(const Duration(seconds: 10))).called(1);
        });
      });

      group('exception handling', () {
        test('should return UnknownErrorException when Dio throws exception', () async {
          // Arrange
          when(() => mockDio.post(
                any(),
                options: any(named: 'options'),
                data: any(named: 'data'),
              )).thenThrow(Exception('Network error'));

          // Act
          final result = await apiClient.request(
            url: testUrl,
            metodo: MetodoHttp.post,
            body: testData,
          );

          // Assert
          expect(result.isError, isTrue);
          expect((result as Error).error, isA<UnknownErrorException>());
        });

        test('should return UnknownErrorException when timeout occurs', () async {
          // Arrange
          when(() => mockDio.get(
                any(),
                options: any(named: 'options'),
              )).thenThrow(DioException(
            requestOptions: RequestOptions(path: testUrl),
            type: DioExceptionType.sendTimeout,
          ));

          // Act
          final result = await apiClient.request(
            url: testUrl,
            metodo: MetodoHttp.get,
          );

          // Assert
          expect(result.isError, isTrue);
          expect((result as Error).error, isA<UnknownErrorException>());
        });
      });
    });

    group('_handleResponse method', () {
      group('success responses', () {
        test('should return Ok result for HTTP 200 with data', () async {
          // Arrange
          when(() => mockResponse.statusCode).thenReturn(200);
          when(() => mockResponse.data).thenReturn(testData);
          when(() => mockDio.get(any(), options: any(named: 'options')))
              .thenAnswer((_) async => mockResponse);

          // Act
          final result = await apiClient.request(
            url: testUrl,
            metodo: MetodoHttp.get,
          );

          // Assert
          expect(result.isOk, isTrue);
          expect((result as Ok).value, equals(testData));
        });

        test('should return Ok result with null for HTTP 204', () async {
          // Arrange
          when(() => mockResponse.statusCode).thenReturn(204);
          when(() => mockResponse.data).thenReturn(null);
          when(() => mockDio.get(any(), options: any(named: 'options')))
              .thenAnswer((_) async => mockResponse);

          // Act
          final result = await apiClient.request(
            url: testUrl,
            metodo: MetodoHttp.get,
          );

          // Assert
          expect(result.isOk, isTrue);
          expect((result as Ok).value, isNull);
        });
      });

      group('client error responses', () {
        test('should return ErroDeComunicacaoException for HTTP 400', () async {
          // Arrange
          when(() => mockResponse.statusCode).thenReturn(400);
          when(() => mockDio.get(any(), options: any(named: 'options')))
              .thenAnswer((_) async => mockResponse);

          // Act
          final result = await apiClient.request(
            url: testUrl,
            metodo: MetodoHttp.get,
          );

          // Assert
          expect(result.isError, isTrue);
          expect((result as Error).error, isA<ErroDeComunicacaoException>());
        });

        test('should return SessaoExpiradaException for HTTP 401', () async {
          // Arrange
          when(() => mockResponse.statusCode).thenReturn(401);
          when(() => mockDio.get(any(), options: any(named: 'options')))
              .thenAnswer((_) async => mockResponse);

          // Act
          final result = await apiClient.request(
            url: testUrl,
            metodo: MetodoHttp.get,
          );

          // Assert
          expect(result.isError, isTrue);
          expect((result as Error).error, isA<SessaoExpiradaException>());
        });

        test('should return AcessoNegadoException for HTTP 403', () async {
          // Arrange
          when(() => mockResponse.statusCode).thenReturn(403);
          when(() => mockDio.get(any(), options: any(named: 'options')))
              .thenAnswer((_) async => mockResponse);

          // Act
          final result = await apiClient.request(
            url: testUrl,
            metodo: MetodoHttp.get,
          );

          // Assert
          expect(result.isError, isTrue);
          expect((result as Error).error, isA<AcessoNegadoException>());
        });

        test('should return RecursoNaoEncontradoException for HTTP 404', () async {
          // Arrange
          when(() => mockResponse.statusCode).thenReturn(404);
          when(() => mockDio.get(any(), options: any(named: 'options')))
              .thenAnswer((_) async => mockResponse);

          // Act
          final result = await apiClient.request(
            url: testUrl,
            metodo: MetodoHttp.get,
          );

          // Assert
          expect(result.isError, isTrue);
          expect((result as Error).error, isA<RecursoNaoEncontradoException>());
        });
      });

      group('server error responses', () {
        test('should return ErroInternoServidorException for HTTP 500', () async {
          // Arrange
          when(() => mockResponse.statusCode).thenReturn(500);
          when(() => mockDio.get(any(), options: any(named: 'options')))
              .thenAnswer((_) async => mockResponse);

          // Act
          final result = await apiClient.request(
            url: testUrl,
            metodo: MetodoHttp.get,
          );

          // Assert
          expect(result.isError, isTrue);
          expect((result as Error).error, isA<ErroInternoServidorException>());
        });

        test('should return ServidorIndisponivelException for HTTP 503', () async {
          // Arrange
          when(() => mockResponse.statusCode).thenReturn(503);
          when(() => mockDio.get(any(), options: any(named: 'options')))
              .thenAnswer((_) async => mockResponse);

          // Act
          final result = await apiClient.request(
            url: testUrl,
            metodo: MetodoHttp.get,
          );

          // Assert
          expect(result.isError, isTrue);
          expect((result as Error).error, isA<ServidorIndisponivelException>());
        });
      });

      group('unknown status codes', () {
        test('should return UnknownErrorException for unhandled status codes', () async {
          // Arrange
          when(() => mockResponse.statusCode).thenReturn(418); // I'm a teapot
          when(() => mockDio.get(any(), options: any(named: 'options')))
              .thenAnswer((_) async => mockResponse);

          // Act
          final result = await apiClient.request(
            url: testUrl,
            metodo: MetodoHttp.get,
          );

          // Assert
          expect(result.isError, isTrue);
          expect((result as Error).error, isA<UnknownErrorException>());
        });

        test('should return UnknownErrorException for null status code', () async {
          // Arrange
          when(() => mockResponse.statusCode).thenReturn(null);
          when(() => mockDio.get(any(), options: any(named: 'options')))
              .thenAnswer((_) async => mockResponse);

          // Act
          final result = await apiClient.request(
            url: testUrl,
            metodo: MetodoHttp.get,
          );

          // Assert
          expect(result.isError, isTrue);
          expect((result as Error).error, isA<UnknownErrorException>());
        });
      });
    });

    group('integration tests', () {
      test('should handle complete successful POST flow', () async {
        // Arrange
        final requestBody = {'name': 'New Task', 'description': 'Task description'};
        final responseBody = {'id': '123', 'name': 'New Task', 'description': 'Task description'};
        
        when(() => mockResponse.statusCode).thenReturn(200);
        when(() => mockResponse.data).thenReturn(responseBody);
        when(() => mockDio.post(
              any(),
              options: any(named: 'options'),
              data: any(named: 'data'),
            )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await apiClient.request(
          url: testUrl,
          metodo: MetodoHttp.post,
          body: requestBody,
          headers: {'Authorization': 'Bearer abc123'},
        );

        // Assert
        expect(result.isOk, isTrue);
        expect((result as Ok).value, equals(responseBody));
        
        verify(() => mockDio.post(
              testUrl,
              options: any(named: 'options'),
              data: requestBody,
            )).called(1);
      });

      test('should handle complete error flow', () async {
        // Arrange
        when(() => mockResponse.statusCode).thenReturn(401);
        when(() => mockDio.get(any(), options: any(named: 'options')))
            .thenAnswer((_) async => mockResponse);

        // Act
        final result = await apiClient.request(
          url: testUrl,
          metodo: MetodoHttp.get,
          headers: {'Authorization': 'Bearer invalid_token'},
        );

        // Assert
        expect(result.isError, isTrue);
        final error = (result as Error).error;
        expect(error, isA<SessaoExpiradaException>());
        expect(error.code, equals('sessao-expirada'));
        expect(error.message, contains('sessão expirou'));
      });
    });
  });
}
