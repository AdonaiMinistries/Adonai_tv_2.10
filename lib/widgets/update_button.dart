import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:adonai_tv/constants.dart' as constants;
import "package:adonai_tv/styles.dart" as styles;

class UpdateButton extends StatefulWidget {
  const UpdateButton({super.key});

  @override
  State<UpdateButton> createState() => _UpdateButtonState();
}

class _UpdateButtonState extends State<UpdateButton> {
  var focusNode = FocusNode();
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {
        if (focusNode.hasFocus) {
          isFocused = true;
        } else {
          isFocused = false;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
        onKey: handleKeyEvent,
        focusNode: focusNode,
        child: TextButton(
            onPressed: () => openPlayStore(),
            style: styles.styleButton(isFocused),
            child: Text(
              "Update",
              style: styles.styleButtonText(isFocused),
            )));
  }

  void openPlayStore() async {
    if (await canLaunchUrlString(constants.adonaPlayStoreUrl)) {
      await launchUrlString(constants.adonaPlayStoreUrl);
    } else {
      throw 'Could not launch ${constants.adonaPlayStoreUrl}';
    }
  }

  handleKeyEvent(RawKeyEvent event) {
    if ((event.physicalKey == PhysicalKeyboardKey.mediaPlayPause) ||
        (event.physicalKey == PhysicalKeyboardKey.select) ||
        (event.logicalKey == LogicalKeyboardKey.select) ||
        (event.physicalKey == PhysicalKeyboardKey.mediaPlay)) {
      openPlayStore();
    }
  }
}
