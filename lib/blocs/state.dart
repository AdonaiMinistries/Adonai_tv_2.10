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
  VimeoVideoLoaded({required this.videoData});
}

class FailedToLoad extends AppState {
  final String errorMessage;
  FailedToLoad({required this.errorMessage});
}

class FetchMore extends AppState {
  final List<String> data;
  FetchMore({required this.data});
}
