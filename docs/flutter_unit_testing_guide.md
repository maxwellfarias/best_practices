# Guia Completo de Testes Unitários em Flutter

_Um guia prático usando a classe TaskRepositoryImpl como exemplo_

**Data:** 13 de setembro de 2025  
**Autor:** MaxwellFarias

---

## Sumário

1. [Fundamentos de Testes Unitários](#1-fundamentos-de-testes-unitários)
2. [Padrões e Metodologias](#2-padrões-e-metodologias)
3. [Framework Mocktail](#3-framework-mocktail)
4. [Análise Detalhada do TaskRepositoryImpl](#4-análise-detalhada-do-taskrepositoryimpl)
5. [Melhores Práticas Demonstradas](#5-melhores-práticas-demonstradas)
6. [Padrões de Mercado](#6-padrões-de-mercado)
7. [Anatomia de um Teste](#7-anatomia-de-um-teste)
8. [Mock Deep Dive](#8-mock-deep-dive)
9. [Error Scenarios](#9-error-scenarios)
10. [Best Practices Checklist](#10-best-practices-checklist)
11. [Exercícios Práticos](#11-exercícios-práticos)
12. [Referências](#12-referências)

---

## 1. Fundamentos de Testes Unitários

### O que são testes unitários e por que são importantes

**Testes unitários** são testes automatizados que verificam o funcionamento correto de unidades individuais de código, geralmente classes ou métodos. Eles são a base da pirâmide de testes e oferecem:

- **Feedback rápido**: Os testes unitários executam rapidamente, permitindo identificar problemas cedo.
- **Confiança para refatorar**: Ao alterar o código, os testes garantem que a funcionalidade ainda está correta.
- **Documentação viva**: Testes servem como exemplos práticos de como usar o código.
- **Design melhor**: Escrever testes incentiva código mais modular e de baixo acoplamento.

### Diferença entre testes unitários, integração e E2E

| Tipo de Teste | Escopo | Velocidade | Complexidade | Dependências |
|---------------|--------|------------|--------------|--------------|
| **Unitário** | Componente isolado | Muito rápido | Baixa | Mockadas |
| **Integração** | Interação entre componentes | Médio | Média | Reais ou mockadas |
| **E2E** | Sistema completo | Lento | Alta | Reais |

#### No exemplo TaskRepositoryImpl:
- **Teste Unitário**: Testamos o repositório isoladamente, mockando o ApiClient.
- **Teste de Integração**: Testaríamos o repositório com uma implementação real do ApiClient, mas com um servidor simulado.
- **Teste E2E**: Testaríamos o aplicativo completo, do UI até o servidor real.

### Quando e o que testar na arquitetura em camadas

Em uma arquitetura em camadas típica de Flutter (apresentação, domínio, dados), devemos focar em:

- **Camada de Dados (Repositories, Services)**: 100% de cobertura, pois contém lógica de negócio crítica e comunicação externa.
- **Camada de Domínio (Use Cases, Models)**: Alta cobertura, principalmente para regras de negócio.
- **Camada de Apresentação (UI, ViewModels)**: Teste de lógica de apresentação, delegando testes de UI para testes de widget.

No projeto exemplo, o TaskRepositoryImpl está na camada de dados, e por isso recebe testes exaustivos de todos os cenários possíveis.

---

## 2. Padrões e Metodologias

### Triple AAA (Arrange, Act, Assert)

O padrão AAA é uma convenção para estruturar testes de forma clara e consistente:

1. **Arrange**: Configurar o ambiente para o teste (mocks, dados, etc.)
2. **Act**: Executar a função/método a ser testado
3. **Assert**: Verificar se o resultado é o esperado

**Exemplo do código TaskRepositoryImpl:**

```dart
test('should return list of tasks when API call is successful', () async {
  // Arrange
  final mockTasksJson = [
    {
      'id': '1',
      'title': 'Task 1',
      // ...outros dados
    },
    // ...mais tarefas
  ];
  
  when(() => mockApiClient.request(
        url: any(named: 'url'),
        metodo: MetodoHttp.get,
        headers: any(named: 'headers'),
      )).thenAnswer((_) async => Result.ok(mockTasksJson));

  // Act
  final result = await repository.getTasks();

  // Assert
  expect(result.isOk, isTrue);
  
  result.when(
    onOk: (tasks) {
      expect(tasks, hasLength(2));
      // ...mais verificações
    },
    onError: (error) => fail('Should not be error: $error'),
  );
});
```

### Given-When-Then

Uma alternativa BDD (Behavior-Driven Development) ao AAA, estruturada como:

1. **Given**: Um contexto (equivalente ao Arrange)
2. **When**: Uma ação ocorre (equivalente ao Act)
3. **Then**: Resultados esperados (equivalente ao Assert)

Este padrão é popular em frameworks BDD e testes mais descritivos.

### Test Doubles

Test Doubles são objetos que substituem dependências reais em testes:

| Test Double | Descrição | Quando usar | Exemplo em TaskRepositoryImpl |
|-------------|-----------|------------|------------------------------|
| **Mock** | Substituto programável que verifica interações | Quando precisamos verificar como o SUT interage com suas dependências | `MockApiClient` que verifica se os métodos são chamados corretamente |
| **Stub** | Fornece respostas pré-programadas | Quando só precisamos simular retornos | Usado dentro do `when(...).thenAnswer(...)` para simular respostas do ApiClient |
| **Fake** | Implementação simplificada mas funcional | Quando precisamos de comportamento real | Não usado no exemplo, mas poderia ser uma implementação em memória do ApiClient |
| **Spy** | Registra chamadas para análise posterior | Quando queremos analisar detalhes de interação | O verify() no Mocktail age como um spy para verificar chamadas |
| **Dummy** | Objetos passados mas não usados | Para satisfazer parâmetros não importantes para o teste | Não explicitamente usado, mas os matchers como `any()` agem como dummies |

### Test Isolation

Cada teste deve ser independente dos outros. No exemplo, isso é garantido por:

1. **setUp()**: Recria mocks e o repositório para cada teste
2. **Configurações específicas**: Cada teste configura exatamente o que precisa
3. **Sem estado compartilhado**: Não há dependência entre os testes

```dart
setUp(() {
  mockApiClient = MockApiClient();
  repository = TaskRepositoryImpl(apiService: mockApiClient);
});
```

---

## 3. Framework Mocktail

[Mocktail](https://pub.dev/packages/mocktail) é um framework de mocking para Dart/Flutter inspirado no Mockito, mas com suporte nativo a null safety e sem necessidade de geração de código.

### Setup e configuração

```dart
// 1. Declarar a classe mock
class MockApiClient extends Mock implements ApiClient {}

void main() {
  // 2. Registrar fallback values para enums ou classes complexas
  setUpAll(() {
    registerFallbackValue(MetodoHttp.get);
  });
  
  // 3. Criar instâncias no setup
  late MockApiClient mockApiClient;
  late TaskRepositoryImpl repository;
  
  setUp(() {
    mockApiClient = MockApiClient();
    repository = TaskRepositoryImpl(apiService: mockApiClient);
  });
  
  // 4. Testes...
}
```

O método `registerFallbackValue` é crucial quando se usa matchers como `any()` com tipos não primitivos, como enums.

### Criação de mocks

Mocktail permite criar mocks com uma sintaxe clara:

```dart
class MockApiClient extends Mock implements ApiClient {}
```

Esta linha cria uma classe que:
- Implementa todos os métodos da interface ApiClient
- Permite configurar comportamentos para esses métodos
- Permite verificar como esses métodos são chamados

### Stubbing com `when()` e `thenAnswer()`

Stubbing é a técnica de configurar como um método mock deve responder:

```dart
// Configura o mock para responder a qualquer chamada de request() com GET
when(() => mockApiClient.request(
      url: any(named: 'url'),
      metodo: MetodoHttp.get,
      headers: any(named: 'headers'),
    )).thenAnswer((_) async => Result.ok(mockTasksJson));
```

Diferenças importantes:
- `thenReturn()`: Retorna um valor direto (não é bom para futures)
- `thenAnswer()`: Executa uma função que retorna o resultado (bom para async)

### Verificações com `verify()` e `called()`

```dart
verify(() => mockApiClient.request(
      url: any(named: 'url', that: contains('supabase.co/rest/v1/todos')),
      metodo: MetodoHttp.get,
      headers: any(named: 'headers'),
    )).called(1);
```

Esta verificação garante que:
1. O método foi chamado exatamente uma vez
2. Foi chamado com parâmetros que correspondem aos matchers
3. A URL contém o caminho esperado

### Matchers avançados

Mocktail oferece matchers poderosos:

```dart
// Matchers básicos
any()                   // Qualquer valor
any(named: 'name')      // Qualquer valor para o parâmetro nomeado 'name'

// Matchers compostos
any(that: isA<String>())   // Qualquer string
any(that: equals(42))      // Qualquer valor igual a 42
any(that: contains('api')) // Qualquer string contendo 'api'
```

Matchers podem ser combinados:
```dart
any(named: 'headers', that: containsPair('apikey', any()))
```

---

## 4. Análise Detalhada do TaskRepositoryImpl

### Método: getTasks()

#### Cenários de Teste

1. **Happy Path**: Retorna lista de tarefas quando a API responde com sucesso
   ```dart
   test('should return list of tasks when API call is successful', () async {
     // ...configuração do mock para retornar JSON válido
     final result = await repository.getTasks();
     expect(result.isOk, isTrue);
     // ...validações dos dados
   });
   ```

2. **Error Case**: Retorna erro quando a chamada da API falha
   ```dart
   test('should return error when API call fails', () async {
     when(() => mockApiClient.request(...))
         .thenAnswer((_) async => Result.error(ErroDeComunicacaoException()));
     
     final result = await repository.getTasks();
     expect(result.isError, isTrue);
     // ...validações do erro
   });
   ```

3. **Edge Case**: Trata falha de parsing
   ```dart
   test('should return UnknownErrorException when parsing fails', () async {
     when(() => mockApiClient.request(...))
         .thenAnswer((_) async => Result.ok("invalid_json_structure"));
     
     final result = await repository.getTasks();
     expect(result.isError, isTrue);
     // ...validação do tipo de erro
   });
   ```

4. **Edge Case**: Trata lista vazia
   ```dart
   test('should return empty list when API returns empty array', () async {
     when(() => mockApiClient.request(...))
         .thenAnswer((_) async => Result.ok([]));
     
     final result = await repository.getTasks();
     expect(result.isOk, isTrue);
     result.when(
       onOk: (tasks) => expect(tasks, isEmpty),
       // ...
     );
   });
   ```

### Método: createTask()

#### Cenários de Teste

1. **Happy Path**: Cria tarefa com sucesso
   ```dart
   test('should create task successfully', () async {
     final task = Task(...);  // Objeto com dados de teste
     when(() => mockApiClient.request(...))
         .thenAnswer((_) async => Result.ok({'status': 'created'}));
     
     final result = await repository.createTask(task);
     expect(result.isOk, isTrue);
     // ...verificação da chamada à API
   });
   ```

2. **Error Case**: Falha na comunicação
   ```dart
   test('should return error when create task API call fails', () async {
     // ...configuração similar para erro
   });
   ```

3. **Error Case**: Erro do servidor
   ```dart
   test('should handle server errors for create task', () async {
     // ...configuração para erro de servidor
   });
   ```

### Método: updateTask()

#### Cenários de Teste

1. **Happy Path**: Atualiza tarefa com sucesso
2. **Error Case**: Recurso não encontrado
3. **Error Case**: Erro de autenticação

### Método: deleteTask()

#### Cenários de Teste

1. **Happy Path**: Deleta tarefa com sucesso
2. **Error Case**: Recurso não encontrado
3. **Error Case**: Acesso negado
4. **Error Case**: Servidor indisponível

### Testes de Integração e Edge Cases

1. **Headers e Autenticação**: Verifica se todos os requests incluem headers corretos
2. **Resposta Nula**: Trata resposta null da API
3. **Dados Malformados**: Trata formato de data inválido
4. **Timeout de Rede**: Trata erros de timeout em todas as operações
5. **Dados Complexos**: Trata caracteres Unicode e quebras de linha
6. **Todos os Campos**: Trata tarefas com todos os campos preenchidos

---

## 5. Melhores Práticas Demonstradas

### Organização e Estrutura

#### Agrupamento lógico com `group()`

O código usa `group()` para organizar testes relacionados:

```dart
group('TaskRepositoryImpl', () {
  // Setup comum...
  
  group('getTasks', () {
    // Testes específicos para getTasks
  });
  
  group('createTask', () {
    // Testes específicos para createTask
  });
  
  // ...outros grupos
});
```

Esta estrutura:
- Facilita a leitura e manutenção
- Permite setup específico por grupo
- Organiza os testes logicamente

#### Nomes descritivos de testes

```dart
test('should return list of tasks when API call is successful', () async {
  // ...
});
```

Bons nomes de teste seguem o padrão:
- **should** + resultado esperado + **when** + condição/ação
- Foco no comportamento, não na implementação
- Descrição clara do que está sendo testado

#### Setup e teardown apropriados

```dart
setUp(() {
  mockApiClient = MockApiClient();
  repository = TaskRepositoryImpl(apiService: mockApiClient);
});
```

O `setUp` é executado antes de cada teste, garantindo que cada teste comece com estado limpo.

### Assertions Eficazes

#### Uso correto de matchers do Flutter Test

```dart
expect(tasks, hasLength(2));
expect(tasks[0].id, equals('1'));
expect(tasks[0].isCompleted, isFalse);
```

Matchers tornam as asserções mais expressivas e fornecem mensagens de erro melhores que comparações diretas.

#### Validação de Result Pattern

```dart
expect(result.isOk, isTrue);
result.when(
  onOk: (tasks) {
    expect(tasks, hasLength(2));
    // ...
  },
  onError: (error) => fail('Should not be error: $error'),
);
```

O padrão Result é verificado adequadamente:
1. Verificação do estado (isOk/isError)
2. Pattern matching com when() para acessar o valor/erro
3. Assertions adicionais dentro dos callbacks

### Mock Strategy

#### Quando usar mocks vs stubs

No exemplo, usamos primariamente mocks porque:
- Precisamos verificar como o repositório interage com o ApiClient
- Precisamos controlar o comportamento do ApiClient em diferentes cenários
- Queremos isolar o repositório de dependências externas

#### Verificação precisa de interações

```dart
verify(() => mockApiClient.request(
      url: any(named: 'url', that: contains('supabase.co/rest/v1/todos')),
      metodo: MetodoHttp.delete,
      headers: any(named: 'headers'),
    )).called(1);
```

Esta verificação é importante porque:
- Confirma que o método correto foi chamado
- Valida os parâmetros passados
- Verifica o número exato de chamadas

---

## 6. Padrões de Mercado

### Test Organization

#### Estrutura de pastas espelhando o código fonte

```
lib/
  data/
    repositories/
      task_repository_impl.dart
      
test/
  unit/
    data/
      repositories/
        task_repository_test.dart
```

Esta estrutura:
- Facilita encontrar os testes correspondentes
- Mantém a mesma hierarquia do código fonte
- Separa claramente testes unitários de outros tipos de teste

#### Convenções de nomenclatura

```
task_repository_impl.dart → task_repository_test.dart
```

Convenções comuns:
- Mesmo nome do arquivo testado + sufixo `_test`
- Teste unitário usa sufixo `_test`, teste de widget usa `_widget_test`
- Nome do arquivo reflete o que está sendo testado

### Coverage Guidelines

#### O que 100% de coverage realmente significa

Cobertura de 100% indica que cada linha de código é executada durante os testes, mas **não** garante:
- Que todos os cenários lógicos foram testados
- Que os valores limites foram testados
- Que as integrações funcionam corretamente

No exemplo do TaskRepositoryImpl, vemos cobertura de qualidade porque:
1. Testamos casos de sucesso e erro
2. Testamos valores limites (lista vazia, dados malformados)
3. Verificamos o comportamento, não só a execução

#### Métricas importantes além de coverage

- **Mutation Testing**: Verificar se os testes detectam alterações no código
- **Cyclomatic Complexity**: Garantir que caminhos de decisão complexos são testados
- **Integration Coverage**: Testar pontos de integração entre componentes

#### Como priorizar testes de alto valor

No exemplo, os testes priorizam:
1. Comportamento central (CRUD de tarefas)
2. Tratamento de erros (essencial para resiliência)
3. Casos especiais (dados complexos, formatos inesperados)

### Error Testing

#### Como testar cenários de erro efetivamente

```dart
test('should handle malformed task data', () async {
  final malformedData = [
    {
      'id': '1',
      'title': 'Task',
      'description': 'Description',
      'is_completed': false,
      'created_at': 'invalid-date-format', // This will cause DateTime.parse to fail
    },
  ];

  when(() => mockApiClient.request(
        url: any(named: 'url'),
        metodo: MetodoHttp.get,
        headers: any(named: 'headers'),
      )).thenAnswer((_) async => Result.ok(malformedData));

  final result = await repository.getTasks();
  
  expect(result.isError, isTrue);
  result.when(
    onOk: (_) => fail('Should not be success'),
    onError: (error) => expect(error, isA<UnknownErrorException>()),
  );
});
```

Estratégias demonstradas:
1. Injetar dados que causarão o erro esperado
2. Verificar que o erro é do tipo correto
3. Garantir que o erro é tratado adequadamente

---

## 7. Anatomia de um Teste

Vamos analisar detalhadamente um teste específico:

```dart
test('should return list of tasks when API call is successful', () async {
  // 1. ARRANGE: Preparar dados e configurar mocks
  final mockTasksJson = [
    {
      'id': '1',
      'title': 'Task 1',
      'description': 'Description 1',
      'is_completed': false,
      'created_at': '2023-01-01T00:00:00Z',
    },
    {
      'id': '2',
      'title': 'Task 2',
      'description': 'Description 2',
      'is_completed': true,
      'created_at': '2023-01-02T00:00:00Z',
      'completed_at': '2023-01-03T00:00:00Z',
    },
  ];

  // 2. ARRANGE: Configurar comportamento do mock
  when(() => mockApiClient.request(
        url: any(named: 'url'),
        metodo: MetodoHttp.get,
        headers: any(named: 'headers'),
      )).thenAnswer((_) async => Result.ok(mockTasksJson));

  // 3. ACT: Executar o método sob teste
  final result = await repository.getTasks();

  // 4. ASSERT: Verificar resultado principal
  expect(result.isOk, isTrue);
  
  // 5. ASSERT: Verificações detalhadas com pattern matching
  result.when(
    onOk: (tasks) {
      // 5.1 Verificar tamanho da lista
      expect(tasks, hasLength(2));
      
      // 5.2 Verificar campos da primeira tarefa
      expect(tasks[0].id, equals('1'));
      expect(tasks[0].title, equals('Task 1'));
      expect(tasks[0].description, equals('Description 1'));
      expect(tasks[0].isCompleted, isFalse);
      
      // 5.3 Verificar campos da segunda tarefa
      expect(tasks[1].id, equals('2'));
      expect(tasks[1].title, equals('Task 2'));
      expect(tasks[1].description, equals('Description 2'));
      expect(tasks[1].isCompleted, isTrue);
    },
    // 5.4 Garantir que não é erro
    onError: (error) => fail('Should not be error: $error'),
  );

  // 6. ASSERT: Verificar chamadas ao mock
  verify(() => mockApiClient.request(
        url: any(named: 'url', that: contains('supabase.co/rest/v1/todos')),
        metodo: MetodoHttp.get,
        headers: any(named: 'headers'),
      )).called(1);
});
```

### Explicação detalhada:

1. **Nome do teste**: Descreve claramente o cenário e resultado esperado
2. **Preparação de dados**: Criamos JSON mock que simula a resposta da API
3. **Configuração de mocks**: Definimos como o ApiClient deve responder
4. **Execução da função**: Chamamos o método real que queremos testar
5. **Verificações primárias**: Verificamos que o Result é do tipo correto (Ok)
6. **Verificações detalhadas**:
   - Pattern matching com Result.when para acessar o valor
   - Verificações da estrutura retornada (lista com 2 itens)
   - Verificações detalhadas de cada campo de cada objeto
   - Tratamento explícito do caso de erro (que não deveria acontecer)
7. **Verificação de interações**: Confirmamos que o repositório chamou a API corretamente

### Padrão AAA aplicado:

- **Arrange**: Linhas 2-17, configurando dados de teste e comportamento do mock
- **Act**: Linha 19, chamando `repository.getTasks()`
- **Assert**: Linhas 22-42, verificando resultados e comportamento

---

## 8. Mock Deep Dive

### Como e por que mockamos o ApiClient

O ApiClient é mockado por várias razões:

1. **Isolamento**: Testar o repositório sem depender de uma API real
2. **Determinismo**: Controlar precisamente as respostas para testar todos os cenários
3. **Velocidade**: Testes não precisam fazer chamadas de rede reais
4. **Estabilidade**: Testes não falham devido a problemas externos

**Implementação**:

```dart
// 1. Definir a classe mock
class MockApiClient extends Mock implements ApiClient {}

// 2. Criar instância no setup
setUp(() {
  mockApiClient = MockApiClient();
  repository = TaskRepositoryImpl(apiService: mockApiClient);
});
```

### Diferença entre `when()` e `thenAnswer()`

```dart
// Exemplo 1: Retorno simples (não recomendado para async)
when(() => mockApiClient.someMethod()).thenReturn(value);

// Exemplo 2: Função que retorna valor (recomendado para async)
when(() => mockApiClient.request(...)).thenAnswer((_) async => Result.ok(data));
```

Diferenças importantes:
- `thenReturn` retorna um valor fixo
- `thenAnswer` executa uma função para gerar o valor retornado
- Para métodos assíncronos, `thenAnswer` é mais apropriado pois permite retornar Futures

### Verificações com `verify()` e `called()`

```dart
// Verifica chamada exata
verify(() => mockApiClient.request(
  url: 'exact-url',
  metodo: MetodoHttp.get,
)).called(1);

// Verifica com matchers
verify(() => mockApiClient.request(
  url: any(named: 'url', that: contains('/tasks')),
  metodo: any(named: 'metodo'),
)).called(1);

// Verificar número de chamadas
verify(...).called(1);      // Exatamente 1 vez
verify(...).called(greaterThan(0)); // Pelo menos 1 vez
verify(...).called(lessThan(3));    // Menos de 3 vezes

// Verificar ausência de chamadas
verifyNever(() => mockApiClient.request(...));
```

**Dicas importantes**:
1. Verifique apenas o que é importante para o comportamento
2. Use matchers para evitar testes frágeis
3. Verifique o número preciso de chamadas para evitar chamadas duplicadas

---

## 9. Error Scenarios

### Como testar falhas de forma eficaz

```dart
test('should handle network timeout errors', () async {
  // 1. Configurar o mock para simular erro
  when(() => mockApiClient.request(
        url: any(named: 'url'),
        metodo: any(named: 'metodo'),
        body: any(named: 'body'),
        headers: any(named: 'headers'),
      )).thenAnswer((_) async => Result.error(ErroDeComunicacaoException()));

  // 2. Criar objeto de teste necessário
  final task = Task(
    id: '1',
    title: 'Test',
    description: 'Test',
    isCompleted: false,
    createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
  );

  // 3. Testar múltiplos métodos que devem tratar o mesmo erro
  final results = await Future.wait([
    repository.getTasks(),
    repository.createTask(task),
    repository.updateTask(task),
    repository.deleteTask('1'),
  ]);

  // 4. Verificar que todos trataram o erro corretamente
  for (final result in results) {
    expect(result.isError, isTrue);
    result.when(
      onOk: (_) => fail('Should not be success'),
      onError: (error) => expect(error, isA<ErroDeComunicacaoException>()),
    );
  }
});
```

### Padrões para testing de exceptions

1. **Erro de comunicação**: Simular falhas de rede
   ```dart
   Result.error(ErroDeComunicacaoException())
   ```

2. **Recurso não encontrado**: Simular tentativa de acessar recurso inexistente
   ```dart
   Result.error(RecursoNaoEncontradoException())
   ```

3. **Erro de parsing**: Simular dados malformados
   ```dart
   // Retornar dados que causarão falha ao processar
   Result.ok("invalid_json_structure")
   
   // ou
   
   Result.ok({'created_at': 'invalid-date-format'})
   ```

4. **Erros de autenticação**: Simular problemas de permissão
   ```dart
   Result.error(SessaoExpiradaException())
   // ou
   Result.error(AcessoNegadoException())
   ```

### Validação de error handling

```dart
test('should return UnknownErrorException when parsing fails', () async {
  // 1. Configurar cenário que causará exceção durante o processamento
  when(() => mockApiClient.request(...))
      .thenAnswer((_) async => Result.ok("invalid_json_structure"));

  // 2. Executar função que deve tratar a exceção
  final result = await repository.getTasks();

  // 3. Verificar que a exceção foi tratada e convertida em Result.error
  expect(result.isError, isTrue);
  
  // 4. Verificar tipo específico de erro
  result.when(
    onOk: (_) => fail('Should not be success'),
    onError: (error) => expect(error, isA<UnknownErrorException>()),
  );
});
```

Este padrão é importante porque:
1. Testa a **resiliência** do código
2. Valida o **tratamento adequado** de exceções
3. Garante **tipos de erro consistentes** para o consumidor

---

## 10. Best Practices Checklist

### Lista prática para review de testes

#### ✅ Organização
- [ ] Testes agrupados logicamente com `group()`
- [ ] Nome de teste descreve claramente o comportamento esperado
- [ ] Código segue padrão AAA (Arrange-Act-Assert)
- [ ] Cada teste verifica um único comportamento
- [ ] Testes independentes entre si (não compartilham estado)

#### ✅ Mocks e Stubs
- [ ] Apenas dependências externas são mockadas
- [ ] Mock configurado com o comportamento mínimo necessário
- [ ] `verify()` usado para confirmar interações importantes
- [ ] Matchers usados apropriadamente (não hardcoded)
- [ ] Fallback values registrados para tipos complexos

#### ✅ Assertions
- [ ] Assertions verificam o resultado principal
- [ ] Assertions detalhadas para validar estrutura completa
- [ ] Erros verificados por tipo e não apenas presença
- [ ] Matchers usados em vez de comparações diretas
- [ ] Casos de falha explicitamente testados

#### ✅ Cobertura
- [ ] Todos os métodos públicos testados
- [ ] Caminhos de sucesso (happy path) testados
- [ ] Casos de erro testados
- [ ] Edge cases testados (valores limites, nulos, vazios)
- [ ] Integrações entre componentes verificadas

### Sinais de testes bem escritos vs problemáticos

#### ✅ Bons sinais
- **Isolamento**: Dependências mockadas, testes independentes
- **Clareza**: Nomes descritivos, estrutura AAA clara
- **Robustez**: Não falham com mudanças de implementação
- **Foco**: Cada teste verifica um comportamento específico
- **Detalhamento**: Assertions específicas e relevantes

#### ❌ Sinais problemáticos
- **Acoplamento**: Testes que falham quando outros são alterados
- **Fragilidade**: Testes que quebram com mudanças de implementação
- **Over-specification**: Verificar detalhes de implementação não relevantes
- **Under-verification**: Não verificar resultados importantes
- **Complexidade**: Testes difíceis de entender

### Guidelines para manutenibilidade

1. **Refatore testes**: Extraia helpers para código repetitivo
   ```dart
   // Antes (repetitivo)
   when(() => mockApiClient.request(...)).thenAnswer(...);
   
   // Depois (com helper)
   _mockApiSuccess(mockTasksJson);
   ```

2. **Fixtures para dados complexos**: Extraia dados de teste para constantes ou arquivos
   ```dart
   // Constante para reuso
   const mockTaskJson = {'id': '1', ...};
   ```

3. **Setup específico por grupo**: Use `setUp` dentro de grupos para configuração específica
   ```dart
   group('getTasks', () {
     setUp(() {
       // configuração específica para getTasks
     });
     
     // testes...
   });
   ```

4. **Mantenha testes junto com código**: Atualize testes ao modificar código

5. **Use TDD quando possível**: Escreva testes antes da implementação

---

## 11. Exercícios Práticos

### Expandindo os testes existentes

1. **Adicione mais edge cases**:
   - Teste com valores extremamente grandes
   - Teste com caracteres especiais
   - Teste com datas muito antigas ou futuras

2. **Teste comportamento de retry**:
   - Simule falha temporária que deve ser tentada novamente
   - Verifique número máximo de tentativas

3. **Teste timeouts**:
   - Simule timeout específico (vs erro genérico)
   - Verifique comportamento com diferentes configurações de timeout

### Cenários adicionais para praticar

1. **Filtragem de tarefas**:
   - Adicione um método `getTasksByStatus` no repositório
   - Implemente testes para filtragem por status concluído/pendente
   - Teste casos de filtro vazio ou inválido

2. **Paginação**:
   - Adicione suporte para paginação no método `getTasks`
   - Teste diferentes tamanhos de página
   - Teste casos limite (primeira/última página)

3. **Ordenação**:
   - Adicione suporte para ordenação de tarefas
   - Teste diferentes critérios de ordenação
   - Teste ordem ascendente/descendente

### Templates para novos testes

#### Template: Teste de caso de sucesso

```dart
test('should [resultado esperado] when [condição]', () async {
  // Arrange
  final inputData = ...; // Dados de entrada
  when(() => mockDependency.method(...))
      .thenAnswer((_) async => Result.ok(successResponse));
  
  // Act
  final result = await systemUnderTest.method(inputData);
  
  // Assert
  expect(result.isOk, isTrue);
  result.when(
    onOk: (value) {
      // Verificações específicas do valor
    },
    onError: (error) => fail('Should not be error: $error'),
  );
  
  // Verify
  verify(() => mockDependency.method(
    // Parâmetros esperados ou matchers
  )).called(1);
});
```

#### Template: Teste de caso de erro

```dart
test('should return [tipo de erro] when [condição de erro]', () async {
  // Arrange
  final inputData = ...; // Dados de entrada
  when(() => mockDependency.method(...))
      .thenAnswer((_) async => Result.error(SomeException()));
  
  // Act
  final result = await systemUnderTest.method(inputData);
  
  // Assert
  expect(result.isError, isTrue);
  result.when(
    onOk: (_) => fail('Should not be success'),
    onError: (error) => expect(error, isA<ExpectedErrorType>()),
  );
});
```

---

## 12. Referências

### Bibliotecas e Frameworks
- [flutter_test](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html) - Framework oficial de teste do Flutter
- [mocktail](https://pub.dev/packages/mocktail) - Framework de mocking para Dart/Flutter
- [flutter_test_matchers](https://pub.dev/packages/matcher) - Matchers adicionais para testes

### Artigos e Recursos
- [Testing Flutter Apps](https://docs.flutter.dev/testing) - Documentação oficial
- [Effective Dart: Testing](https://dart.dev/guides/language/effective-dart/usage#testing)
- [Flutter Testing Patterns](https://verygood.ventures/blog/flutter-testing-patterns)
- [Test-Driven Development with Flutter](https://www.raywenderlich.com/7408603-test-driven-development-with-flutter)

### Livros
- "Flutter Testing Guide" por Sanjib Sinha
- "Test-Driven Development: By Example" por Kent Beck
- "Growing Object-Oriented Software, Guided by Tests" por Steve Freeman e Nat Pryce

### Cursos e Vídeos
- [Testing Flutter Apps](https://www.youtube.com/watch?v=bj-oMYyLZEY) - The Flutter Way
- [Flutter Unit Testing for Beginners](https://www.youtube.com/watch?v=RDY6UYh-nyg) - Reso Coder
- [Flutter TDD Clean Architecture](https://www.youtube.com/playlist?list=PLB6lc7nQ1n4iYGE_khpXRdJkJEp9WOech) - Reso Coder

---

*Este documento foi criado como guia educacional para desenvolvedores Flutter começando com testes unitários.*

*Última atualização: 13 de setembro de 2025*
