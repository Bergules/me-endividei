import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../models/caso_model.dart';
import 'resultado_screen.dart';

const _azul = Color(0xFF5B9BD5);
const _azulClaro = Color(0xFFEBF3FB);
const _cinzaTexto = Color(0xFF2D3748);
const _cinzaSubtexto = Color(0xFF718096);
const _borda = Color(0xFFE2E8F0);

class InicioScreen extends StatefulWidget {
  final VoidCallback onNovoDiagnostico;

  const InicioScreen({super.key, required this.onNovoDiagnostico});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  List<CasoModel> _casos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarCasos();
  }

  Future<void> _carregarCasos() async {
    final casos = await StorageService.carregarCasos();
    if (mounted) setState(() { _casos = casos; _carregando = false; });
  }

  @override
  Widget build(BuildContext context) {
    final nome = AuthService.displayName.split(' ').first;
    final hora = DateTime.now().hour;
    final saudacao = hora < 12 ? 'Bom dia' : hora < 18 ? 'Boa tarde' : 'Boa noite';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$saudacao, $nome!',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: _cinzaTexto)),
            const Text('Me Endividei',
                style: TextStyle(fontSize: 12, color: _cinzaSubtexto)),
          ],
        ),
        actions: [
          if (AuthService.photoUrl != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(AuthService.photoUrl!),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: _azulClaro,
                child: Text(
                  nome.isNotEmpty ? nome[0].toUpperCase() : 'U',
                  style: const TextStyle(color: _azul, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: _borda),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _carregarCasos,
        color: _azul,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card principal CTA
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5B9BD5), Color(0xFF7FB3E0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.account_balance_wallet,
                        color: Colors.white, size: 32),
                    const SizedBox(height: 12),
                    const Text('Precisa de ajuda com suas dividas?',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    const Text(
                      'Faca um diagnostico gratuito e descubra o melhor caminho para resolver sua situacao.',
                      style: TextStyle(
                          color: Colors.white, fontSize: 13, height: 1.4),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: widget.onNovoDiagnostico,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: _azul,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 11),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Comecar Diagnostico',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Cards de acesso rapido
              const Text('Acesso rapido',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _cinzaTexto)),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(child: _CardAcesso(
                    icon: Icons.credit_card_outlined,
                    label: 'Banco/\nCartao',
                    color: const Color(0xFF5B9BD5),
                    onTap: widget.onNovoDiagnostico,
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: _CardAcesso(
                    icon: Icons.store_outlined,
                    label: 'Empresa/\nServico',
                    color: const Color(0xFF48BB78),
                    onTap: widget.onNovoDiagnostico,
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: _CardAcesso(
                    icon: Icons.account_balance_outlined,
                    label: 'Governo/\nImposto',
                    color: const Color(0xFF9F7AEA),
                    onTap: widget.onNovoDiagnostico,
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: _CardAcesso(
                    icon: Icons.gavel_outlined,
                    label: 'Judicial',
                    color: const Color(0xFFED8936),
                    onTap: widget.onNovoDiagnostico,
                  )),
                ],
              ),

              const SizedBox(height: 24),

              // Diagnosticos recentes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Diagnosticos recentes',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _cinzaTexto)),
                  if (_casos.isNotEmpty)
                    TextButton(
                      onPressed: () {},
                      child: const Text('Ver todos',
                          style: TextStyle(color: _azul, fontSize: 13)),
                    ),
                ],
              ),
              const SizedBox(height: 10),

              if (_carregando)
                const Center(child: CircularProgressIndicator(color: _azul))
              else if (_casos.isEmpty)
                _EmptyState(onTap: widget.onNovoDiagnostico)
              else
                ..._casos.take(3).map((c) => _CardCasoRecente(
                      caso: c,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ResultadoScreen(caso: c)),
                      ),
                    )),

              const SizedBox(height: 24),

              // Dica
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _borda),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _azulClaro,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.lightbulb_outline,
                          color: _azul, size: 18),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Sabia que a Lei 14.181/2021 protege consumidores superendividados? Faca o diagnostico para entender seus direitos.',
                        style: TextStyle(fontSize: 12, color: _cinzaTexto, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardAcesso extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _CardAcesso({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 6),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, color: Color(0xFF2D3748), height: 1.2)),
          ],
        ),
      ),
    );
  }
}

class _CardCasoRecente extends StatelessWidget {
  final CasoModel caso;
  final VoidCallback onTap;

  const _CardCasoRecente({required this.caso, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Text(caso.tipoDividaEmoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(caso.tipoDividaLabel,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Color(0xFF2D3748))),
                  const SizedBox(height: 2),
                  Text(
                    caso.credor.isNotEmpty ? caso.credor : 'Sem credor informado',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF718096)),
                  ),
                ],
              ),
            ),
            if (caso.valor > 0)
              Text(
                'R\$ ${caso.valor.toStringAsFixed(0)}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5B9BD5),
                    fontSize: 13),
              ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: Color(0xFFCBD5E0), size: 18),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onTap;
  const _EmptyState({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          const Icon(Icons.folder_open_outlined, color: Color(0xFFCBD5E0), size: 44),
          const SizedBox(height: 10),
          const Text('Nenhum diagnostico ainda',
              style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2D3748))),
          const SizedBox(height: 4),
          const Text('Faca seu primeiro diagnostico gratuito',
              style: TextStyle(fontSize: 13, color: Color(0xFF718096))),
          const SizedBox(height: 14),
          TextButton(
            onPressed: onTap,
            child: const Text('Comecar agora',
                style: TextStyle(color: Color(0xFF5B9BD5), fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
