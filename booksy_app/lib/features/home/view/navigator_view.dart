import 'package:booksy_app/core/services/book_service.dart';
import 'package:booksy_app/core/services/meetup_service.dart';
import 'package:booksy_app/core/services/auth_service.dart';
import 'package:booksy_app/core/services/user_service.dart';
import 'package:booksy_app/features/book/bloc/add_book_bloc.dart';
import 'package:booksy_app/features/book/view/add_book_screen.dart';
import 'package:booksy_app/features/catalog/bloc/catalog_bloc.dart';
import 'package:booksy_app/features/catalog/bloc/catalog_event.dart';
import 'package:booksy_app/features/catalog/view/catalog_screen.dart';
import 'package:booksy_app/features/home/bloc/home_bloc.dart';
import 'package:booksy_app/features/home/bloc/home_event.dart';
import 'package:booksy_app/features/events/bloc/meetup_bloc.dart';
import 'package:booksy_app/features/events/bloc/meetup_event.dart';
import 'package:booksy_app/features/events/view/events_screen.dart';
import 'package:booksy_app/features/profile/bloc/profile_bloc.dart';
import 'package:booksy_app/features/profile/bloc/profile_event.dart';
import 'package:booksy_app/features/profile/view/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_user_screen.dart'; // Importamos la vista del dashboard

class NavigatorView extends StatefulWidget {
  const NavigatorView({super.key});

  @override
  State<NavigatorView> createState() => _NavigatorViewState();
}

class _NavigatorViewState extends State<NavigatorView> {
  int _selectedIndex = 0;

  late final CatalogBloc _catalogBloc;
  late final MeetupBloc _meetupBloc;
  late final ProfileBloc _profileBloc;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _catalogBloc = CatalogBloc(bookService: BookService());
    _meetupBloc = MeetupBloc(meetupService: MeetupService())
      ..add(FetchMeetups());
    _profileBloc = ProfileBloc(
      authService: AuthService(),
      userService: UserService(),
    )..add(FetchProfileData());

    _screens = [
      const HomeUserScreen(),
      const CatalogScreen(),
      const EventsScreen(),
      const ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      _catalogBloc.add(FetchCatalog());
    }

    if (index == 3) {
      _profileBloc.add(FetchProfileData());
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _catalogBloc.close();
    _meetupBloc.close();
    _profileBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF5D9CFF);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<HomeBloc>()),
        BlocProvider.value(value: _catalogBloc),
        BlocProvider.value(value: _meetupBloc),
        BlocProvider.value(value: _profileBloc),
      ],
      child: Builder(
        builder: (innerContext) {
          return PopScope(
            canPop: _selectedIndex == 0,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) {
                return;
              }

              if (_selectedIndex != 0) {
                setState(() {
                  _selectedIndex = 0;
                });
              }
            },
            child: Scaffold(
              backgroundColor: const Color(0xFFF4F7FC), // Color de fondo global
              // IndexedStack mantiene el estado de las pantallas (no recarga los datos si cambias de pestaña)
              body: IndexedStack(index: _selectedIndex, children: _screens),

              // El botón flotante y la barra ahora le pertenecen al Navegador, no a la Home
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    innerContext,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) => AddBookBloc(bookService: BookService()),
                        child: const AddBookScreen(),
                      ),
                    ),
                  );

                  if (!innerContext.mounted) {
                    return;
                  }

                  if (result == true) {
                    innerContext.read<HomeBloc>().add(
                      FetchHomeData(city: 'Sevilla'),
                    );
                    innerContext.read<CatalogBloc>().add(FetchCatalog());
                    innerContext.read<ProfileBloc>().add(FetchProfileData());
                  }
                },
                backgroundColor: primaryBlue,
                elevation: 4,
                shape: const CircleBorder(),
                child: const Icon(Icons.add, color: Colors.white, size: 28),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
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
                      _buildNavItem(
                        Icons.event_available_outlined,
                        'Eventos',
                        2,
                      ),
                      _buildNavItem(Icons.person_outline, 'Perfil', 3),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
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
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: color,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
