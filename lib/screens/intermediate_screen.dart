import 'dart:convert';
import 'package:adonai_tv/screens/video_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../models/vime_video.dart';

class IntermediateScreen extends StatefulWidget {
  final String id;
  final String token;
  const IntermediateScreen({super.key, required this.id, required this.token});

  @override
  State<IntermediateScreen> createState() => _IntermediateScreenState();
}

class _IntermediateScreenState extends State<IntermediateScreen> {
  bool _isLoading = true;
  late VideoConfigData _configData;

  @override
  void initState() {
    super.initState();
    _fetchVideoConfig(widget.id).then((value) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                VideoPlayerScreen(url: _configData.uri, isLive: false))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container());
  }

  Future<void> _fetchVideoConfig(String id) async {
    String url = 'https://player.vimeo.com/video/$id/config';

    final response = await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer $widget.token",
      "Content-Type": "application/json"
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _configData = VideoConfigData.fromJson(data);
      setState(() {
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to fetch vimeo videos');
    }
  }
}
