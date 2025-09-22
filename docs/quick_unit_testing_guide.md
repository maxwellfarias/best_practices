# Guia Rápido de Testes Unitários em Flutter

## Visão Geral

Este é um guia rápido sobre testes unitários em Flutter, usando a implementação da classe `TaskRepositoryImpl` como exemplo. Um guia completo e detalhado está disponível no arquivo [flutter_unit_testing_guide.md](./flutter_unit_testing_guide.md).

## Conceitos Fundamentais

### O que são Testes Unitários?

Testes unitários são testes automatizados que verificam o comportamento de pequenas "unidades" de código (geralmente métodos ou classes) de forma isolada. Eles são a base da pirâmide de testes e ajudam a garantir que cada parte do código funcione conforme esperado.

### Por que Testar?

- **Confiança na refatoração**: Detectar problemas ao alterar código existente
- **Feedback rápido**: Encontrar bugs antes da integração
- **Documentação viva**: Mostrar como o código deve se comportar
- **Design melhor**: Código testável tende a ser mais modular e menos acoplado

### Padrão Triple A (Arrange-Act-Assert)

```dart
test('should return list of tasks when API call is successful', () async {
  // Arrange: Configurar o ambiente para o teste
  when(() => mockApiClient.request(...))
      .thenAnswer((_) async => Result.ok(mockTasksJson));
  
  // Act: Executar o código que está sendo testado
  final result = await repository.getTasks();
  
  // Assert: Verificar se o resultado é o esperado
  expect(result.isOk, isTrue);
  result.when(
    onOk: (tasks) {
      expect(tasks, hasLength(2));
      // mais verificações...
    },
    onError: (error) => fail('Should not be error: $error'),
  );
});
```

## Mocktail - Framework de Mocking

### Criando um Mock

```dart
// 1. Definir a classe mock
class MockApiClient extends Mock implements ApiClient {}

void main() {
  // 2. Registrar fallback values para enums
  setUpAll(() {
    registerFallbackValue(MetodoHttp.get);
  });
  
  // 3. Criar instância no setup
  late MockApiClient mockApiClient;
  
  setUp(() {
    mockApiClient = MockApiClient();
    // ...
  });
}
```

### Configurando Comportamento do Mock

```dart
// Para retornos de sucesso
when(() => mockApiClient.request(
      url: any(named: 'url'),
      metodo: MetodoHttp.get,
      headers: any(named: 'headers'),
    )).thenAnswer((_) async => Result.ok(mockTasksJson));

// Para retornos de erro
when(() => mockApiClient.request(
      url: any(named: 'url'),
      metodo: MetodoHttp.delete,
      headers: any(named: 'headers'),
    )).thenAnswer((_) async => Result.error(RecursoNaoEncontradoException()));
```

### Verificando Chamadas ao Mock

```dart
verify(() => mockApiClient.request(
      url: any(named: 'url', that: contains('todos')),
      metodo: MetodoHttp.get,
      headers: any(named: 'headers'),
    )).called(1);
```

## Testando Diferentes Cenários

### Happy Path (Caminho Feliz)

```dart
test('should create task successfully', () async {
  // Configurar mock para retornar sucesso
  when(...).thenAnswer((_) async => Result.ok({'status': 'created'}));
  
  // Executar
  final result = await repository.createTask(task);
  
  // Verificar
  expect(result.isOk, isTrue);
  // Mais verificações...
});
```

### Cenários de Erro

```dart
test('should handle server unavailable for delete task', () async {
  // Configurar mock para retornar erro
  when(...).thenAnswer((_) async => Result.error(ServidorIndisponivelException()));
  
  // Executar
  final result = await repository.deleteTask(taskId);
  
  // Verificar
  expect(result.isError, isTrue);
  result.when(
    onOk: (_) => fail('Should not be success'),
    onError: (error) => expect(error, isA<ServidorIndisponivelException>()),
  );
});
```

### Edge Cases

```dart
test('should handle malformed task data', () async {
  // Dados que causarão erro de parsing
  final malformedData = [{
    'id': '1',
    'created_at': 'invalid-date-format', // Causará erro
  }];
  
  when(...).thenAnswer((_) async => Result.ok(malformedData));
  
  final result = await repository.getTasks();
  
  expect(result.isError, isTrue);
  // Verificações adicionais...
});
```

## Melhores Práticas

1. **Nome do teste**: Descreva claramente o que está testando e o resultado esperado
2. **Independência**: Cada teste deve ser independente dos outros
3. **Foco**: Teste um único comportamento por teste
4. **Verificações relevantes**: Verifique apenas o que importa para o comportamento
5. **Tratamento de erros**: Teste cenários de erro, não apenas o "caminho feliz"
6. **Matchers**: Use matchers em vez de comparações diretas
7. **Estrutura**: Organize testes em grupos lógicos

## Guia Detalhado

Para uma explicação completa de todos os conceitos e exemplos detalhados, consulte o [Guia Completo de Testes Unitários em Flutter](./flutter_unit_testing_guide.md).

---

*Este guia foi criado para ajudar desenvolvedores a entender os fundamentos de testes unitários em Flutter.*
