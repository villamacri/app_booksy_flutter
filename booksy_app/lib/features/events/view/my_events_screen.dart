import 'package:booksy_app/features/events/bloc/meetup_bloc.dart';
import 'package:booksy_app/features/events/bloc/meetup_event.dart';
import 'package:booksy_app/features/events/bloc/meetup_state.dart';
import 'package:booksy_app/core/view/connection_error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final meetupBloc = context.read<MeetupBloc>();
      final currentState = meetupBloc.state;

      if (currentState is! MeetupLoaded && currentState is! MeetupLoading) {
        meetupBloc.add(FetchMeetups());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        title: const Text(
          'Mis eventos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<MeetupBloc, MeetupState>(
        builder: (context, state) {
          if (state is MeetupLoading || state is MeetupInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MeetupError) {
            return ConnectionErrorView(
              onRetry: () {
                context.read<MeetupBloc>().add(FetchMeetups());
              },
            );
          }

          if (state is MeetupLoaded) {
            final joinedMeetups = state.meetups
                .where((meetup) => meetup.isJoined)
                .toList();

            if (joinedMeetups.isEmpty) {
              return const Center(
                child: Text('Todavía no te has apuntado a ningún evento.'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: joinedMeetups.length,
              itemBuilder: (context, index) {
                final meetup = joinedMeetups[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
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
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                meetup.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text(
                                'Apuntado',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                              color: Color(0xFF5D9CFF),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                meetup.city,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Color(0xFF5D9CFF),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                _formatDateTime(meetup.dateTime),
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (meetup.description != null &&
                            meetup.description!.trim().isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Text(
                            meetup.description!,
                            style: const TextStyle(
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return 'Fecha por confirmar';
    }

    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$day/$month/$year · $hour:$minute';
  }
}
