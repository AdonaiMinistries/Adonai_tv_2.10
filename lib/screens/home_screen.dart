import 'package:adonai_tv/blocs/bloc.dart';
import 'package:adonai_tv/blocs/event.dart';
import 'package:adonai_tv/blocs/state.dart';
import 'package:adonai_tv/widgets/main_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(builder: ((context, state) {
      if (state is Loading) {
        BlocProvider.of<AppBloc>(context).add(FetchAppConfigEvent());
        return const Center(child: CircularProgressIndicator());
      } else if (state is AppConfigLoaded) {
        BlocProvider.of<AppBloc>(context)
            .add(FetchVimeoEvent(token: state.appConfig.token));
        return const Text("Display list");
      } else if (state is VimeoVideoLoaded) {
        return RenderMainContent(videos: state.videoData.data);
      } else if (state is FailedToLoad) {
        return Center(
          child: Container(
              child: Stack(
            children: [
              Text(state.errorMessage),
              Image.asset(
                'assets/error.png',
                height: MediaQuery.of(context).size.height * .90,
              )
            ],
          )),
        );
      }
      return Container();
    }));
  }
}
