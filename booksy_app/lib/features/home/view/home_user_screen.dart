import 'package:booksy_app/features/home/bloc/home_bloc.dart';
import 'package:booksy_app/features/home/bloc/home_event.dart';
import 'package:booksy_app/features/home/bloc/home_state.dart';
import 'package:booksy_app/features/profile/bloc/profile_bloc.dart';
import 'package:booksy_app/features/profile/bloc/profile_state.dart';
import 'package:booksy_app/features/book/view/book_detail_screen.dart';
import 'package:booksy_app/core/view/connection_error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeUserScreen extends StatefulWidget {
  const HomeUserScreen({super.key});

  @override
  State<HomeUserScreen> createState() => _HomeUserScreenState();
}

class _HomeUserScreenState extends State<HomeUserScreen> {
  String _selectedCity = 'Sevilla';
  static const List<String> _cities = [
    'Sevilla',
    'Madrid',
    'Barcelona',
    'Valencia',
  ];

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF5D9CFF);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final profileState = context.watch<ProfileBloc>().state;
    final userName = profileState is ProfileLoaded
        ? profileState.user.name.trim()
        : 'Usuario';
    final safeUserName = userName.isEmpty ? 'Usuario' : userName;

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
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return SizedBox(
                      height: MediaQuery.sizeOf(context).height,
                      child: const Center(
                        child: CircularProgressIndicator(color: primaryBlue),
                      ),
                    );
                  }

                  if (state is HomeError) {
                    return SizedBox(
                      height: MediaQuery.sizeOf(context).height,
                      child: ConnectionErrorView(
                        onRetry: () {
                          context.read<HomeBloc>().add(
                            FetchHomeData(city: _selectedCity),
                          );
                        },
                      ),
                    );
                  }

                  if (state is HomeLoaded) {
                    final latestBooks = state.latestBooks;
                    final upcomingMeetups = state.upcomingMeetups;
                    final myAppointments = state.myAppointments;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.menu,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.notifications_none,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Hola, $safeUserName',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Tu centro de lectura e intercambios',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedCity,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                            dropdownColor: primaryBlue,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            onChanged: (newValue) {
                              if (newValue == null) {
                                return;
                              }

                              setState(() {
                                _selectedCity = newValue;
                              });

                              context.read<HomeBloc>().add(
                                FetchHomeData(city: newValue),
                              );
                            },
                            items: _cities
                                .map(
                                  (city) => DropdownMenuItem<String>(
                                    value: city,
                                    child: Text(
                                      city,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: 16),

                        const Text(
                          'Últimos libros añadidos',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 180,
                          child: latestBooks.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Aún no hay libros. ¡Sé el primero en subir uno!',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: latestBooks.length,
                                  itemBuilder: (context, index) {
                                    final book = latestBooks[index];
                                    return _buildBookCard(book);
                                  },
                                ),
                        ),
                        const SizedBox(height: 30),

                        const Text(
                          'Quedadas en tu ciudad',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 201,
                          child: upcomingMeetups.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No hay quedadas próximas en tu ciudad.',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: upcomingMeetups.length,
                                  itemBuilder: (context, index) {
                                    final meetup = upcomingMeetups[index];
                                    return _buildAvailableEventCard(
                                      meetup.title,
                                      meetup.dateTime.toString(),
                                      meetup.city,
                                      meetup.isJoined,
                                    );
                                  },
                                ),
                        ),
                        const SizedBox(height: 30),

                        Container(
                          padding: const EdgeInsets.all(20),
                          width: screenWidth,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tus próximas citas',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 16),
                              myAppointments.isEmpty
                                  ? const Text(
                                      'No tienes citas confirmadas próximas.',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: myAppointments.length,
                                      itemBuilder: (context, index) {
                                        final appointment =
                                            myAppointments[index];
                                        final meetup = appointment.meetup;

                                        final title =
                                            meetup?.title ??
                                            'Evento sin nombre';

                                        final subtitle =
                                            'Estado: ${appointment.status}';

                                        return _buildJoinedEventTile(
                                          Icons.check_circle,
                                          Colors.green,
                                          title,
                                          subtitle,
                                        );
                                      },
                                    ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 80),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  // ¡He devuelto el _buildBookCard para que el listado funcione!
  Widget _buildBookCard(Book book) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BookDetailScreen(book: book)),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
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
              child: const Center(
                child: Icon(Icons.book, color: Colors.white, size: 40),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.titulo,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.autor,
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableEventCard(
    String place,
    String time,
    String city,
    bool isJoined,
  ) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16, bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF5D9CFF).withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.location_on, color: Color(0xFF5D9CFF), size: 24),
          const SizedBox(height: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '$time • $city',
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 28,
            decoration: BoxDecoration(
              color: isJoined
                  ? Colors.green.withValues(alpha: 0.12)
                  : const Color(0xFF5D9CFF).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              isJoined ? 'Apuntado' : 'Disponible',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isJoined ? Colors.green : const Color(0xFF5D9CFF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJoinedEventTile(
    IconData icon,
    Color color,
    String title,
    String subtitle,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
