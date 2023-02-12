import 'package:adonai_tv/blocs/bloc.dart';
import 'package:adonai_tv/blocs/event.dart';
import 'package:adonai_tv/blocs/state.dart';
import 'package:adonai_tv/models/vime_video.dart';
import 'package:adonai_tv/widgets/live_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'video_grid.dart';

class RenderMainContent extends StatefulWidget {
  final List<Data> videos;
  final String token;
  const RenderMainContent(
      {super.key, required this.videos, required this.token});

  @override
  State<RenderMainContent> createState() => _RenderMainContentState();
}

class _RenderMainContentState extends State<RenderMainContent> {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AppBloc>(context);
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/tv-bg.png'), fit: BoxFit.fill)),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _renderLogo(context),
            _renderSizedBox(context),
            _renderLiveButton(),
            _renderSermonText(context),
            SizedBox(
                height: MediaQuery.of(context).size.height,
                child: VideoGrid(
                  videos: widget.videos,
                  renderMore: (void v) {
                    bloc.add(FetchVimeoEvent(
                        url: (bloc.state as VimeoVideoLoaded)
                            .videoData
                            .paging
                            .next));
                  },
                )),
          ],
        ),
      ),
    );
  }

  SizedBox _renderSizedBox(BuildContext context) =>
      SizedBox(height: MediaQuery.of(context).size.height * .18);

  LiveButton _renderLiveButton() => const LiveButton();

  Widget _renderSermonText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * .01, 0,
          MediaQuery.of(context).size.width * .01, 0),
      child: Stack(
        children: [
          const Text("SERMONS",
              style: TextStyle(color: Colors.white, fontSize: 20)),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * .019,
                left: MediaQuery.of(context).size.width * .12),
            child: Container(
              height: 1,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container _renderLogo(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: Image.asset('assets/white-logo.png',
          height: MediaQuery.of(context).size.height * .20),
    );
  }
}
