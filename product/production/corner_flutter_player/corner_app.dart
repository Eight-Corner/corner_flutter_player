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
    'https://tbfmxuynnmxj8335367.cdn.ntruss.com/hls/m5YUQv389Mra9Mb4ix0nbw__/vodEnd/94000/eatalk-vod-abr/JvO9YH0h36527397_720p2.mp4/index.m3u8',
    'https://tbfmxuynnmxj8335367.cdn.ntruss.com/hls/m5YUQv389Mra9Mb4ix0nbw__/vodEnd/72000/eatalk-vod-abr/YoXHKIAI19748917_720p2.mp4/index.m3u8'
  ];
  int currPlayIndex = 0;

  @override
  void initState() async {

    super.initState();

    _controller = VideoPlayerController.network(srcs[currPlayIndex]);

    Future.wait([
      _controller.initialize(),
    ]);

    controllerSetup();
    
    setState(() {});
  }

  // 비디오 컨트롤러 옵션
  void controllerSetup() {
    // _controller =
    // _controller = VideoPlayerOptions(
    //   videoPlayController: _controller,
    //
    // ),
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

  Future<void> nextVideo() async {
    await _controller.pause();

    currPlayIndex += 1;
    if (currPlayIndex >= srcs.length) {
      currPlayIndex = 0;
    }
    await _controller.play();
  }

  Future<void> previousVideo() async {
    await _controller.pause();

    currPlayIndex -= 1;
    if (currPlayIndex < 0) {
      currPlayIndex = srcs.length - 1;
    }

    await _controller.play();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Video Demo',
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
                  previousVideo();
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
                  nextVideo();
                },
                child: Icon(Icons.skip_next),
              ),
            ],
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
