import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import 'auth_screen.dart';

const _azul = Color(0xFF5B9BD5);
const _azulClaro = Color(0xFFEBF3FB);
const _cinzaTexto = Color(0xFF2D3748);
const _cinzaSubtexto = Color(0xFF718096);
const _borda = Color(0xFFE2E8F0);

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nome = AuthService.displayName;
    final email = AuthService.email;
    final foto = AuthService.photoUrl;
    final isGuest = AuthService.isGuest;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: _borda),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar e nome
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _borda),
              ),
              child: Column(
                children: [
                  foto != null
                      ? CircleAvatar(
                          radius: 36,
                          backgroundImage: NetworkImage(foto),
                        )
                      : CircleAvatar(
                          radius: 36,
                          backgroundColor: _azulClaro,
                          child: Text(
                            nome.isNotEmpty ? nome[0].toUpperCase() : 'U',
                            style: const TextStyle(
                                color: _azul,
                                fontSize: 28,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                  const SizedBox(height: 12),
                  Text(nome,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _cinzaTexto)),
                  if (email.isNotEmpty)
                    Text(email,
                        style: const TextStyle(
                            fontSize: 13, color: _cinzaSubtexto)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isGuest
                          ? Colors.grey.shade100
                          : _azulClaro,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isGuest ? 'Visitante' : 'Conta Google',
                      style: TextStyle(
                          fontSize: 12,
                          color: isGuest ? _cinzaSubtexto : _azul,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Opcoes
            _Secao(titulo: 'Conta', itens: [
              if (isGuest)
                _Item(
                  icon: Icons.login_rounded,
                  label: 'Entrar com Google',
                  color: _azul,
                  onTap: () async {
                    final ok = await AuthService.signInWithGoogle();
                    if (ok && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Login realizado!')),
                      );
                    }
                  },
                ),
              _Item(
                icon: Icons.history_rounded,
                label: 'Historico de diagnosticos',
                onTap: () {},
              ),
              _Item(
                icon: Icons.delete_outline,
                label: 'Limpar todos os dados',
                color: const Color(0xFFE53E3E),
                onTap: () => _confirmarLimpeza(context),
              ),
            ]),

            const SizedBox(height: 16),

            _Secao(titulo: 'Sobre o app', itens: [
              _Item(
                icon: Icons.info_outline,
                label: 'O que e o Me Endividei?',
                onTap: () => _mostrarSobre(context),
              ),
              _Item(
                icon: Icons.shield_outlined,
                label: 'Privacidade e dados',
                onTap: () => _mostrarPrivacidade(context),
              ),
              _Item(
                icon: Icons.star_outline_rounded,
                label: 'Versao 1.0.0',
                onTap: null,
              ),
            ]),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _sair(context),
                icon: const Icon(Icons.logout_rounded,
                    color: Color(0xFFE53E3E), size: 18),
                label: const Text('Sair',
                    style: TextStyle(
                        color: Color(0xFFE53E3E), fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),

            const SizedBox(height: 8),
            const Text(
              'Me Endividei nao e um servico juridico.\nNao substitui advogado, contador ou Defensoria Publica.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: _cinzaSubtexto, height: 1.4),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _sair(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Sair'),
        content: const Text('Deseja sair da sua conta?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              await AuthService.signOut();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const AuthScreen()),
                  (_) => false,
                );
              }
            },
            child: const Text('Sair',
                style: TextStyle(color: Color(0xFFE53E3E))),
          ),
        ],
      ),
    );
  }

  void _confirmarLimpeza(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Limpar dados'),
        content: const Text(
            'Todos os seus diagnosticos serao removidos. Esta acao nao pode ser desfeita.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              await StorageService.limparCasos();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Dados removidos.')),
                );
              }
            },
            child: const Text('Limpar',
                style: TextStyle(color: Color(0xFFE53E3E))),
          ),
        ],
      ),
    );
  }

  void _mostrarSobre(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Sobre o Me Endividei'),
        content: const Text(
          'O Me Endividei e um assistente de organizacao de dividas e preparacao de documentos para consumidores, contribuintes, MEIs e pessoas fisicas.\n\nEle nao substitui advogado, contador ou Defensoria Publica.',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Entendi')),
        ],
      ),
    );
  }

  void _mostrarPrivacidade(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Privacidade'),
        content: const Text(
          'Seus dados ficam armazenados apenas no seu dispositivo.\n\nNao coletamos, vendemos ou compartilhamos suas informacoes financeiras com terceiros.\n\nEm conformidade com a LGPD (Lei 13.709/2018).',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Entendi')),
        ],
      ),
    );
  }
}

class _Secao extends StatelessWidget {
  final String titulo;
  final List<Widget> itens;

  const _Secao({required this.titulo, required this.itens});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _cinzaSubtexto)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _borda),
          ),
          child: Column(
            children: List.generate(itens.length, (i) {
              final isLast = i == itens.length - 1;
              return Column(
                children: [
                  itens[i],
                  if (!isLast)
                    Container(
                        height: 1,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        color: _borda),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _Item extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback? onTap;

  const _Item({required this.icon, required this.label, this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cor = color ?? _cinzaTexto;
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: cor, size: 20),
      title: Text(label, style: TextStyle(fontSize: 14, color: cor)),
      trailing: onTap != null
          ? const Icon(Icons.chevron_right, color: Color(0xFFCBD5E0), size: 18)
          : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    );
  }
}
