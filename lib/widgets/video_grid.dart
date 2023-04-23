import 'package:adonai_tv/models/app_config.dart';
import 'package:adonai_tv/models/vime_video.dart';
import 'package:adonai_tv/screens/intermediate_screen.dart';
import 'package:adonai_tv/screens/video_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';

class VideoTile extends StatefulWidget {
  final int index;
  final ValueChanged<int> onFocus;
  final Data video;
  final String token;

  const VideoTile(
      {super.key,
      required this.index,
      required this.onFocus,
      required this.video,
      required this.token});

  @override
  _VideoTileState createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  bool _isInFocus = false;
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isInFocus = hasFocus;
          if (hasFocus) {
            widget.onFocus(widget.index);
            _focusNode.requestFocus();
          }
        });
      },
      child: RawKeyboardListener(
        focusNode: _focusNode,
        onKey: _handleKeyPress,
        child: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(
              color: _isInFocus ? Colors.red : Colors.transparent,
              width: 3.0,
            ),
          ),
          child: CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl: widget.video.pictures.sizes[5].linkWithPlayButton,
            errorWidget: (context, url, error) => const Icon(Icons.error),
            placeholder: (context, url) => Container(
              decoration: BoxDecoration(color: Colors.grey[700]),
            ),
          ),
        ),
      ),
    );
  }

  _handleKeyPress(RawKeyEvent event) {
    if ((event.physicalKey == PhysicalKeyboardKey.select) ||
        (event.logicalKey == LogicalKeyboardKey.select)) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => IntermediateScreen(
                    token: widget.token,
                    id: _extractIdFromUri(widget.video.uri),
                  )));
    }
  }

  _extractIdFromUri(String uri) {
    RegExp regExp = RegExp(r'/videos/(\d+)');
    Match? match = regExp.firstMatch(uri);
    if (match != null) {
      String videoId = match.group(1)!;
      return videoId;
    }
  }
}

class VideoGrid extends StatefulWidget {
  final List<Data> videos;
  final ValueChanged<void> renderMore;
  final String token;

  const VideoGrid(
      {super.key,
      required this.videos,
      required this.renderMore,
      required this.token});

  @override
  State<VideoGrid> createState() => _VideoGridState();
}

class _VideoGridState extends State<VideoGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.videos.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.8,
      ),
      itemBuilder: (context, index) {
        if (index == widget.videos.length - 1) {
          widget.renderMore("");
        }
        return VideoTile(
          index: index,
          onFocus: (int value) {
            setState(() {});
          },
          video: widget.videos[index],
          token: widget.token,
        );
      },
    );
  }
}
