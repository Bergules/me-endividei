import 'package:flutter/material.dart';
import '../models/caso_model.dart';
import 'diagnostico_screen.dart';

const _azul = Color(0xFF5B9BD5);
const _azulClaro = Color(0xFFEBF3FB);
const _cinzaTexto = Color(0xFF2D3748);
const _cinzaSubtexto = Color(0xFF718096);
const _borda = Color(0xFFE2E8F0);

const List<String> _estados = [
  'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO',
  'MA', 'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI',
  'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO',
];

class CadastroScreen extends StatefulWidget {
  final CasoModel caso;

  const CadastroScreen({super.key, required this.caso});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  String? _estadoSelecionado;
  String? _perfilSelecionado;
  bool _tentouContinuar = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Seus dados'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: _borda),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Para comecar, me conta um pouco sobre voce',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _cinzaTexto),
              ),
              const SizedBox(height: 6),
              const Text(
                'Essas informacoes ajudam a personalizar seu diagnostico.',
                style: TextStyle(color: _cinzaSubtexto, fontSize: 14),
              ),
              const SizedBox(height: 28),

              TextFormField(
                controller: _nomeController,
                style: const TextStyle(color: _cinzaTexto),
                decoration: const InputDecoration(
                  labelText: 'Nome completo',
                  prefixIcon: Icon(Icons.person_outline, color: _azul),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe seu nome' : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: _cinzaTexto),
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email_outlined, color: _azul),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe seu e-mail' : null,
              ),
              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                value: _estadoSelecionado,
                style: const TextStyle(color: _cinzaTexto, fontSize: 14),
                dropdownColor: Colors.white,
                decoration: const InputDecoration(
                  labelText: 'Estado (UF)',
                  prefixIcon: Icon(Icons.location_on_outlined, color: _azul),
                ),
                items: _estados
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _estadoSelecionado = v),
                validator: (v) => v == null ? 'Selecione seu estado' : null,
              ),

              const SizedBox(height: 28),

              const Text(
                'Qual e o seu perfil?',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: _cinzaTexto),
              ),
              const SizedBox(height: 12),

              _PerfilCard(
                label: 'Pessoa Fisica',
                subtitle: 'Consumidor com dividas pessoais',
                icon: Icons.person,
                selected: _perfilSelecionado == 'PF',
                onTap: () => setState(() => _perfilSelecionado = 'PF'),
              ),
              _PerfilCard(
                label: 'MEI',
                subtitle: 'Microempreendedor Individual',
                icon: Icons.store_outlined,
                selected: _perfilSelecionado == 'MEI',
                onTap: () => setState(() => _perfilSelecionado = 'MEI'),
              ),
              _PerfilCard(
                label: 'Autonomo',
                subtitle: 'Trabalhador autonomo ou freelancer',
                icon: Icons.work_outline,
                selected: _perfilSelecionado == 'Autonomo',
                onTap: () => setState(() => _perfilSelecionado = 'Autonomo'),
              ),

              if (_tentouContinuar && _perfilSelecionado == null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4),
                  child: Text(
                    'Selecione seu perfil',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12),
                  ),
                ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _continuar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _azul,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Continuar',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _continuar() {
    setState(() => _tentouContinuar = true);
    if (_formKey.currentState!.validate() && _perfilSelecionado != null) {
      widget.caso.nome = _nomeController.text.trim();
      widget.caso.email = _emailController.text.trim();
      widget.caso.estado = _estadoSelecionado!;
      widget.caso.perfil = _perfilSelecionado!;

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => DiagnosticoScreen(caso: widget.caso)),
      );
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}

class _PerfilCard extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _PerfilCard({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
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
                color: selected ? _azul.withValues(alpha: 0.15) : const Color(0xFFF5F7FA),
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
                  Text(label,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: selected ? _azul : _cinzaTexto,
                          fontSize: 14)),
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
