import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/caso_model.dart';
import 'resultado_screen.dart';

const _azul = Color(0xFF5B9BD5);
const _azulClaro = Color(0xFFEBF3FB);
const _cinzaTexto = Color(0xFF2D3748);
const _cinzaSubtexto = Color(0xFF718096);
const _borda = Color(0xFFE2E8F0);
const _fundo = Color(0xFFF5F7FA);

class DiagnosticoScreen extends StatefulWidget {
  final CasoModel caso;

  const DiagnosticoScreen({super.key, required this.caso});

  @override
  State<DiagnosticoScreen> createState() => _DiagnosticoScreenState();
}

class _DiagnosticoScreenState extends State<DiagnosticoScreen> {
  int _step = 0;
  static const int _totalSteps = 5;

  final _credorController = TextEditingController();
  final _valorController = TextEditingController();
  final _dataController = TextEditingController();
  String? _situacaoSelecionada;

  final Map<String, bool> _documentos = {
    'Contrato ou termo de adesao': false,
    'Boleto ou fatura': false,
    'Comprovante de pagamento': false,
    'Notificacao de cobranca': false,
    'Print de mensagem ou e-mail': false,
    'Certidao de Divida Ativa (CDA)': false,
    'Guia de imposto ou tributo': false,
    'Protocolo de reclamacao anterior': false,
    'Mandado ou citacao judicial': false,
  };

  final _rendaController = TextEditingController();
  final _gastosController = TextEditingController();
  final _impostosController = TextEditingController();
  final _parcelasController = TextEditingController();
  final _dividasVencidasController = TextEditingController();

  final List<String> _stepTitulos = [
    'Tipo de problema',
    'Detalhes da situacao',
    'Documentos',
    'Suas financas',
    'Objetivo',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fundo,
      appBar: AppBar(
        title: Text(_stepTitulos[_step]),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => _step > 0
              ? setState(() => _step--)
              : Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: _borda),
        ),
      ),
      body: Column(
        children: [
          // Barra de progresso
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(_totalSteps, (i) {
                    final active = i == _step;
                    final done = i < _step;
                    return Expanded(
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: done
                                  ? const Color(0xFF48BB78)
                                  : active
                                      ? _azul
                                      : const Color(0xFFEDF2F7),
                              border: active
                                  ? Border.all(
                                      color: _azul.withValues(alpha: 0.3),
                                      width: 3)
                                  : null,
                            ),
                            child: Center(
                              child: done
                                  ? const Icon(Icons.check,
                                      color: Colors.white, size: 13)
                                  : Text(
                                      '${i + 1}',
                                      style: TextStyle(
                                        color: active
                                            ? Colors.white
                                            : _cinzaSubtexto,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          if (i < _totalSteps - 1)
                            Expanded(
                              child: Container(
                                height: 2,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                decoration: BoxDecoration(
                                  color: done
                                      ? const Color(0xFF48BB78)
                                      : _borda,
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (_step + 1) / _totalSteps,
                    backgroundColor: _borda,
                    valueColor: const AlwaysStoppedAnimation<Color>(_azul),
                    minHeight: 3,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _buildStep(),
            ),
          ),

          // Botoes
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: _borda)),
            ),
            child: Row(
              children: [
                if (_step > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => _step--),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(color: _borda),
                        foregroundColor: _cinzaSubtexto,
                      ),
                      child: const Text('Voltar'),
                    ),
                  ),
                if (_step > 0) const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _avancar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _azul,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      _step < _totalSteps - 1 ? 'Proximo' : 'Ver Diagnostico',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0: return _buildTipoDivida();
      case 1: return _buildDetalhes();
      case 2: return _buildDocumentos();
      case 3: return _buildFinancas();
      case 4: return _buildObjetivo();
      default: return const SizedBox();
    }
  }

  void _avancar() {
    if (_step == 0 && widget.caso.tipoDivida.isEmpty) {
      _showErro('Selecione o tipo de problema para continuar');
      return;
    }
    if (_step == 4 && widget.caso.objetivo.isEmpty) {
      _showErro('Selecione seu objetivo para continuar');
      return;
    }
    if (_step == 1) {
      widget.caso.credor = _credorController.text.trim();
      widget.caso.valor =
          double.tryParse(_valorController.text.replaceAll(',', '.')) ?? 0;
      widget.caso.dataInicio = _dataController.text.trim();
      widget.caso.situacaoAtual = _situacaoSelecionada ?? '';
    }
    if (_step == 2) {
      widget.caso.documentosExistentes = _documentos.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();
    }
    if (_step == 3) {
      widget.caso.rendaMensal =
          double.tryParse(_rendaController.text.replaceAll(',', '.')) ?? 0;
      widget.caso.gastosEssenciais =
          double.tryParse(_gastosController.text.replaceAll(',', '.')) ?? 0;
      widget.caso.impostosTaxas =
          double.tryParse(_impostosController.text.replaceAll(',', '.')) ?? 0;
      widget.caso.parcelasAtuais =
          double.tryParse(_parcelasController.text.replaceAll(',', '.')) ?? 0;
      widget.caso.dividasVencidas = double.tryParse(
              _dividasVencidasController.text.replaceAll(',', '.')) ?? 0;
    }
    if (_step < _totalSteps - 1) {
      setState(() => _step++);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ResultadoScreen(caso: widget.caso)),
      );
    }
  }

  void _showErro(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: const Color(0xFFE53E3E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _tituloStep(String titulo, String subtitulo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _cinzaTexto)),
        const SizedBox(height: 4),
        Text(subtitulo,
            style: const TextStyle(fontSize: 13, color: _cinzaSubtexto)),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTipoDivida() {
    final tipos = [
      ('banco_cartao', Icons.credit_card_outlined, 'Divida com banco/cartao',
          'Emprestimo, cartao, cheque especial, cobranca abusiva'),
      ('empresa', Icons.store_outlined, 'Cobranca indevida de empresa',
          'Telefonia, loja, servico cancelado, assinatura, boleto errado'),
      ('nome_negativado', Icons.report_outlined, 'Nome negativado',
          'Serasa/SPC, divida desconhecida, negativacao apos pagamento'),
      ('superendividamento', Icons.trending_down, 'Superendividamento',
          'Muitas dividas, renda insuficiente, precisa de reorganizacao'),
      ('governo_imposto', Icons.account_balance_outlined,
          'Divida com governo/imposto',
          'IPTU, IPVA, DAS/MEI, divida ativa, taxas municipais'),
      ('execucao_judicial', Icons.gavel_outlined, 'Execucao/cobranca judicial',
          'Citacao, bloqueio, mandado, carta, protesto'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _tituloStep('Qual e o seu problema?',
            'Selecione a opcao que melhor descreve sua situacao.'),
        ...tipos.map((t) => _OpcaoCard(
              icon: t.$2,
              title: t.$3,
              subtitle: t.$4,
              selected: widget.caso.tipoDivida == t.$1,
              onTap: () => setState(() => widget.caso.tipoDivida = t.$1),
            )),
      ],
    );
  }

  Widget _buildDetalhes() {
    final situacoes = [
      'Recebi cobranca por carta/e-mail',
      'Recebi ligacoes de cobranca',
      'Fui negativado no Serasa/SPC',
      'Recebi notificacao judicial/citacao',
      'Tive bens bloqueados',
      'Divida inscrita em divida ativa',
      'Recebi proposta de acordo',
      'Outro',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _tituloStep('Detalhes da sua situacao',
            'Preencha o que souber. Nenhum campo e obrigatorio.'),
        TextField(
          controller: _credorController,
          style: const TextStyle(color: _cinzaTexto),
          decoration: const InputDecoration(
            labelText: 'Quem esta cobrando?',
            hintText: 'Ex: Banco Bradesco, Claro, Prefeitura de SP',
            prefixIcon: Icon(Icons.business_outlined, color: _azul),
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _valorController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.,]'))],
          style: const TextStyle(color: _cinzaTexto),
          decoration: const InputDecoration(
            labelText: 'Valor aproximado da divida',
            hintText: 'Ex: 2500',
            prefixIcon: Icon(Icons.attach_money, color: _azul),
            prefixText: 'R\$ ',
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _dataController,
          style: const TextStyle(color: _cinzaTexto),
          decoration: const InputDecoration(
            labelText: 'Desde quando? (mes/ano)',
            hintText: 'Ex: Janeiro/2024',
            prefixIcon: Icon(Icons.calendar_today_outlined, color: _azul),
          ),
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          value: _situacaoSelecionada,
          dropdownColor: Colors.white,
          style: const TextStyle(color: _cinzaTexto, fontSize: 14),
          decoration: const InputDecoration(
            labelText: 'Situacao atual',
            prefixIcon: Icon(Icons.flag_outlined, color: _azul),
          ),
          items: situacoes
              .map((s) => DropdownMenuItem(
                  value: s,
                  child: Text(s, style: const TextStyle(fontSize: 13))))
              .toList(),
          onChanged: (v) => setState(() => _situacaoSelecionada = v),
        ),
      ],
    );
  }

  Widget _buildDocumentos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _tituloStep('Quais documentos voce tem?',
            'Marque os que voce ja possui. Vamos listar o que falta.'),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _borda),
          ),
          child: Column(
            children: _documentos.keys.map((doc) {
              final isLast = doc == _documentos.keys.last;
              return Column(
                children: [
                  CheckboxListTile(
                    value: _documentos[doc],
                    onChanged: (v) => setState(() => _documentos[doc] = v!),
                    title: Text(doc,
                        style: const TextStyle(fontSize: 13, color: _cinzaTexto)),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: _azul,
                    checkColor: Colors.white,
                    side: const BorderSide(color: _borda),
                  ),
                  if (!isLast)
                    Container(
                        height: 1,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        color: _borda),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _azulClaro,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _azul.withValues(alpha: 0.2)),
          ),
          child: const Row(
            children: [
              Icon(Icons.lightbulb_outline, color: _azul, size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Quanto mais documentos, mais completo sera seu relatorio.',
                  style: TextStyle(fontSize: 12, color: _cinzaTexto),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFinancas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _tituloStep('Organize suas financas',
            'Vamos calcular quanto voce pode pagar por mes com seguranca.'),
        _CampoMonetario(
            controller: _rendaController,
            label: 'Renda mensal liquida',
            hint: 'Ex: 2500',
            icon: Icons.trending_up),
        const SizedBox(height: 12),
        _CampoMonetario(
            controller: _gastosController,
            label: 'Gastos essenciais mensais',
            hint: 'Aluguel, mercado, transporte, saude...',
            icon: Icons.home_outlined),
        const SizedBox(height: 12),
        _CampoMonetario(
            controller: _impostosController,
            label: 'Impostos e taxas mensais',
            hint: 'IPTU, IPVA, DAS/MEI...',
            icon: Icons.account_balance_outlined),
        const SizedBox(height: 12),
        _CampoMonetario(
            controller: _parcelasController,
            label: 'Parcelas ja existentes',
            hint: 'Financiamentos, acordos ja feitos...',
            icon: Icons.payments_outlined),
        const SizedBox(height: 12),
        _CampoMonetario(
            controller: _dividasVencidasController,
            label: 'Total de dividas vencidas',
            hint: 'Soma de todas as dividas em aberto',
            icon: Icons.warning_amber_outlined),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _borda),
          ),
          child: Row(
            children: [
              Icon(Icons.lock_outline, color: Colors.grey.shade400, size: 16),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Seus dados financeiros sao usados apenas para calcular sua capacidade de pagamento.',
                  style: TextStyle(fontSize: 11, color: _cinzaSubtexto),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildObjetivo() {
    final objetivos = [
      ('contestar', Icons.gavel_outlined, 'Contestar ou reclamar a cobranca',
          'Acho que a cobranca esta errada ou e indevida'),
      ('negociar', Icons.handshake_outlined, 'Negociar ou renegociar',
          'Quero entrar em acordo com condicoes melhores'),
      ('parcelar', Icons.calendar_today_outlined, 'Parcelar a divida',
          'Quero pagar mas preciso dividir em parcelas'),
      ('defensoria', Icons.balance_outlined, 'Buscar Defensoria Publica',
          'Nao tenho condicoes de pagar advogado'),
      ('profissional', Icons.person_outline, 'Buscar advogado ou contador',
          'Quero ajuda profissional especializada'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _tituloStep('O que voce quer fazer?',
            'Isso define qual documento vamos preparar para voce.'),
        ...objetivos.map((o) => _OpcaoCard(
              icon: o.$2,
              title: o.$3,
              subtitle: o.$4,
              selected: widget.caso.objetivo == o.$1,
              onTap: () => setState(() => widget.caso.objetivo = o.$1),
            )),
      ],
    );
  }

  @override
  void dispose() {
    _credorController.dispose();
    _valorController.dispose();
    _dataController.dispose();
    _rendaController.dispose();
    _gastosController.dispose();
    _impostosController.dispose();
    _parcelasController.dispose();
    _dividasVencidasController.dispose();
    super.dispose();
  }
}

class _OpcaoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _OpcaoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? _azulClaro : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? _azul : _borda,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: selected
                    ? _azul.withValues(alpha: 0.15)
                    : const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon,
                  color: selected ? _azul : _cinzaSubtexto, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: selected ? _azul : _cinzaTexto)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 12, color: _cinzaSubtexto)),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle, color: _azul, size: 18),
          ],
        ),
      ),
    );
  }
}

class _CampoMonetario extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;

  const _CampoMonetario({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.,]'))],
      style: const TextStyle(color: _cinzaTexto),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: _azul),
        prefixText: 'R\$ ',
      ),
    );
  }
}
