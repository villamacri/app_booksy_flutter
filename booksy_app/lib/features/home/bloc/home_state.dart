import 'package:booksy_app/core/models/home/home_feed_response.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Book> latestBooks;
  final List<Meetup> upcomingMeetups;
  final List<MeetupAttendance> myAppointments;

  HomeLoaded({
    List<Book>? latestBooks,
    List<Meetup>? upcomingMeetups,
    List<MeetupAttendance>? myAppointments,
  }) : latestBooks = latestBooks ?? const [],
       upcomingMeetups = upcomingMeetups ?? const [],
       myAppointments = myAppointments ?? const [];
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
