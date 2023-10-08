import 'package:adonai_tv/blocs/bloc.dart';
import 'package:adonai_tv/blocs/event.dart';
import 'package:adonai_tv/blocs/state.dart';
import 'package:adonai_tv/models/app_config.dart';
import 'package:adonai_tv/widgets/main_content.dart';
import 'package:adonai_tv/widgets/update_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:adonai_tv/constants.dart' as constant;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late AppConfig appConfig;
    return BlocBuilder<AppBloc, AppState>(builder: ((context, state) {
      if (state is Loading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is AppConfigLoaded) {
        appConfig = state.appConfig;

        if (constant.appVersion < appConfig.minVersion) {
          // Current app version is lower, need to update the app.
          return const RenderUpdateError();
        }

        BlocProvider.of<AppBloc>(context).add(FetchVimeoEvent(url: ""));
        return Container();
      } else if (state is VimeoVideoLoaded) {
        return RenderMainContent(
            videos: state.videoData.data, appConfig: appConfig);
      } else if (state is FailedToLoad) {
        return Center(
            child: _renderError(
                'assets/error.png', MediaQuery.of(context).size.height * .90));
      }
      return Container();
    }));
  }

  Widget _renderError(String errorImage, double height) {
    return Container(
        child: Stack(
      children: [
        Image.asset(
          errorImage,
          height: height,
        )
      ],
    ));
  }
}
