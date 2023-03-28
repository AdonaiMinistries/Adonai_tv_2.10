// @dart=2.9
import 'dart:convert';

// ignore: unused_import
import 'package:adonai_tv/models/app_config.dart';
import 'package:adonai_tv/models/vime_video.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import "package:flutter_bloc/flutter_bloc.dart";
// ignore: import_of_legacy_library_into_null_safe, depend_on_referenced_packages
import 'package:http/http.dart' as http;

import 'state.dart';
import 'event.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final http.Client httpClient;

  AppBloc({@required this.httpClient}) : super(null);

  AppState get initialState => Loading();

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is FetchAppConfigEvent) {
      yield Loading();
      try {
        AppConfig config = await _fetchAppConfig();
        yield AppConfigLoaded(appConfig: config);
      } catch (e) {
        yield FailedToLoad(errorMessage: e.toString());
      }
    }
    if (event is FetchVimeoEvent) {
      // yield Loading();
      String token = "";
      String next = "";
      if (state is VimeoVideoLoaded) {
        token = (state as VimeoVideoLoaded).token;
        next = event.url;
      } else {
        token = (state as AppConfigLoaded).appConfig.token;
      }

      try {
        // await _fetchVimeoTags(token);
        VimeoVideoData videoData = await _fetchVimeoVideos(token, next);
        if (state is VimeoVideoLoaded) {
          /* Append new videos from the existing videos. */
          videoData.data
              .insertAll(0, (state as VimeoVideoLoaded).videoData.data);
        }
        yield VimeoVideoLoaded(videoData: videoData, token: token);
      } catch (e) {
        yield FailedToLoad(errorMessage: e.toString());
      }
    }
  }

  Future<AppConfig> _fetchAppConfig() async {
    const String baseUrl = 'www.adonaichurch.in';

    Uri uri = Uri.https(baseUrl, '/app_config.json');
    final response = await httpClient.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      AppConfig config = AppConfig.fromJson(data);
      return config;
    } else {
      throw Exception('Failed to fetch app config');
    }
  }

  Future<VimeoVideoData> _fetchVimeoVideos(String token, String nextUri) async {
    const String baseUrl = 'https://api.vimeo.com';
    String userUri = '/users/140653357/projects/4496867/videos';

    if (nextUri.isNotEmpty) {
      userUri = nextUri;
    }

    final response = await http.get(Uri.parse(baseUrl + userUri), headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final videos = VimeoVideoData.fromJson(data);
      return videos;
    } else {
      throw Exception('Failed to fetch vimeo videos');
    }
  }

  Future _fetchVimeoTags(String token) async {
    const String baseUrl = 'https://api.vimeo.com';
    String userUri = '/tags';

    final response = await http.get(Uri.parse(baseUrl + userUri), headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch vimeo videos');
    }
  }
}
