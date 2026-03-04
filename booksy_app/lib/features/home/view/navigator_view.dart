import 'package:flutter/material.dart';
import 'home_user_screen.dart'; // Importamos la vista del dashboard

class NavigatorView extends StatefulWidget {
  const NavigatorView({super.key});

  @override
  State<NavigatorView> createState() => _NavigatorViewState();
}

class _NavigatorViewState extends State<NavigatorView> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeUserScreen(),
    const Center(child: Text('Pantalla del Catálogo')), // Próximamente
    const Center(child: Text('Pantalla de Eventos')),   // ¡Cambiado de Mapa a Eventos!
    const Center(child: Text('Pantalla del Perfil')),   // Próximamente
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF5D9CFF);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC), // Color de fondo global
      
      // IndexedStack mantiene el estado de las pantallas (no recarga los datos si cambias de pestaña)
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      
      // El botón flotante y la barra ahora le pertenecen al Navegador, no a la Home
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción central (ej: Subir libro)
        },
        backgroundColor: primaryBlue,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(Icons.home_outlined, 'Inicio', 0),
              _buildNavItem(Icons.menu_book_outlined, 'Catálogo', 1),
              const SizedBox(width: 48), // Hueco para el botón central
              // ¡ADIÓS MAPA, HOLA EVENTOS!
              _buildNavItem(Icons.event_available_outlined, 'Eventos', 2),
              _buildNavItem(Icons.person_outline, 'Perfil', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = _selectedIndex == index;
    final color = isActive ? const Color(0xFF5D9CFF) : Colors.grey;

    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(50),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: isActive ? FontWeight.bold : FontWeight.normal))
          ],
        ),
      ),
    );
  }
}