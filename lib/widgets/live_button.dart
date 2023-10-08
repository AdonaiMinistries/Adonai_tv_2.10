import 'package:adonai_tv/models/app_config.dart';
import 'package:adonai_tv/screens/live_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:adonai_tv/styles.dart' as styles;

import '../blocs/bloc.dart';

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
    final bloc = BlocProvider.of<AppBloc>(context);
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
          style: styles.styleButton(_focused),
          child: Text(
            "LIVE",
            style: styles.styleButtonText(_focused),
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
