import 'package:booksy_app/core/models/home/home_feed_response.dart';
import 'package:booksy_app/core/services/meetup_service.dart';
import 'package:booksy_app/features/events/bloc/meetup_event.dart';
import 'package:booksy_app/features/events/bloc/meetup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MeetupBloc extends Bloc<MeetupEvent, MeetupState> {
  final MeetupService _meetupService;

  MeetupBloc({required MeetupService meetupService})
    : _meetupService = meetupService,
      super(MeetupInitial()) {
    on<FetchMeetups>(_onFetchMeetups);
    on<JoinMeetup>(_onJoinMeetup);
  }

  Future<void> _onFetchMeetups(
    FetchMeetups event,
    Emitter<MeetupState> emit,
  ) async {
    emit(MeetupLoading());

    try {
      final meetups = await _meetupService.getMeetups();
      emit(MeetupLoaded(meetups));
    } catch (e) {
      emit(MeetupError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onJoinMeetup(
    JoinMeetup event,
    Emitter<MeetupState> emit,
  ) async {
    final currentState = state;
    if (currentState is! MeetupLoaded) {
      return;
    }

    Meetup? selectedMeetup;
    for (final meetup in currentState.meetups) {
      if (meetup.id == event.meetupId) {
        selectedMeetup = meetup;
        break;
      }
    }

    if (selectedMeetup == null) {
      emit(
        MeetupLoaded(
          currentState.meetups,
          actionErrorMessage: 'No se encontró el evento seleccionado.',
        ),
      );
      return;
    }

    if (selectedMeetup.isJoined) {
      emit(
        MeetupLoaded(
          currentState.meetups,
          actionMessage: 'Ya estabas apuntado a este evento.',
          lastJoinedCity: selectedMeetup.city,
        ),
      );
      return;
    }

    final optimisticMeetups = currentState.meetups
        .map(
          (meetup) => meetup.id == event.meetupId
              ? meetup.copyWith(isJoined: true)
              : meetup,
        )
        .toList();

    emit(MeetupLoaded(optimisticMeetups, joiningMeetupId: event.meetupId));

    try {
      await _meetupService.joinMeetup(event.meetupId);

      emit(
        MeetupLoaded(
          optimisticMeetups,
          joinSuccessMeetupId: event.meetupId,
          actionMessage: 'Te has apuntado al evento correctamente.',
          lastJoinedCity: selectedMeetup.city,
        ),
      );
    } catch (e) {
      emit(
        MeetupLoaded(
          currentState.meetups,
          actionErrorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }
}
