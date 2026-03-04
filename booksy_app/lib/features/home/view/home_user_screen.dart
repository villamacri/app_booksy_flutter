import 'package:booksy_app/features/book/bloc/book_page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Importa tu BLoC de libros y sus estados (ajusta la ruta si los estados están en otro archivo)
import 'package:booksy_app/features/book/bloc/book_page_bloc.dart';

class HomeUserScreen extends StatelessWidget {
  const HomeUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF5D9CFF);
    final screenWidth = MediaQuery.sizeOf(context).width;

    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            height: 240,
            width: screenWidth,
            decoration: const BoxDecoration(
              color: primaryBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.menu, color: Colors.white),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.notifications_none, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Hola, Lector', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const Text('Tu centro de lectura e intercambios', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 30),

                  // ENLACES RÁPIDOS
                  Row(
                    children: [
                      Expanded(child: _buildActionCard('Catálogo', Icons.search, Colors.blue, () {})),
                      const SizedBox(width: 16),
                      Expanded(child: _buildActionCard('Historial', Icons.receipt_long, Colors.green, () {})),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildActionCard('Mis Eventos', Icons.event_available, Colors.orange, () {})),
                      const SizedBox(width: 16),
                      Expanded(child: _buildActionCard('Mis Libros', Icons.my_library_books, Colors.purple, () {})),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // --- ⚡ LA MAGIA DE LARAVEL: ÚLTIMOS LIBROS ---
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Últimos libros añadidos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                      Text('Ver catálogo', style: TextStyle(color: primaryBlue, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 180,
                    // AQUÍ CONECTAMOS LA VISTA CON EL BLOC
                    child: BlocBuilder<BookBloc, BookState>(
                      builder: (context, state) {
                        // 1. Si está cargando, mostramos un spinner
                        if (state is BookLoading) {
                          return const Center(child: CircularProgressIndicator(color: primaryBlue));
                        } 
                        // 2. Si falla el servidor, mostramos el error
                        else if (state is BookError) {
                          return Center(
                            child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.red)),
                          );
                        } 
                        // 3. ¡Éxito! Tenemos los datos de Laravel
                        else if (state is BookLoaded) {
                          final libros = state.books;

                          // Si la base de datos está vacía
                          if (libros.isEmpty) {
                            return const Center(
                              child: Text('Aún no hay libros. ¡Sé el primero en subir uno!', style: TextStyle(color: Colors.grey)),
                            );
                          }

                          // Pintamos la lista dinámica basada en la BD
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: libros.length,
                            itemBuilder: (context, index) {
                              final libro = libros[index];
                              // Inyectamos las variables de tu BookResponse (titulo y autor)
                              return _buildBookCard(libro.titulo, libro.autor);
                            },
                          );
                        }
                        
                        // Estado inicial vacío por si acaso
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  const SizedBox(height: 30),

                  // EVENTOS EN TU CIUDAD
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Quedadas en tu ciudad', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                      Text('Ver mapa', style: TextStyle(color: primaryBlue, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 140,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildAvailableEventCard('Cafetería La Cacharrería', 'Hoy, 18:00h', 'Sevilla'),
                        _buildAvailableEventCard('Librería Rayuela', 'Mañana, 17:30h', 'Sevilla'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // TUS PRÓXIMAS CITAS
                  Container(
                    padding: const EdgeInsets.all(20),
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tus próximas citas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 16),
                        _buildJoinedEventTile(Icons.check_circle, Colors.green, 'Cafetería La Cacharrería', 'Intercambio: "1984" - Hoy, 18:00h'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80), 
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildActionCard(String title, IconData icon, MaterialColor color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.shade50, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color.shade400, size: 24),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  // ¡He devuelto el _buildBookCard para que el listado funcione!
  Widget _buildBookCard(String title, String author) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: const BoxDecoration(
              color: Color(0xFFE2E8F0), 
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            // En un futuro, aquí cambiaremos el Icono por un Image.network(libro.imagenUrl)
            child: const Center(child: Icon(Icons.book, color: Colors.white, size: 40)),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(author, style: const TextStyle(color: Colors.grey, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAvailableEventCard(String place, String time, String city) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16, bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF5D9CFF).withValues(alpha: 0.3)),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.05), blurRadius: 5, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_on, color: Color(0xFF5D9CFF), size: 24),
          const SizedBox(height: 8),
          Text(place, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text('$time • $city', style: const TextStyle(color: Colors.grey, fontSize: 11)),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 28,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5D9CFF).withValues(alpha: 0.1),
                foregroundColor: const Color(0xFF5D9CFF),
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Apuntarse', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildJoinedEventTile(IconData icon, Color color, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}