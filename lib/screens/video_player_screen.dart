import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

/* ATTEMPT - 3 */
class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _showControls = false;
  late FocusNode _playButtonFocusNode;
  late Timer _timer;
  double _progress = 0.0;
  bool _isDragging = false;

  final String _sampleUrl =
      "https://skyfire.vimeocdn.com/1680033663-0xf2fa61a7322cdeb15e0a54b36bcb1921286d83cd/09614d9a-1cf8-4300-9491-9e346c483ff2/sep/video/36426c1d,41c4eb7f,5e6c0306,6a4136f4,a0a4587f/audio/cb6ffe87/subtitles/70242394-English%20%28auto-generated%29-en-x-autogen-cc/master.m3u8?external-subs=1&query_string_ranges=1&subcache=1&subtoken=7eb347168bec085e352ee0bd9d4116ccf9f4f8be0fc5484bc283ec06d096e7c5";

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(_sampleUrl);
    _initializeVideoPlayerFuture = _controller.initialize();

    _playButtonFocusNode = FocusNode();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.play();
    });

    _controller.addListener(_videoControllerListener);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _playButtonFocusNode.dispose();
    _controller.removeListener(_videoControllerListener);
    _timer.cancel();
  }

  void toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  void _videoControllerListener() {
    if (!_isDragging) {
      setState(() {
        _progress = _controller.value.position.inMilliseconds.toDouble() /
            _controller.value.duration.inMilliseconds.toDouble();
      });
    }
  }

  void _startTimer() {
    _timer = Timer(const Duration(seconds: 5), () {
      setState(() {
        if (_controller.value.isPlaying) {
          _showControls = false;
        } else {
          _showControls = true;
        }

        _timer.cancel();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: _onKeyEvent,
          autofocus: true,
          child: Stack(
            children: <Widget>[
              _renderVideoPlayer(),
              if (_showControls) _renderControls()
            ],
          )),
    );
  }

  Widget _renderControls() {
    return Stack(
      children: [
        Positioned(left: 0, bottom: 0, right: 0, child: _renderProgressBar()),
        Positioned(
          left: 0,
          bottom: 0,
          right: 0,
          top: 0,
          child: _renderPlayPauseButton(),
        )
      ],
    );
  }

  Container _renderPlayPauseButton() {
    return Container(
      color: Colors.black45,
      child: IconButton(
          focusColor: Colors.red,
          focusNode: _playButtonFocusNode,
          color: Colors.white,
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause
                  : _controller.play();
            });
          },
          icon: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow)),
    );
  }

  Widget _renderProgressBar() {
    return GestureDetector(
      onHorizontalDragStart: (details) {
        _isDragging = true;
      },
      onHorizontalDragUpdate: (details) {
        setState(() {
          _progress += details.delta.dx / MediaQuery.of(context).size.width;
          if (_progress < 0) {
            _progress = 0;
          } else if (_progress > 1) {
            _progress = 1;
          }
        });
      },
      onHorizontalDragEnd: (details) {
        _isDragging = false;
        _controller.seekTo(Duration(
            milliseconds:
                (_progress * _controller.value.duration.inMilliseconds)
                    .toInt()));
      },
      child: Stack(
        children: [
          LinearProgressIndicator(
            value: _progress,
            backgroundColor: Colors.grey,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
          ),
          Container(
            height: 10,
            color: Colors.transparent,
          ),
        ],
      ),
    );
  }

  FutureBuilder<void> _renderVideoPlayer() {
    return FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: 16 / 9,
              child: VideoPlayer(_controller),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  _onKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if ((event.logicalKey == LogicalKeyboardKey.mediaPlayPause) ||
          (event.logicalKey == LogicalKeyboardKey.select)) {
        setState(() {
          if (_controller.value.isPlaying) {
            _controller.pause();
            _showControls = true;
          } else {
            _controller.play();
            _showControls = false;
          }
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        setState(() {
          Duration currentPosition = _controller.value.position;
          Duration seekTo = Duration(
              seconds: currentPosition.inSeconds > 10
                  ? currentPosition.inSeconds - 10
                  : 0);
          _controller.seekTo(seekTo);
          _showControls = true;
          _startTimer();
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        setState(() {
          Duration currentPosition = _controller.value.position;
          Duration seekTo = Duration(
              seconds: currentPosition.inSeconds + 10 <
                      _controller.value.duration.inSeconds
                  ? currentPosition.inSeconds + 10
                  : _controller.value.duration.inSeconds);
          _controller.seekTo(seekTo);
          _showControls = true;
          _startTimer();
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        setState(() {
          _playButtonFocusNode.requestFocus();
          _showControls = true;
          _startTimer();
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() {
          _playButtonFocusNode.requestFocus();
          _showControls = true;
          _startTimer();
        });
      } else if (event.logicalKey == LogicalKeyboardKey.backspace) {
        Navigator.of(context).pop();
      }
    }
  }
}
