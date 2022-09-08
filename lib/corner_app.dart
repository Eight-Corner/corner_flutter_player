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
  int currentPlayIndex = 0;

  /*List<String> srcs = [
    "https://res.cloudinary.com/dtdnarsy1/video/upload/v1661926846/videoplayback_lrigan.mp4",
    "https://res.cloudinary.com/dtdnarsy1/video/upload/v1661926657/get_mbhcvn.mp4",
    "https://res.cloudinary.com/dtdnarsy1/video/upload/v1661926678/get_eu56us.mp4",
    "https://res.cloudinary.com/dtdnarsy1/video/upload/v1661918926/ive_fmlybl.mp4",
    "https://res.cloudinary.com/dtdnarsy1/video/upload/v1661918923/instagram_video_kjgarl.mp4",
    "https://assets.mixkit.co/videos/preview/mixkit-spinning-around-the-earth-29351-large.mp4",
    "https://assets.mixkit.co/videos/preview/mixkit-daytime-city-traffic-aerial-view-56-large.mp4",
    "https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4"
  ];*/
  List<String> srcs = [
    "https://tbfmxuynnmxj8335367.cdn.ntruss.com/hls/m5YUQv389Mra9Mb4ix0nbw__/vodEnd/94000/eatalk-vod-abr/JvO9YH0h36527397_720p2.mp4/index.m3u8",
    "https://tbfmxuynnmxj8335367.cdn.ntruss.com/hls/m5YUQv389Mra9Mb4ix0nbw__/vodEnd/72000/eatalk-vod-abr/YoXHKIAI19748917_720p2.mp4/index.m3u8",
    "https://res.cloudinary.com/dtdnarsy1/video/upload/v1661918923/instagram_video_kjgarl.mp4",
  ];

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> initPlayer() async {

    _controller = VideoPlayerController.network(srcs[currentPlayIndex]);
    await Future.wait([
      _controller.initialize(),
    ]);
    controllerSetup();
    setState(() {});
  }

  // 비디오 컨트롤러 옵션
  void controllerSetup() {
    VideoProgressIndicator(
      _controller,
      allowScrubbing: true,
      colors: VideoProgressColors(
        playedColor: Colors.red,
        bufferedColor: Colors.black45,
        backgroundColor: Colors.grey,
      ),
    );
  }

  Future<void> _nextVideo() async {
    if (_controller.value.isPlaying) {
      await _controller.pause();
    }
    print('srcs.length: ${srcs.length}');
    print('currentPlayIndex: $currentPlayIndex');
    print('--- ${currentPlayIndex > srcs.length}');

    currentPlayIndex++;

    if (currentPlayIndex > srcs.length) {
      currentPlayIndex = 0;
    }
    await initPlayer();

    await _controller.play();
  }

  Future<void> _previousVideo() async {
    if (_controller.value.isPlaying) {
      await _controller.pause();
    }

    currentPlayIndex--;

    if (currentPlayIndex < 0) {
      currentPlayIndex = srcs.length - 1;
    }
    await initPlayer();

    await _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VPE Flutter Video Demo',
      home: Scaffold(
        appBar: AppBar(toolbarHeight: 0, backgroundColor: Colors.black),
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _previousVideo();
                  });
                },
                child: Icon(Icons.skip_previous),
              ),
              FloatingActionButton(
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
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _nextVideo();
                  });
                },
                child: Icon(Icons.skip_next),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
