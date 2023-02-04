import 'package:flutter/material.dart';

class LiveButton extends StatefulWidget {
  const LiveButton({super.key});

  @override
  _LiveButtonState createState() => _LiveButtonState();
}

class _LiveButtonState extends State<LiveButton> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _focused = hasFocus;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * .10,
        height: MediaQuery.of(context).size.width * .035,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          color: _focused ? Colors.white : Colors.red,
        ),
        child: Center(
          child: Text(
            'Live',
            style: TextStyle(
              color: _focused ? Colors.red : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
