import 'package:adonai_tv/screens/video_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LiveButton extends StatefulWidget {
  const LiveButton({super.key});

  @override
  _LiveButtonState createState() => _LiveButtonState();
}

class _LiveButtonState extends State<LiveButton> {
  late bool _focused = false;
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => {
          setState(() {
            if (_focus.hasFocus) {
              _focused = true;
            } else {
              _focused = false;
            }
          })
        });
  }

  @override
  void dispose() {
    super.dispose();
    _focus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RawKeyboardListener(
        onKey: _handleKeyEvent,
        focusNode: _focus,
        child: TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const VideoPlayerScreen()));
          },
          style: TextButton.styleFrom(
              backgroundColor: _focused ? Colors.white : Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              fixedSize: const Size(100, 20)),
          child: Text(
            "LIVE",
            style: TextStyle(color: _focused ? Colors.red : Colors.white),
          ),
        ),
      ),
    );
    // return GestureDetector(
    //   onTap: () => {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (context) => const VideoPlayerScreen()),
    //     )
    //   },
    //   child: Focus(
    //     onFocusChange: (hasFocus) {
    //       setState(() {
    //         _focused = hasFocus;
    //       });
    //     },
    //     child: Container(
    //       width: MediaQuery.of(context).size.width * .10,
    //       height: MediaQuery.of(context).size.width * .035,
    //       decoration: BoxDecoration(
    //         borderRadius: const BorderRadius.all(Radius.circular(8.0)),
    //         color: _focused ? Colors.white : Colors.red,
    //       ),
    //       child: Center(
    //         child: Text(
    //           'Live',
    //           style: TextStyle(
    //             color: _focused ? Colors.red : Colors.white,
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  _handleKeyEvent(RawKeyEvent event) {
    if ((event.physicalKey == PhysicalKeyboardKey.mediaPlayPause) ||
        (event.physicalKey == PhysicalKeyboardKey.select) ||
        (event.logicalKey == LogicalKeyboardKey.select) ||
        (event.physicalKey == PhysicalKeyboardKey.mediaPlay)) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const VideoPlayerScreen()));
    }
  }
}
