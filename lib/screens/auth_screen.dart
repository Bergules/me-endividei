import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'main_shell.dart';

const _azul = Color(0xFF5B9BD5);
const _azulClaro = Color(0xFFEBF3FB);
const _cinzaTexto = Color(0xFF2D3748);
const _cinzaSubtexto = Color(0xFF718096);
const _borda = Color(0xFFE2E8F0);

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _carregandoGoogle = false;
  bool _mostrarInfoGoogle = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 48),

              // Logo
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: _azulClaro,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.account_balance_wallet,
                    color: _azul, size: 46),
              ),
              const SizedBox(height: 20),
              const Text(
                'Me Endividei',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: _cinzaTexto),
              ),
              const SizedBox(height: 6),
              const Text(
                'Organize suas dividas e prepare documentos\npara resolver sua situacao financeira.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14, color: _cinzaSubtexto, height: 1.5),
              ),

              const SizedBox(height: 36),

              // Beneficios
              _beneficio(Icons.search_rounded,
                  'Diagnostico inteligente das suas dividas'),
              const SizedBox(height: 10),
              _beneficio(Icons.calculate_outlined,
                  'Calculo da sua capacidade de pagamento'),
              const SizedBox(height: 10),
              _beneficio(Icons.description_outlined,
                  'Geracao de documentos e relatorios em PDF'),
              const SizedBox(height: 10),
              _beneficio(Icons.history_rounded,
                  'Historico de todos os seus diagnosticos'),

              const SizedBox(height: 36),

              // Botao principal — Continuar sem conta
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _continuarSemConta,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _azul,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Comecar agora — e gratis',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 14),

              // Divisor
              Row(
                children: [
                  Expanded(child: Container(height: 1, color: _borda)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('ou',
                        style: TextStyle(fontSize: 13, color: _cinzaSubtexto)),
                  ),
                  Expanded(child: Container(height: 1, color: _borda)),
                ],
              ),

              const SizedBox(height: 14),

              // Botao Google
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _carregandoGoogle ? null : _entrarComGoogle,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: _borda),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: Colors.white,
                  ),
                  child: _carregandoGoogle
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CircularProgressIndicator(strokeWidth: 2, color: _azul))
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _GoogleIcon(),
                            const SizedBox(width: 10),
                            const Text(
                              'Entrar com Google',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _cinzaTexto),
                            ),
                          ],
                        ),
                ),
              ),

              // Info sobre Google
              if (_mostrarInfoGoogle)
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFFCC02)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              color: Color(0xFFE6A817), size: 16),
                          SizedBox(width: 6),
                          Text('Login com Google em configuracao',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Color(0xFF856404))),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Use "Comecar agora" para acessar todas as funcionalidades gratuitamente. O login com Google estara disponivel em breve.',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF856404),
                            height: 1.4),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _continuarSemConta,
                        child: const Text(
                          'Continuar sem conta →',
                          style: TextStyle(
                              fontSize: 12,
                              color: _azul,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),
              const Text(
                'Seus dados ficam salvos apenas no seu dispositivo.\nNao coletamos suas informacoes.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: _cinzaSubtexto, height: 1.5),
              ),
              const SizedBox(height: 28),
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
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: _azulClaro,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: _azul, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(texto,
              style: const TextStyle(
                  fontSize: 13, color: _cinzaTexto, height: 1.3)),
        ),
      ],
    );
  }

  Future<void> _entrarComGoogle() async {
    setState(() { _carregandoGoogle = true; _mostrarInfoGoogle = false; });
    final ok = await AuthService.signInWithGoogle();
    if (!mounted) return;
    setState(() => _carregandoGoogle = false);
    if (ok) {
      _irParaShell();
    } else {
      setState(() => _mostrarInfoGoogle = true);
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

class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
      ),
      child: CustomPaint(painter: _GooglePainter()),
    );
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    const colors = [
      Color(0xFF4285F4),
      Color(0xFF34A853),
      Color(0xFFFBBC05),
      Color(0xFFEA4335),
    ];
    final paints = colors.map((c) => Paint()..color = c).toList();

    // Simplified G logo using colored circles
    canvas.drawArc(rect, -1.6, 3.14, false, paints[0]..style = PaintingStyle.stroke..strokeWidth = size.width * 0.28);
    canvas.drawArc(rect, 1.54, 1.6, false, paints[1]..style = PaintingStyle.stroke..strokeWidth = size.width * 0.28);
    canvas.drawArc(rect, 3.14, 0.8, false, paints[2]..style = PaintingStyle.stroke..strokeWidth = size.width * 0.28);
    canvas.drawArc(rect, 3.94, 0.84, false, paints[3]..style = PaintingStyle.stroke..strokeWidth = size.width * 0.28);
  }

  @override
  bool shouldRepaint(_) => false;
}
