// AppEvent.dart
abstract class AppEvent {}

class FetchAppConfigEvent extends AppEvent {}

class FetchVimeoEvent extends AppEvent {
  String token;
  FetchVimeoEvent({required this.token});
}
