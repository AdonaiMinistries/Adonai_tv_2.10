import 'package:adonai_tv/models/app_config.dart';
import 'package:adonai_tv/screens/live_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LiveButton extends StatefulWidget {
  final AppConfig appConfig;
  const LiveButton({super.key, required this.appConfig});

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
                    builder: (context) =>
                        LiveScreen(appConfig: widget.appConfig)));
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
  }

  _handleKeyEvent(RawKeyEvent event) {
    if ((event.physicalKey == PhysicalKeyboardKey.mediaPlayPause) ||
        (event.physicalKey == PhysicalKeyboardKey.select) ||
        (event.logicalKey == LogicalKeyboardKey.select) ||
        (event.physicalKey == PhysicalKeyboardKey.mediaPlay)) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LiveScreen(appConfig: widget.appConfig)));
    }
  }
}
