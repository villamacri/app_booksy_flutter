import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Cabecera Azul
            _buildHeader(),
            
            const SizedBox(height: 20),
            
            // Contenido principal con padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  // Grid de tarjetas (Usuarios, Transacciones...)
                  _buildStatsGrid(),
                  
                  const SizedBox(height: 20),
                  
                  // Tarjeta Gráfico Ventas
                  _buildSectionCard(
                    title: "Ventas y Compras Mensuales",
                    subtitle: "Últimos 6 meses",
                    content: _buildSimpleChartPlaceholder(Icons.show_chart, Colors.blue),
                  ),

                  const SizedBox(height: 20),
                  
                  // Tarjeta Gráfico Libros
                  _buildSectionCard(
                    title: "Libros Más Intercambiados",
                    subtitle: "Top 5 del mes",
                    content: _buildSimpleChartPlaceholder(Icons.bar_chart, Colors.orange),
                  ),

                  const SizedBox(height: 20),
                  
                  // Lista de Actividad Reciente
                  _buildRecentActivity(),
                  
                  const SizedBox(height: 80), // Espacio para que el botón flotante no tape contenido
                ],
              ),
            ),
          ],
        ),
      ),
      
      // Botón flotante central
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF4C8EF8),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
      // Barra de navegación inferior
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, "Inicio", isSelected: true),
              _buildNavItem(Icons.bar_chart, "Reportes"),
              const SizedBox(width: 40), // Espacio central para el FAB
              _buildNavItem(Icons.people_outline, "Usuarios"),
              _buildNavItem(Icons.settings_outlined, "Ajustes"),
            ],
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para los items del menú inferior
  Widget _buildNavItem(IconData icon, String label, {bool isSelected = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isSelected ? const Color(0xFF4C8EF8) : Colors.grey,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isSelected ? const Color(0xFF4C8EF8) : Colors.grey,
          ),
        ),
      ],
    );
  }

  // Widget para la cabecera azul superior
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 30),
      decoration: const BoxDecoration(
        color: Color(0xFF4C8EF8),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.menu, color: Colors.white),
              Row(
                children: [
                  const Icon(Icons.notifications_outlined, color: Colors.white),
                  const SizedBox(width: 15),
                  const Icon(Icons.settings_outlined, color: Colors.white),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Dashboard",
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            "Resumen general de la plataforma",
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Grid de 2x2 para las estadísticas
  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.3,
      children: [
        _buildStatCard(Icons.people_outline, "12,543", "Usuarios", "+12.5%", Colors.blue),
        _buildStatCard(Icons.shopping_cart_outlined, "8,234", "Transacciones", "+8.2%", Colors.teal),
        _buildStatCard(Icons.book_outlined, "15,678", "Libros", "+5.4%", Colors.purple),
        _buildStatCard(Icons.calendar_today_outlined, "24", "Eventos", "-2.1%", Colors.orange),
      ],
    );
  }

  // Tarjeta individual de estadística
  Widget _buildStatCard(IconData icon, String value, String title, String percentage, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Text(
                percentage,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: percentage.startsWith('+') ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Estructura común para las tarjetas grandes (Gráficos, Listas...)
  Widget _buildSectionCard({required String title, required String subtitle, required Widget content}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 5),
          Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 20),
          content,
        ],
      ),
    );
  }

  // Placeholder simple visual para representar gráficos sin usar librerías complejas
  Widget _buildSimpleChartPlaceholder(IconData icon, Color color) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color.withOpacity(0.5)),
          const SizedBox(height: 8),
          Text(
            "Visualización de Gráfico",
            style: TextStyle(color: color.withOpacity(0.8), fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Lista de actividad reciente
  Widget _buildRecentActivity() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Actividad Reciente", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              TextButton(onPressed: () {}, child: const Text("Ver todo", style: TextStyle(fontSize: 12))),
            ],
          ),
          _buildActivityItem("Ana García", "Publicó un libro", "Hace 5 min", Colors.blue),
          const Divider(),
          _buildActivityItem("Carlos Ruiz", "Compró un libro", "Hace 12 min", Colors.green),
          const Divider(),
          _buildActivityItem("Marta Lopez", "Registró evento", "Hace 25 min", Colors.orange),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String user, String action, String time, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            radius: 15,
            child: Text(user[0], style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    children: [
                      TextSpan(text: user, style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: " $action", style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Text(time, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }
}
