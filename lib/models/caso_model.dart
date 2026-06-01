class CasoModel {
  String nome, email, estado, perfil, tipoDivida, credor, dataInicio, situacaoAtual, objetivo;
  double valor, rendaMensal, gastosEssenciais, impostosTaxas, parcelasAtuais, dividasVencidas;
  List<String> documentosExistentes;
  DateTime? dataCriacao;

  CasoModel({this.nome='',this.email='',this.estado='',this.perfil='',this.tipoDivida='',this.credor='',this.valor=0,this.dataInicio='',this.situacaoAtual='',List<String>? documentosExistentes,this.rendaMensal=0,this.gastosEssenciais=0,this.impostosTaxas=0,this.parcelasAtuais=0,this.dividasVencidas=0,this.objetivo='',this.dataCriacao}) : documentosExistentes = documentosExistentes ?? [];

  double get espacoSeguro => rendaMensal - gastosEssenciais - impostosTaxas - parcelasAtuais;

  String get tipoDividaLabel { switch(tipoDivida){ case 'banco_cartao': return 'Divida com banco/cartao'; case 'empresa': return 'Cobranca indevida de empresa'; case 'nome_negativado': return 'Nome negativado'; case 'superendividamento': return 'Superendividamento'; case 'governo_imposto': return 'Divida com governo/imposto'; case 'execucao_judicial': return 'Execucao/cobranca judicial'; default: return tipoDivida; } }
  String get tipoDividaEmoji { switch(tipoDivida){ case 'banco_cartao': return '💳'; case 'empresa': return '🏪'; case 'nome_negativado': return '⚠️'; case 'superendividamento': return '📉'; case 'governo_imposto': return '🏛️'; case 'execucao_judicial': return '⚖️'; default: return '📄'; } }
  String get perfilLabel { switch(perfil){ case 'PF': return 'Pessoa Fisica'; case 'MEI': return 'MEI'; case 'Autonomo': return 'Autonomo'; default: return perfil; } }
  String get objetivoLabel { switch(objetivo){ case 'contestar': return 'Contestar/reclamar'; case 'negociar': return 'Negociar/renegociar'; case 'parcelar': return 'Parcelar a divida'; case 'defensoria': return 'Buscar Defensoria'; case 'profissional': return 'Buscar profissional'; default: return objetivo; } }

  Map<String,dynamic> toJson() => {'nome':nome,'email':email,'estado':estado,'perfil':perfil,'tipoDivida':tipoDivida,'credor':credor,'valor':valor,'dataInicio':dataInicio,'situacaoAtual':situacaoAtual,'documentosExistentes':documentosExistentes,'rendaMensal':rendaMensal,'gastosEssenciais':gastosEssenciais,'impostosTaxas':impostosTaxas,'parcelasAtuais':parcelasAtuais,'dividasVencidas':dividasVencidas,'objetivo':objetivo,'dataCriacao':dataCriacao?.toIso8601String()};

  factory CasoModel.fromJson(Map<String,dynamic> j) => CasoModel(nome:j['nome']??'',email:j['email']??'',estado:j['estado']??'',perfil:j['perfil']??'',tipoDivida:j['tipoDivida']??'',credor:j['credor']??'',valor:(j['valor']??0).toDouble(),dataInicio:j['dataInicio']??'',situacaoAtual:j['situacaoAtual']??'',documentosExistentes:List<String>.from(j['documentosExistentes']??[]),rendaMensal:(j['rendaMensal']??0).toDouble(),gastosEssenciais:(j['gastosEssenciais']??0).toDouble(),impostosTaxas:(j['impostosTaxas']??0).toDouble(),parcelasAtuais:(j['parcelasAtuais']??0).toDouble(),dividasVencidas:(j['dividasVencidas']??0).toDouble(),objetivo:j['objetivo']??'',dataCriacao:j['dataCriacao']!=null?DateTime.tryParse(j['dataCriacao']):null);
}
