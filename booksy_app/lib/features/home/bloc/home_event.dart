abstract class HomeEvent {}

class FetchHomeData extends HomeEvent {
  final String? city;

  FetchHomeData({this.city});
}
