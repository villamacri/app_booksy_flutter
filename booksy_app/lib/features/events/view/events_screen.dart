import 'package:booksy_app/features/events/bloc/meetup_bloc.dart';
import 'package:booksy_app/features/events/bloc/meetup_event.dart';
import 'package:booksy_app/features/events/bloc/meetup_state.dart';
import 'package:booksy_app/features/home/bloc/home_bloc.dart';
import 'package:booksy_app/features/home/bloc/home_event.dart';
import 'package:booksy_app/features/profile/bloc/profile_bloc.dart';
import 'package:booksy_app/features/profile/bloc/profile_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        title: const Text(
          'Eventos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocConsumer<MeetupBloc, MeetupState>(
        listener: (context, state) {
          if (state is! MeetupLoaded) {
            return;
          }

          if (state.joinSuccessMeetupId != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('¡Te has apuntado al evento!'),
                  backgroundColor: Colors.green,
                ),
              );

            context.read<HomeBloc>().add(FetchHomeData());
            context.read<ProfileBloc>().add(FetchProfileData());
          } else if (state.actionMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.actionMessage!)));
          }

          if (state.actionErrorMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.actionErrorMessage!),
                  backgroundColor: Colors.redAccent,
                ),
              );
          }
        },
        builder: (context, state) {
          if (state is MeetupLoading || state is MeetupInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MeetupError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                textAlign: TextAlign.center,
              ),
            );
          }

          if (state is MeetupLoaded) {
            if (state.meetups.isEmpty) {
              return const Center(
                child: Text('No hay eventos disponibles en este momento.'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: state.meetups.length,
              itemBuilder: (context, index) {
                final meetup = state.meetups[index];
                final isJoining =
                    state.joiningMeetupId == meetup.id && !meetup.isJoined;

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
                            const SizedBox(width: 8),
                            if (meetup.isJoined)
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
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 38,
                          child: ElevatedButton(
                            onPressed: meetup.isJoined || isJoining
                                ? null
                                : () {
                                    context.read<MeetupBloc>().add(
                                      JoinMeetup(meetup.id),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: meetup.isJoined
                                  ? Colors.green.withValues(alpha: 0.15)
                                  : const Color(0xFF5D9CFF),
                              foregroundColor: meetup.isJoined
                                  ? Colors.green
                                  : Colors.white,
                              disabledBackgroundColor: meetup.isJoined
                                  ? Colors.green.withValues(alpha: 0.15)
                                  : const Color(
                                      0xFF5D9CFF,
                                    ).withValues(alpha: 0.6),
                              disabledForegroundColor: meetup.isJoined
                                  ? Colors.green
                                  : Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: isJoining
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    meetup.isJoined
                                        ? 'Ya apuntado'
                                        : 'Apuntarme',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
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
