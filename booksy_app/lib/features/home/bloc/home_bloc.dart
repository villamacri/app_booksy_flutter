import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:booksy_app/core/services/home_service.dart';
import 'package:booksy_app/features/home/bloc/home_event.dart';
import 'package:booksy_app/features/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeService _homeService;

  HomeBloc({required HomeService homeService})
    : _homeService = homeService,
      super(HomeLoaded()) {
    on<FetchHomeData>(_onFetchHomeData);
  }

  Future<void> _onFetchHomeData(
    FetchHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    try {
      final latestBooks = await _homeService.getLatestBooks();
      final upcomingMeetups = await _homeService.getMeetups(city: event.city);
      final myAppointments = await _homeService.getUpcomingAppointments();
      final joinedMeetupIds = myAppointments
          .map((appointment) => appointment.meetup?.id ?? appointment.meetupId)
          .where((id) => id > 0)
          .toSet();
      final projectedMeetups = upcomingMeetups
          .map(
            (meetup) => meetup.copyWith(
              isJoined: meetup.isJoined || joinedMeetupIds.contains(meetup.id),
            ),
          )
          .toList();

      emit(
        HomeLoaded(
          latestBooks: latestBooks,
          upcomingMeetups: projectedMeetups,
          myAppointments: myAppointments,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
