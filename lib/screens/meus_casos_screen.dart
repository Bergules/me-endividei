import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/caso_model.dart';
import 'resultado_screen.dart';

const _azul = Color(0xFF5B9BD5);
const _cinzaTexto = Color(0xFF2D3748);
const _cinzaSubtexto = Color(0xFF718096);
const _borda = Color(0xFFE2E8F0);

class MeusCasosScreen extends StatefulWidget {
  const MeusCasosScreen({super.key});

  @override
  State<MeusCasosScreen> createState() => _MeusCasosScreenState();
}

class _MeusCasosScreenState extends State<MeusCasosScreen> {
  List<CasoModel> _casos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final casos = await StorageService.carregarCasos();
    if (mounted) setState(() { _casos = casos; _carregando = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Meus Casos'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: _borda),
        ),
        actions: [
          if (_casos.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Color(0xFFE53E3E)),
              onPressed: _confirmarLimpeza,
              tooltip: 'Limpar historico',
            ),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator(color: _azul))
          : _casos.isEmpty
              ? _vazio()
              : RefreshIndicator(
                  onRefresh: _carregar,
                  color: _azul,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _casos.length,
                    itemBuilder: (_, i) => _CardCaso(
                      caso: _casos[i],
                      numero: _casos.length - i,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ResultadoScreen(caso: _casos[i])),
                        );
                      },
                    ),
                  ),
                ),
    );
  }

  Widget _vazio() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.folder_open_outlined,
              color: Color(0xFFCBD5E0), size: 64),
          const SizedBox(height: 16),
          const Text('Nenhum diagnostico salvo',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: _cinzaTexto)),
          const SizedBox(height: 6),
          const Text('Seus diagnosticos aparecerao aqui\napos serem concluidos.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _cinzaSubtexto, height: 1.4)),
        ],
      ),
    );
  }

  void _confirmarLimpeza() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Limpar historico'),
        content: const Text('Deseja remover todos os diagnosticos salvos?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              await StorageService.limparCasos();
              if (mounted) Navigator.pop(context);
              _carregar();
            },
            child: const Text('Limpar',
                style: TextStyle(color: Color(0xFFE53E3E))),
          ),
        ],
      ),
    );
  }
}

class _CardCaso extends StatelessWidget {
  final CasoModel caso;
  final int numero;
  final VoidCallback onTap;

  const _CardCaso({required this.caso, required this.numero, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _borda),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFEBF3FB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(caso.tipoDividaEmoji,
                    style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(caso.tipoDividaLabel,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: _cinzaTexto)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBF3FB),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('#$numero',
                            style: const TextStyle(
                                fontSize: 11,
                                color: _azul,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (caso.credor.isNotEmpty) ...[
                        const Icon(Icons.business_outlined,
                            size: 12, color: _cinzaSubtexto),
                        const SizedBox(width: 3),
                        Text(caso.credor,
                            style: const TextStyle(
                                fontSize: 12, color: _cinzaSubtexto)),
                        const SizedBox(width: 8),
                      ],
                      if (caso.valor > 0) ...[
                        const Icon(Icons.attach_money,
                            size: 12, color: _cinzaSubtexto),
                        Text(
                          'R\$ ${caso.valor.toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontSize: 12, color: _cinzaSubtexto),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(caso.objetivoLabel,
                      style: const TextStyle(
                          fontSize: 11, color: _azul)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFCBD5E0)),
          ],
        ),
      ),
    );
  }
}
