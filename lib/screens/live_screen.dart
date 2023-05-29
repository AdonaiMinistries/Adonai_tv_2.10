import 'dart:async';
import 'dart:convert';

import 'package:adonai_tv/models/app_config.dart';
import 'package:adonai_tv/screens/video_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class LiveScreen extends StatefulWidget {
  final AppConfig appConfig;
  const LiveScreen({super.key, required this.appConfig});

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  // String dt = "04/16/2023 08:30:00 AM";
  late DateTime dtObj;
  bool displayTimer = true;
  Timer? _timer;
  late int days, hours, minutes;
  late AppConfig _appConfig;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    try {
      _fetchAppConfig().then((_) {
        dtObj =
            DateFormat("MM/dd/yyyy hh:mm:ss a").parse(_appConfig.nextStream);
        _timeDifference();
        _startTimer();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const CircularProgressIndicator(
              color: Colors.red,
            )
          : (displayTimer ? _renderTimer(context) : Container()),
    );
  }

  Padding _renderTimer(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * .27),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "NEXT SERVICE",
              style: TextStyle(
                  color: Colors.grey[400], fontSize: 18, letterSpacing: 1),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .02,
            ),
            Text(
              DateFormat('E MMM d h:mm:ss a').format(dtObj),
              style: const TextStyle(
                  color: Colors.white, fontSize: 18, letterSpacing: 1),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .02,
            ),
            _renderTimerBox(days, context, hours, minutes),
          ],
        ),
      ),
    );
  }

/* 
 * INTERMEDIATE FUNCTIONS
 */
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeDifference();
        if ((days <= 0) && (minutes <= 0) && (hours <= 0)) {
          _timer?.cancel();
          displayTimer = false;

          _fetchAppConfig().then((value) => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(
                        url: _appConfig.link,
                        isLive: true,
                      ))));
        }
      });
    });
  }

  void _timeDifference() {
    Duration difference = dtObj.difference(DateTime.now());

    days = difference.inDays;
    hours = difference.inHours.remainder(24);
    minutes = difference.inMinutes.remainder(60);
  }

  Row _renderTimerBox(int days, BuildContext context, int hours, int minutes) {
    return Row(
      children: <Widget>[
        _buildTimeBox('$days', 'Days'),
        SizedBox(
          width: MediaQuery.of(context).size.width * .005,
        ),
        _buildTimeBox('$hours', 'Hours'),
        SizedBox(
          width: MediaQuery.of(context).size.width * .005,
        ),
        _buildTimeBox('$minutes', 'Minutes'),
      ],
    );
  }

  Widget _buildTimeBox(String value, String label) {
    return Container(
      width: MediaQuery.of(context).size.width * .15,
      height: MediaQuery.of(context).size.height * .15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[800],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchAppConfig() async {
    const String url = 'https://www.adonaichurch.in/app-config.json';

    final response = await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer $widget.appConfig.token",
      "Content-Type": "application/json"
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _appConfig = AppConfig.fromJson(data);
      setState(() {
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to fetch vimeo videos');
    }
  }
}
