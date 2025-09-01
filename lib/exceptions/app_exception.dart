sealed class AppException implements Exception {
  AppException(this.code, this.message);
  final String code;
  final String message;

  @override
  String toString() => message;
}

//MARK: Auth
class UsuarioOuSenhaInvalidoException extends AppException {
  UsuarioOuSenhaInvalidoException()
      : super('usuario-ou-senha-invalido', 'Usuário ou senha inválidos. Verifique seus dados e tente novamente.');
}

/// Sessão expirada
class SessaoExpiradaException extends AppException {
  SessaoExpiradaException()
      : super('sessao-expirada', 'Sua sessão expirou. Por favor, faça login novamente para continuar.');
}

//MARK: Rede

/// Acesso negado ao recurso solicitado.
class AcessoNegadoException extends AppException {
  AcessoNegadoException()
      : super('acesso-negado', 'Você não tem permissão para acessar este recurso.');
}

/// O dispositivo não está conectado à internet.
class SemConexaoException extends AppException {
  SemConexaoException()
      : super('sem-conexao', 'Sem conexão com a internet. Por favor, verifique sua rede e tente novamente.');
}

//MARK: Erros servidor

/// A requisição para o servidor demorou demais para responder.
class CepNaoEncontradoException extends AppException {
  CepNaoEncontradoException()
      : super('cep-nao-encontrado', 'O CEP informado não foi encontrado.');
}

class WhatsAppApiException extends AppException {
  WhatsAppApiException()
      : super('whatsapp-api-exception', 'Ocorreu um erro durante o envio da mensagem via WhatsApp. Por favor, entre em contato com o suporte.');
}

/// A requisição para o servidor demorou demais para responder.
class TimeoutDeRequisicaoException extends AppException {
  TimeoutDeRequisicaoException()
      : super('timeout-de-requisicao', 'O servidor demorou para responder. Verifique sua conexão e tente novamente.');
}


/// Erro genérico do servidor (HTTP 500).
class ErroInternoServidorException extends AppException {
  ErroInternoServidorException()
      : super('erro-interno-servidor', 'Ocorreu um problema no servidor. Nossa equipe já foi notificada. Tente novamente mais tarde.');
}

/// O serviço ou servidor está temporariamente indisponível (HTTP 503).
class ServidorIndisponivelException extends AppException {
  ServidorIndisponivelException()
      : super('servidor-indisponivel', 'O serviço está temporariamente indisponível. Por favor, tente novamente em alguns minutos.');
}

/// O recurso solicitado não foi encontrado no servidor (HTTP 404).
class RecursoNaoEncontradoException extends AppException {
  RecursoNaoEncontradoException()
      : super('recurso-nao-encontrado', 'As informações que você está procurando não foram encontradas.');
}

//MARK: Exceções genéricas

class ErroDeComunicacaoException extends AppException {
  ErroDeComunicacaoException()
      : super(
          'erro-de-comunicacao',
          'Houve um problema na comunicação com nossos servidores. Por favor, tente novamente mais tarde.',
        );
} 

class UnknownErrorException extends AppException {
  UnknownErrorException()
      : super(
          'unknown-error',
          'Ocorreu um erro inesperado. Por favor, tente novamente.',
        );
}