import 'package:flutter/material.dart';
import 'inicio_screen.dart';
import 'diagnostico_screen.dart';
import 'meus_casos_screen.dart';
import 'perfil_screen.dart';
import '../models/caso_model.dart';

const _azul = Color(0xFF5B9BD5);

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  void _irParaDiagnostico() {
    setState(() => _index = 1);
  }

  @override
  Widget build(BuildContext context) {
    final telas = [
      InicioScreen(onNovoDiagnostico: _irParaDiagnostico),
      DiagnosticoScreen(
        caso: CasoModel(),
        onConcluido: () => setState(() => _index = 2),
      ),
      const MeusCasosScreen(),
      const PerfilScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: telas),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) {
          if (i == 1) {
            // Sempre cria novo diagnostico
            setState(() => _index = 1);
          } else {
            setState(() => _index = i);
          }
        },
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shadowColor: const Color(0x1A000000),
        elevation: 8,
        indicatorColor: const Color(0xFFEBF3FB),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded, color: _azul),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle_rounded, color: _azul),
            label: 'Diagnostico',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder_rounded, color: _azul),
            label: 'Meus Casos',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person_rounded, color: _azul),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
