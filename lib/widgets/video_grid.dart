import 'package:adonai_tv/models/vime_video.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VideoTile extends StatefulWidget {
  final int index;
  final ValueChanged<int> onFocus;
  final Data video;

  const VideoTile(
      {super.key,
      required this.index,
      required this.onFocus,
      required this.video});

  @override
  _VideoTileState createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  bool _isInFocus = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isInFocus = hasFocus;
          if (hasFocus) {
            widget.onFocus(widget.index);
          }
        });
      },
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
          errorWidget: (context, url, error) => Icon(Icons.error),
          placeholder: (context, url) => Container(
            decoration: BoxDecoration(color: Colors.grey[700]),
          ),
        ),
      ),
    );
  }
}

class VideoGrid extends StatefulWidget {
  final List<Data> videos;
  final ValueChanged<void> renderMore;

  const VideoGrid({super.key, required this.videos, required this.renderMore});

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
        );
      },
    );
  }
}
