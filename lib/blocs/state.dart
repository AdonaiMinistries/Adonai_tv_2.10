import 'package:adonai_tv/models/vime_video.dart';

import '../models/app_config.dart';

abstract class AppState {}

class Loading extends AppState {}

class AppConfigLoaded extends AppState {
  AppConfig appConfig;
  AppConfigLoaded({required this.appConfig});
}

class VimeoVideoLoaded extends AppState {
  final VimeoVideoData videoData;
  String token;
  VimeoVideoLoaded({required this.videoData, required this.token});
}

class FailedToLoad extends AppState {
  final String errorMessage;
  FailedToLoad({required this.errorMessage});
}

class FetchMore extends AppState {
  final VimeoVideoData videoData;
  FetchMore({required this.videoData});
}
