import 'package:booksy_app/core/models/home/home_feed_response.dart';

abstract class MeetupState {}

class MeetupInitial extends MeetupState {}

class MeetupLoading extends MeetupState {}

class MeetupLoaded extends MeetupState {
  final List<Meetup> meetups;
  final int? joiningMeetupId;
  final int? joinSuccessMeetupId;
  final String? actionMessage;
  final String? actionErrorMessage;
  final String? lastJoinedCity;

  MeetupLoaded(
    this.meetups, {
    this.joiningMeetupId,
    this.joinSuccessMeetupId,
    this.actionMessage,
    this.actionErrorMessage,
    this.lastJoinedCity,
  });
}

class MeetupError extends MeetupState {
  final String message;

  MeetupError(this.message);
}
