import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'main_shell.dart';

const _azul = Color(0xFF5B9BD5);
const _cinzaTexto = Color(0xFF2D3748);
const _cinzaSubtexto = Color(0xFF718096);

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _carregando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Logo
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: const Color(0xFFEBF3FB),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.account_balance_wallet,
                    color: _azul, size: 44),
              ),
              const SizedBox(height: 24),
              const Text(
                'Me Endividei',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _cinzaTexto),
              ),
              const SizedBox(height: 8),
              const Text(
                'Organize suas dividas e prepare documentos\npara resolver sua situacao financeira.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14, color: _cinzaSubtexto, height: 1.5),
              ),

              const Spacer(flex: 2),

              // Beneficios
              _beneficio(Icons.search_rounded,
                  'Diagnostico inteligente das suas dividas'),
              const SizedBox(height: 12),
              _beneficio(Icons.calculate_outlined,
                  'Calculo da sua capacidade de pagamento'),
              const SizedBox(height: 12),
              _beneficio(Icons.description_outlined,
                  'Geracao de documentos e relatorios em PDF'),
              const SizedBox(height: 12),
              _beneficio(Icons.history_rounded,
                  'Historico de todos os seus diagnosticos'),

              const Spacer(flex: 2),

              // Botao Google
              if (_carregando)
                const CircularProgressIndicator(color: _azul)
              else ...[
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _entrarComGoogle,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Google logo
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://www.google.com/favicon.ico'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Entrar com Google',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: _cinzaTexto),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _continuarSemConta,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _azul,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Continuar sem conta',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],

              const SizedBox(height: 16),
              const Text(
                'Seus dados ficam salvos apenas no seu dispositivo.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: _cinzaSubtexto),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _beneficio(IconData icon, String texto) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFFEBF3FB),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: _azul, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(texto,
              style: const TextStyle(fontSize: 13, color: _cinzaTexto)),
        ),
      ],
    );
  }

  Future<void> _entrarComGoogle() async {
    setState(() => _carregando = true);
    final ok = await AuthService.signInWithGoogle();
    if (!mounted) return;
    setState(() => _carregando = false);
    if (ok) {
      _irParaShell();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Nao foi possivel entrar com Google. Tente continuar sem conta.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _continuarSemConta() {
    AuthService.continueAsGuest();
    _irParaShell();
  }

  void _irParaShell() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }
}
