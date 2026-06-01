import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/caso_model.dart';

class RelatorioService {
  static String getCanalSugerido(CasoModel caso) {
    if (caso.objetivo == 'defensoria') {
      return 'Defensoria Publica: Atendimento gratuito para quem nao pode pagar advogado. '
          'Leve este relatorio e todos os documentos disponiveis. '
          'Acesse o site da Defensoria Publica do seu estado para agendar atendimento.';
    }
    if (caso.objetivo == 'profissional') {
      return 'Advogado: Para casos com execucao fiscal, processo judicial ou teses tributarias complexas.\n\n'
          'Contador: Para regularizacao de MEI, DAS atrasado, divida ativa da Receita Federal.';
    }
    if (caso.objetivo == 'negociar' || caso.objetivo == 'parcelar') {
      return 'Contato direto com o credor: Use o espaco seguro calculado como base de negociacao.\n\n'
          'consumidor.gov.br: Para empresas, negociar pela plataforma oficial do governo.\n\n'
          'Prefeitura/Estado: Para impostos, verifique programas de parcelamento como REFIS.\n\n'
          'Lei do Superendividamento (14.181/2021): Se dividas superam capacidade, voce pode pedir repactuacao.';
    }
    switch (caso.tipoDivida) {
      case 'banco_cartao':
        return 'consumidor.gov.br: Registre reclamacao contra o banco.\n\n'
            'Banco Central (bacen.gov.br): Para reclamacoes contra instituicoes financeiras.\n\n'
            'Procon: Se necessario, busque o orgao de defesa do consumidor do seu estado.';
      case 'empresa':
      case 'nome_negativado':
        return 'consumidor.gov.br: Plataforma oficial para reclamacoes contra empresas. '
            'Compromisso de resposta em ate 10 dias.\n\n'
            'Procon: Orgao de defesa do consumidor para o que o consumidor.gov.br nao resolver.';
      case 'governo_imposto':
        return 'Secretaria/Setor Tributario: Protocole requerimento administrativo no orgao responsavel.\n\n'
            'Se nao resolver, busque a Defensoria Publica ou um advogado tributarista.';
      case 'execucao_judicial':
        return 'URGENTE: Casos com citacao, bloqueio ou mandado requerem atendimento juridico imediato.\n\n'
            'Defensoria Publica ou Advogado: Leve este relatorio e nao ignore prazos judiciais.';
      case 'superendividamento':
        return 'Defensoria Publica: Atendimento para superendividamento com protecao pela Lei 14.181/2021.\n\n'
            'Procon: Para reclamacoes contra empresas envolvidas nas dividas.\n\n'
            'Juizado Especial Civel: Para causas ate 40 salarios minimos, sem necessidade de advogado.';
      default:
        return 'consumidor.gov.br: Para reclamacoes contra empresas.\n\n'
            'Procon: Para problemas de consumo que precisam de orgao de defesa.\n\n'
            'Defensoria Publica: Para atendimento gratuito em casos complexos.';
    }
  }

  static String getModeloTexto(CasoModel caso) {
    final credor = caso.credor.isEmpty ? '[NOME DO CREDOR]' : caso.credor;
    final valor = caso.valor > 0
        ? 'R\$ ${caso.valor.toStringAsFixed(2).replaceAll('.', ',')}'
        : '[VALOR]';
    final data = caso.dataInicio.isEmpty ? '[DATA]' : caso.dataInicio;

    switch (caso.objetivo) {
      case 'contestar':
        return 'Solicito revisao da cobranca no valor de $valor, realizada por $credor '
            'desde $data. Com base nas informacoes disponiveis, entendo que a cobranca '
            'pode conter irregularidades. Requeiro apresentacao da origem do debito, '
            'memoria de calculo e contratos, para que eu possa exercer meu direito de '
            'esclarecimento e contestacao, nos termos do Codigo de Defesa do Consumidor.';
      case 'negociar':
        final espaco = caso.espacoSeguro;
        final espacoStr = espaco > 0
            ? 'R\$ ${espaco.toStringAsFixed(2).replaceAll('.', ',')}'
            : '[VALOR QUE PODE PAGAR]';
        return 'Solicito proposta de renegociacao referente ao debito de $valor junto a $credor. '
            'Minha capacidade de pagamento atual e de aproximadamente $espacoStr por mes. '
            'Solicito reducao de encargos, exclusao de multas abusivas e parcelamento '
            'compativel com minha condicao financeira, nos termos do art. 54-A do CDC '
            'e da Lei n. 14.181/2021.';
      case 'parcelar':
        return 'Solicito parcelamento do debito no valor de $valor referente a $credor. '
            'Proponho pagamento em parcelas mensais compativeis com minha situacao financeira. '
            'Requeiro proposta formal com valores, prazo, taxa de juros e condicoes gerais '
            'do acordo, para analise e aceite dentro do prazo legal.';
      case 'defensoria':
        return 'Solicito atendimento referente a situacao de ${caso.tipoDividaLabel} '
            'com $credor, no valor de $valor, desde $data. '
            'Nao possuo condicoes financeiras de contratar advogado particular. '
            'Com base nas informacoes fornecidas, este resumo pode auxiliar na solicitacao '
            'de revisao administrativa ou no atendimento juridico adequado.';
      default:
        return 'Solicito esclarecimentos e revisao administrativa do debito informado, '
            'no valor de $valor, referente a cobranca de $credor desde $data. '
            'Requeiro apresentacao da origem da cobranca, memoria de calculo, periodo cobrado '
            'e eventuais acrescimos, para que eu possa exercer meu direito de esclarecimento '
            'e regularizacao.';
    }
  }

  static List<String> getDocumentosFaltantes(CasoModel caso) {
    final necessarios = _getDocumentosNecessarios(caso);
    return necessarios
        .where((d) => !caso.documentosExistentes.contains(d))
        .toList();
  }

  static List<String> _getDocumentosNecessarios(CasoModel caso) {
    const base = [
      'Comprovante de identidade (RG/CPF)',
      'Comprovante de residencia'
    ];
    switch (caso.tipoDivida) {
      case 'banco_cartao':
        return [
          ...base,
          'Extrato da conta/cartao',
          'Contrato ou termo de adesao',
          'Boleto ou fatura'
        ];
      case 'empresa':
        return [
          ...base,
          'Contrato ou termo de adesao',
          'Boleto ou fatura',
          'Comprovante de pagamento',
          'Print de mensagem ou e-mail'
        ];
      case 'nome_negativado':
        return [
          ...base,
          'Comprovante de pagamento',
          'Extrato do Serasa/SPC',
          'Notificacao de cobranca'
        ];
      case 'superendividamento':
        return [
          ...base,
          'Extratos de todas as dividas',
          'Comprovante de renda',
          'Comprovante de gastos essenciais'
        ];
      case 'governo_imposto':
        return [
          ...base,
          'Certidao de Divida Ativa (CDA)',
          'Guia de imposto ou tributo',
          'Comprovante de pagamento anterior'
        ];
      case 'execucao_judicial':
        return [
          ...base,
          'Mandado ou citacao judicial',
          'Certidao de Divida Ativa (CDA)',
          'Protocolo de notificacao anterior'
        ];
      default:
        return [...base, 'Contrato ou boleto', 'Comprovante de pagamento'];
    }
  }

  static Future<List<int>> gerarPDF(CasoModel caso) async {
    final pdf = pw.Document();
    final canal = getCanalSugerido(caso);
    final modelo = getModeloTexto(caso);
    final faltantes = getDocumentosFaltantes(caso);
    final now = DateTime.now();

    const azul = PdfColor(0.084, 0.396, 0.753);
    const verdeClaro = PdfColor(0.94, 1.0, 0.94);
    const vermelhoClaro = PdfColor(1.0, 0.94, 0.94);
    const amareloClaro = PdfColor(1.0, 0.98, 0.88);
    const cinzaClaro = PdfColor(0.97, 0.97, 0.97);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (ctx) => [
          // Cabecalho
          pw.Container(
            padding: const pw.EdgeInsets.all(20),
            decoration: const pw.BoxDecoration(
              color: azul,
              borderRadius: pw.BorderRadius.all(pw.Radius.circular(10)),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Me Endividei',
                    style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white)),
                pw.SizedBox(height: 4),
                pw.Text('Relatorio de Diagnostico',
                    style: const pw.TextStyle(
                        fontSize: 13, color: PdfColors.white)),
                pw.SizedBox(height: 8),
                pw.Text(
                    'Gerado em: ${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}',
                    style: const pw.TextStyle(
                        fontSize: 10, color: PdfColors.white)),
              ],
            ),
          ),

          pw.SizedBox(height: 20),
          _secao('DADOS DO USUARIO', azul),
          _linha('Nome', caso.nome),
          _linha('E-mail', caso.email),
          _linha('Estado', caso.estado),
          _linha('Perfil', caso.perfilLabel),

          pw.SizedBox(height: 14),
          _secao('TIPO DE PROBLEMA IDENTIFICADO', azul),
          _linha('Categoria', caso.tipoDividaLabel),
          if (caso.credor.isNotEmpty) _linha('Credor/Orgao', caso.credor),
          if (caso.valor > 0)
            _linha('Valor',
                'R\$ ${caso.valor.toStringAsFixed(2).replaceAll('.', ',')}'),
          if (caso.dataInicio.isNotEmpty) _linha('Desde', caso.dataInicio),
          if (caso.situacaoAtual.isNotEmpty)
            _linha('Situacao', caso.situacaoAtual),
          _linha('Objetivo', caso.objetivoLabel),

          if (caso.rendaMensal > 0) ...[
            pw.SizedBox(height: 14),
            _secao('ORGANIZACAO FINANCEIRA', azul),
            _linha('Renda mensal',
                'R\$ ${caso.rendaMensal.toStringAsFixed(2).replaceAll('.', ',')}'),
            _linha('Gastos essenciais',
                'R\$ ${caso.gastosEssenciais.toStringAsFixed(2).replaceAll('.', ',')}'),
            _linha('Impostos/taxas',
                'R\$ ${caso.impostosTaxas.toStringAsFixed(2).replaceAll('.', ',')}'),
            _linha('Parcelas existentes',
                'R\$ ${caso.parcelasAtuais.toStringAsFixed(2).replaceAll('.', ',')}'),
            _linha('Total dividas vencidas',
                'R\$ ${caso.dividasVencidas.toStringAsFixed(2).replaceAll('.', ',')}'),
            pw.SizedBox(height: 8),
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: caso.espacoSeguro > 0 ? verdeClaro : vermelhoClaro,
                borderRadius:
                    const pw.BorderRadius.all(pw.Radius.circular(6)),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Espaco seguro para acordo:',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 11)),
                  pw.Text(
                      'R\$ ${caso.espacoSeguro.toStringAsFixed(2).replaceAll('.', ',')}',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 12)),
                ],
              ),
            ),
          ],

          if (caso.documentosExistentes.isNotEmpty) ...[
            pw.SizedBox(height: 14),
            _secao('DOCUMENTOS DISPONIVEIS', azul),
            ...caso.documentosExistentes.map((d) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 3),
                  child: pw.Text('  checkmark  $d',
                      style: const pw.TextStyle(fontSize: 11)),
                )),
          ],

          if (faltantes.isNotEmpty) ...[
            pw.SizedBox(height: 14),
            _secao('DOCUMENTOS AINDA NECESSARIOS', azul),
            ...faltantes.map((d) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 3),
                  child: pw.Text('  -> $d',
                      style: const pw.TextStyle(fontSize: 11)),
                )),
          ],

          pw.SizedBox(height: 14),
          _secao('CAMINHO SUGERIDO', azul),
          pw.Text(canal,
              style: const pw.TextStyle(fontSize: 11, lineSpacing: 2)),

          pw.SizedBox(height: 14),
          _secao('MODELO DE TEXTO', azul),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: cinzaClaro,
              borderRadius:
                  const pw.BorderRadius.all(pw.Radius.circular(6)),
              border: const pw.Border(
                left: pw.BorderSide(color: azul, width: 3),
              ),
            ),
            child: pw.Text(modelo,
                style: const pw.TextStyle(fontSize: 11, lineSpacing: 2)),
          ),
          pw.SizedBox(height: 6),
          pw.Text('* Revise e adapte o texto antes de enviar.',
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),

          pw.SizedBox(height: 16),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: const pw.BoxDecoration(
              color: amareloClaro,
              borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
            ),
            child: pw.Text(
              'AVISO: Este relatorio organiza informacoes e prepara documentos administrativos. '
              'Nao substitui advogado, contador ou Defensoria Publica. '
              'Em casos de processo judicial ou execucao fiscal, procure atendimento profissional.',
              style: const pw.TextStyle(fontSize: 10, lineSpacing: 2),
            ),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _secao(String titulo, PdfColor cor) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(titulo,
            style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                color: cor)),
        pw.Container(height: 1, color: cor),
        pw.SizedBox(height: 6),
      ],
    );
  }

  static pw.Widget _linha(String label, String valor) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 130,
            child: pw.Text(label,
                style: const pw.TextStyle(
                    fontSize: 10, color: PdfColors.grey700)),
          ),
          pw.Expanded(
            child: pw.Text(valor,
                style: pw.TextStyle(
                    fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
