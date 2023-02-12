// AppEvent.dart
abstract class AppEvent {}

class FetchAppConfigEvent extends AppEvent {}

class FetchVimeoEvent extends AppEvent {
  String url;
  FetchVimeoEvent({required this.url});
}
