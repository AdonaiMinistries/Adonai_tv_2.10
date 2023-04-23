// AppEvent.dart
abstract class AppEvent {}

class FetchAppConfigEvent extends AppEvent {}

class FetchVimeoEvent extends AppEvent {
  String url;
  FetchVimeoEvent({required this.url});
}

class FetchVideoConfigEvent extends AppEvent {
  String id;
  String token;
  FetchVideoConfigEvent({required this.id, required this.token});
}
