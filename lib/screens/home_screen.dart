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
    String token = "";
    return BlocBuilder<AppBloc, AppState>(builder: ((context, state) {
      if (state is Loading) {
        BlocProvider.of<AppBloc>(context).add(FetchAppConfigEvent());
        return const Center(child: CircularProgressIndicator());
      } else if (state is AppConfigLoaded) {
        token = state.appConfig.token;
        BlocProvider.of<AppBloc>(context).add(FetchVimeoEvent(url: ""));
        return const Text("Display list");
      } else if (state is VimeoVideoLoaded) {
        return RenderMainContent(videos: state.videoData.data, token: token);
        // return ListView.builder(
        //   itemCount: state.videoData.data.length,
        //   itemBuilder: (BuildContext context, int index) {
        //     if ((index == state.videoData.data.length - 1) &&
        //         state.videoData.paging.next != null) {
        //       /* Fetch more videos. */
        //       BlocProvider.of<AppBloc>(context)
        //           .add(FetchVimeoEvent(url: state.videoData.paging.next));
        //     }
        //     return Text(
        //       'Title - ${state.videoData.data[index].name}',
        //       style: const TextStyle(color: Colors.white),
        //     );
        //   },
        // );
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
