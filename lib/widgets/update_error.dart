import 'package:adonai_tv/widgets/update_button.dart';
import 'package:flutter/material.dart';
import 'package:adonai_tv/constants.dart' as constant;

class RenderUpdateError extends StatelessWidget {
  const RenderUpdateError({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Text(
            "Update Required",
            style: TextStyle(color: Colors.grey[100], fontSize: 30),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .02),
          Text(
            constant.updateMessage,
            style: TextStyle(color: Colors.grey[400], fontSize: 25),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .05),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * .28),
            child: const UpdateButton(),
          )
        ]));
  }
}
