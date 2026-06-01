import 'package:flutter/material.dart';
import '../models/caso_model.dart';
import 'cadastro_screen.dart';

// Paleta de cores
const _azul = Color(0xFF5B9BD5);
const _azulClaro = Color(0xFFEBF3FB);
const _cinzaTexto = Color(0xFF2D3748);
const _cinzaSubtexto = Color(0xFF718096);
const _borda = Color(0xFFE2E8F0);
const _fundo = Color(0xFFF5F7FA);

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fundo,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            shadowColor: const Color(0x1A000000),
            elevation: 1,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _azulClaro,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.account_balance_wallet,
                      color: _azul, size: 20),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Me Endividei',
                  style: TextStyle(
                    color: _cinzaTexto,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Hero — gradiente azul suave
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF5B9BD5), Color(0xFF7FB3E0)],
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(28, 48, 28, 52),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.account_balance_wallet,
                            size: 56, color: Colors.white),
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        'Me Endividei',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Organize sua divida, entenda seus caminhos e prepare documentos para buscar ajuda no lugar certo.',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          height: 1.55,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      ElevatedButton(
                        onPressed: () => _irParaCadastro(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: _azul,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Comecar Diagnostico Gratis',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                // Estatísticas rápidas
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      vertical: 20, horizontal: 24),
                  child: Row(
                    children: [
                      _EstatCard('6', 'categorias\nde divida'),
                      _Divisor(),
                      _EstatCard('5', 'passos\norganizados'),
                      _Divisor(),
                      _EstatCard('PDF', 'relatorio\nexportavel'),
                    ],
                  ),
                ),

                // Como funciona
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Como funciona',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: _cinzaTexto)),
                      const SizedBox(height: 4),
                      const Text('Simples, rapido e gratuito para comecar.',
                          style: TextStyle(
                              color: _cinzaSubtexto, fontSize: 14)),
                      const SizedBox(height: 18),
                      const _FeatureCard(
                        numero: '01',
                        icon: Icons.search_rounded,
                        title: 'Entenda sua divida',
                        description:
                            'Classificamos seu problema: banco, empresa, governo ou judicial.',
                      ),
                      const _FeatureCard(
                        numero: '02',
                        icon: Icons.calculate_outlined,
                        title: 'Organize suas financas',
                        description:
                            'Saiba exatamente quanto voce pode pagar por mes sem comprometer o basico.',
                      ),
                      const _FeatureCard(
                        numero: '03',
                        icon: Icons.description_outlined,
                        title: 'Prepare seus documentos',
                        description:
                            'Gere reclamacoes, checklists e relatorios em PDF para o canal correto.',
                      ),
                    ],
                  ),
                ),

                // Para quem
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _azulClaro,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _azul.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Para quem e?',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _cinzaTexto)),
                        const SizedBox(height: 14),
                        _publicoItem(
                            'Pessoa fisica com dividas ou cobrancas indevidas'),
                        _publicoItem(
                            'MEI com DAS atrasado, divida ativa ou pendencia fiscal'),
                        _publicoItem(
                            'Autonomo com dividas pessoais ou problemas tributarios'),
                        _publicoItem(
                            'Qualquer pessoa com divida de governo, IPTU ou IPVA'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Aviso
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
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
                            'O Me Endividei organiza informacoes e gera documentos administrativos. Nao substitui advogado, contador ou Defensoria Publica.',
                            style: TextStyle(
                                fontSize: 12,
                                height: 1.5,
                                color: _cinzaSubtexto),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // CTA final
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _irParaCadastro(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _azul,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: const Text('Comecar Agora',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _publicoItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: _azul.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: _azul, size: 13),
          ),
          const SizedBox(width: 10),
          Expanded(
              child: Text(text,
                  style: const TextStyle(
                      fontSize: 13, color: _cinzaTexto, height: 1.4))),
        ],
      ),
    );
  }

  void _irParaCadastro(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CadastroScreen(caso: CasoModel())),
    );
  }
}

class _EstatCard extends StatelessWidget {
  final String valor;
  final String label;
  const _EstatCard(this.valor, this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(valor,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _azul)),
          const SizedBox(height: 2),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 11,
                  color: _cinzaSubtexto,
                  height: 1.3)),
        ],
      ),
    );
  }
}

class _Divisor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 36, color: _borda);
  }
}

class _FeatureCard extends StatelessWidget {
  final String numero;
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.numero,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _azulClaro,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: _azul, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: _cinzaTexto)),
                const SizedBox(height: 3),
                Text(description,
                    style: const TextStyle(
                        fontSize: 12,
                        color: _cinzaSubtexto,
                        height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
