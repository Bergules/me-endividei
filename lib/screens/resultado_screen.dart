import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../models/caso_model.dart';
import '../services/relatorio_service.dart';

const _azul = Color(0xFF5B9BD5);
const _azulClaro = Color(0xFFEBF3FB);
const _cinzaTexto = Color(0xFF2D3748);
const _cinzaSubtexto = Color(0xFF718096);
const _borda = Color(0xFFE2E8F0);
const _verde = Color(0xFF48BB78);
const _verdeClaro = Color(0xFFEBF8F1);
const _vermelho = Color(0xFFE53E3E);
const _vermelhoClaro = Color(0xFFFFF5F5);

class ResultadoScreen extends StatelessWidget {
  final CasoModel caso;

  const ResultadoScreen({super.key, required this.caso});

  @override
  Widget build(BuildContext context) {
    final espaco = caso.espacoSeguro;
    final canal = RelatorioService.getCanalSugerido(caso);
    final modelo = RelatorioService.getModeloTexto(caso);
    final faltantes = RelatorioService.getDocumentosFaltantes(caso);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Seu Diagnostico'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => _gerarPDF(context),
            icon: const Icon(Icons.picture_as_pdf_outlined,
                color: _azul, size: 18),
            label: const Text('PDF',
                style: TextStyle(
                    color: _azul, fontWeight: FontWeight.w600, fontSize: 13)),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: _borda),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner de sucesso
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF5B9BD5), Color(0xFF7FB3E0)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check,
                        color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Diagnostico concluido!',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text(
                          'Ola, ${caso.nome}! Seu caso foi organizado.',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Problema
            _Secao(
              icon: Icons.search_rounded,
              iconColor: _azul,
              titulo: 'Problema identificado',
              child: Column(
                children: [
                  _InfoLinha('Tipo', caso.tipoDividaLabel),
                  if (caso.credor.isNotEmpty)
                    _InfoLinha('Credor', caso.credor),
                  if (caso.valor > 0)
                    _InfoLinha('Valor',
                        'R\$ ${caso.valor.toStringAsFixed(2).replaceAll('.', ',')}'),
                  if (caso.dataInicio.isNotEmpty)
                    _InfoLinha('Desde', caso.dataInicio),
                  if (caso.situacaoAtual.isNotEmpty)
                    _InfoLinha('Situacao', caso.situacaoAtual),
                  _InfoLinha('Objetivo', caso.objetivoLabel),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Capacidade financeira
            if (caso.rendaMensal > 0)
              _Secao(
                icon: Icons.calculate_outlined,
                iconColor: const Color(0xFF48BB78),
                titulo: 'Sua capacidade de pagamento',
                child: Column(
                  children: [
                    _LinhaFinanca('Renda mensal', caso.rendaMensal,
                        _verde, false),
                    _LinhaFinanca('Gastos essenciais', caso.gastosEssenciais,
                        _vermelho, true),
                    _LinhaFinanca('Impostos/taxas', caso.impostosTaxas,
                        const Color(0xFFED8936), true),
                    _LinhaFinanca('Parcelas existentes', caso.parcelasAtuais,
                        const Color(0xFFED8936), true),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: espaco > 0 ? _verdeClaro : _vermelhoClaro,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: espaco > 0
                                ? _verde.withValues(alpha: 0.3)
                                : _vermelho.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Espaco seguro para acordo:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: espaco > 0
                                          ? _verde
                                          : _vermelho)),
                              Text(
                                'R\$ ${espaco.toStringAsFixed(2).replaceAll('.', ',')}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: espaco > 0 ? _verde : _vermelho),
                              ),
                            ],
                          ),
                          if (espaco <= 0) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Sua renda nao cobre os gastos atuais. Voce pode ter direito a protecao por superendividamento (Lei 14.181/2021).',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: _vermelho.withValues(alpha: 0.8),
                                  height: 1.4),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 14),

            // Documentos
            _Secao(
              icon: Icons.folder_outlined,
              iconColor: const Color(0xFFED8936),
              titulo: 'Organizacao de documentos',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (caso.documentosExistentes.isNotEmpty) ...[
                    Text('Voce ja tem:',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: _verde,
                            fontSize: 13)),
                    const SizedBox(height: 8),
                    ...caso.documentosExistentes
                        .map((d) => _ItemDoc(d, true)),
                    const SizedBox(height: 12),
                  ],
                  if (faltantes.isNotEmpty) ...[
                    Text('Ainda precisa obter:',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFED8936).withValues(alpha: 0.9),
                            fontSize: 13)),
                    const SizedBox(height: 8),
                    ...faltantes.map((d) => _ItemDoc(d, false)),
                  ],
                  if (caso.documentosExistentes.isEmpty && faltantes.isEmpty)
                    const Text(
                      'Nenhum documento informado.',
                      style: TextStyle(fontSize: 13, color: _cinzaSubtexto),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Caminho sugerido
            _Secao(
              icon: Icons.map_outlined,
              iconColor: const Color(0xFF805AD5),
              titulo: 'Caminho sugerido',
              child: Text(canal,
                  style: const TextStyle(
                      fontSize: 13, color: _cinzaTexto, height: 1.6)),
            ),

            const SizedBox(height: 14),

            // Modelo de texto
            _Secao(
              icon: Icons.description_outlined,
              iconColor: const Color(0xFF319795),
              titulo: 'Modelo de texto para sua situacao',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.circular(10),
                      border: const Border(
                          left: BorderSide(color: _azul, width: 3)),
                    ),
                    child: Text(modelo,
                        style: const TextStyle(
                            fontSize: 13,
                            color: _cinzaTexto,
                            height: 1.6,
                            fontStyle: FontStyle.italic)),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '* Revise e adapte o texto antes de enviar.',
                    style: TextStyle(fontSize: 11, color: _cinzaSubtexto),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Aviso legal
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _borda),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline,
                      color: Colors.grey.shade400, size: 18),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Este diagnostico organiza informacoes e prepara documentos administrativos. '
                      'Nao substitui advogado, contador ou Defensoria Publica.',
                      style: TextStyle(
                          fontSize: 12,
                          height: 1.5,
                          color: _cinzaSubtexto),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Botao PDF
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _gerarPDF(context),
                icon: const Icon(Icons.picture_as_pdf_outlined, size: 20),
                label: const Text('Gerar Relatorio em PDF',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _azul,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () =>
                    Navigator.of(context).popUntil((r) => r.isFirst),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Novo Diagnostico'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  side: const BorderSide(color: _borda),
                  foregroundColor: _cinzaSubtexto,
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Future<void> _gerarPDF(BuildContext context) async {
    try {
      final pdfBytes = await RelatorioService.gerarPDF(caso);
      await Printing.layoutPdf(
        onLayout: (_) async => Uint8List.fromList(pdfBytes),
        name:
            'relatorio_me_endividei_${caso.nome.replaceAll(' ', '_')}.pdf',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao gerar PDF: $e'),
            backgroundColor: _vermelho,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}

// Widgets auxiliares

class _Secao extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String titulo;
  final Widget child;

  const _Secao({
    required this.icon,
    required this.iconColor,
    required this.titulo,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _borda),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              const SizedBox(width: 8),
              Text(titulo,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: _cinzaTexto)),
            ],
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: _borda),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _InfoLinha extends StatelessWidget {
  final String label;
  final String valor;

  const _InfoLinha(this.label, this.valor);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label,
                style: const TextStyle(
                    color: _cinzaSubtexto, fontSize: 12)),
          ),
          Expanded(
            child: Text(valor,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: _cinzaTexto)),
          ),
        ],
      ),
    );
  }
}

class _LinhaFinanca extends StatelessWidget {
  final String label;
  final double valor;
  final Color cor;
  final bool negativo;

  const _LinhaFinanca(this.label, this.valor, this.cor, this.negativo);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 13, color: _cinzaSubtexto)),
          Text(
            '${negativo ? "- " : ""}R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}',
            style: TextStyle(
                fontWeight: FontWeight.w600, color: cor, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _ItemDoc extends StatelessWidget {
  final String texto;
  final bool ok;

  const _ItemDoc(this.texto, this.ok);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            ok ? Icons.check_circle_outline : Icons.arrow_forward_ios,
            size: ok ? 16 : 12,
            color: ok ? _verde : const Color(0xFFED8936),
          ),
          const SizedBox(width: 8),
          Expanded(
              child: Text(texto,
                  style: const TextStyle(fontSize: 13, color: _cinzaTexto))),
        ],
      ),
    );
  }
}
