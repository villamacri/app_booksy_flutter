import 'package:booksy_app/core/interfaces/auth_interface.dart';
import 'package:booksy_app/core/services/user_service.dart';
import 'package:booksy_app/features/profile/bloc/profile_event.dart';
import 'package:booksy_app/features/profile/bloc/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final IAuthService _authService;
  final UserService _userService;

  ProfileBloc({
    required IAuthService authService,
    required UserService userService,
  }) : _authService = authService,
       _userService = userService,
       super(ProfileInitial()) {
    on<FetchProfile>(_onFetchProfile);
    on<FetchProfileData>(_onFetchProfileData);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onFetchProfile(
    FetchProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final user = await _authService.getUserProfile();
      final stats = await _userService.getProfileStats();

      emit(
        ProfileLoaded(
          user.copyWith(
            booksCount: stats.booksCount,
            eventsCount: stats.eventsCount,
            exchangesCount: stats.exchangesCount,
          ),
        ),
      );
    } catch (e) {
      emit(ProfileError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onFetchProfileData(
    FetchProfileData event,
    Emitter<ProfileState> emit,
  ) {
    return _onFetchProfile(FetchProfile(), emit);
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      await _authService.logout();
      emit(ProfileLogoutSuccess());
    } catch (e) {
      emit(ProfileError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
