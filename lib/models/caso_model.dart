class CasoModel {
  String nome;
  String email;
  String estado;
  String perfil;

  String tipoDivida;
  String credor;
  double valor;
  String dataInicio;
  String situacaoAtual;

  List<String> documentosExistentes;

  double rendaMensal;
  double gastosEssenciais;
  double impostosTaxas;
  double parcelasAtuais;
  double dividasVencidas;

  String objetivo;

  CasoModel({
    this.nome = '',
    this.email = '',
    this.estado = '',
    this.perfil = '',
    this.tipoDivida = '',
    this.credor = '',
    this.valor = 0,
    this.dataInicio = '',
    this.situacaoAtual = '',
    List<String>? documentosExistentes,
    this.rendaMensal = 0,
    this.gastosEssenciais = 0,
    this.impostosTaxas = 0,
    this.parcelasAtuais = 0,
    this.dividasVencidas = 0,
    this.objetivo = '',
  }) : documentosExistentes = documentosExistentes ?? [];

  double get espacoSeguro =>
      rendaMensal - gastosEssenciais - impostosTaxas - parcelasAtuais;

  String get tipoDividaLabel {
    switch (tipoDivida) {
      case 'banco_cartao':
        return 'Dívida com banco/cartão';
      case 'empresa':
        return 'Cobrança indevida de empresa';
      case 'nome_negativado':
        return 'Nome negativado';
      case 'superendividamento':
        return 'Superendividamento';
      case 'governo_imposto':
        return 'Dívida com governo/imposto';
      case 'execucao_judicial':
        return 'Execução/cobrança judicial';
      default:
        return tipoDivida;
    }
  }

  String get perfilLabel {
    switch (perfil) {
      case 'PF':
        return 'Pessoa Física';
      case 'MEI':
        return 'MEI';
      case 'Autonomo':
        return 'Autônomo';
      default:
        return perfil;
    }
  }

  String get objetivoLabel {
    switch (objetivo) {
      case 'contestar':
        return 'Contestar/reclamar a cobrança';
      case 'negociar':
        return 'Negociar/renegociar';
      case 'parcelar':
        return 'Parcelar a dívida';
      case 'defensoria':
        return 'Buscar Defensoria Pública';
      case 'profissional':
        return 'Buscar advogado/contador';
      default:
        return objetivo;
    }
  }
}
