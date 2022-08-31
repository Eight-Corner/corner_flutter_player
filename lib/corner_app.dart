import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Stateful widget to fetch and then display video content.
class VideoApp extends StatefulWidget {
  const VideoApp({Key? key}) : super(key: key);

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;

  List<String> srcs = [
    "https://res.cloudinary.com/dtdnarsy1/video/upload/v1661926846/videoplayback_lrigan.mp4",
    "https://res.cloudinary.com/dtdnarsy1/video/upload/v1661926657/get_mbhcvn.mp4",
    "https://res.cloudinary.com/dtdnarsy1/video/upload/v1661926678/get_eu56us.mp4",
    "https://res.cloudinary.com/dtdnarsy1/video/upload/v1661918926/ive_fmlybl.mp4",
    "https://res.cloudinary.com/dtdnarsy1/video/upload/v1661918923/instagram_video_kjgarl.mp4",
    "https://assets.mixkit.co/videos/preview/mixkit-spinning-around-the-earth-29351-large.mp4",
    "https://assets.mixkit.co/videos/preview/mixkit-daytime-city-traffic-aerial-view-56-large.mp4",
    "https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4"
  ];
  int currPlayIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(srcs[currPlayIndex])
    ..initialize().then((_) {
    setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
