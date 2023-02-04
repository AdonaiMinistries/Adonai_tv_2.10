import 'package:adonai_tv/models/vime_video.dart';
import 'package:adonai_tv/widgets/live_button.dart';
import 'package:flutter/material.dart';

class RenderMainContent extends StatefulWidget {
  final List<Data> videos;
  const RenderMainContent({super.key, required this.videos});

  @override
  State<RenderMainContent> createState() => _RenderMainContentState();
}

class _RenderMainContentState extends State<RenderMainContent> {
  final List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.videos.length; i++) {
      _focusNodes.add(FocusNode());
    }
  }

  @override
  void dispose() {
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      /* This container is just to display background image. */
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/tv-bg.png'), fit: BoxFit.fill)),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            // ignore: avoid_unnecessary_containers
            child: Container(
              child: Column(
                children: <Widget>[
                  _renderLogo(context),
                  _renderSizedBox(context),
                  _renderLiveButton(),
                  _renderSermonText(context),
                ],
              ),
            ),
          ),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.8,
              // crossAxisSpacing: 10.0,
              // mainAxisSpacing: 10.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Focus(
                  focusNode: _focusNodes[index],
                  onFocusChange: (hasFocus) {
                    setState(() {});
                  },
                  child: _renderVideoGrid(context, index),
                );
              },
              childCount: widget.videos.length,
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector _renderVideoGrid(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(_focusNodes[index]);
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
                _focusNodes[index].hasFocus ? Colors.red : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * .22,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(widget
                      .videos[index].pictures.sizes[5].linkWithPlayButton),
                  fit: BoxFit.cover,
                ),
              ),
            ),
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
