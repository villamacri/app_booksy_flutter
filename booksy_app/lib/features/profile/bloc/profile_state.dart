import 'package:booksy_app/core/models/user/profile/user_profile.dart';

typedef User = UserProfile;

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;

  ProfileLoaded(this.user);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

class ProfileLogoutSuccess extends ProfileState {}
