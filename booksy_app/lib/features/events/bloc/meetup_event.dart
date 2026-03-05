abstract class MeetupEvent {}

class FetchMeetups extends MeetupEvent {}

class JoinMeetup extends MeetupEvent {
  final int meetupId;

  JoinMeetup(this.meetupId);
}
