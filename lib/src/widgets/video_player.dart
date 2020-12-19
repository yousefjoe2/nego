import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MyVideoPlayer extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;

  const MyVideoPlayer({
    Key key,
    this.videoPlayerController,
    this.looping,
  }) : super(key: key);
  @override
  _MyVideoPlayerState createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  ChewieController _chewieController;
  @override
  void initState() {
    super.initState();
    // Wrapper on top of the MyVideoPlayerController
    _chewieController = ChewieController(
      videoPlayerController: widget?.videoPlayerController,
      aspectRatio: 16 / 9,
      autoInitialize: true,
      looping: widget?.looping,
      placeholder: Container(
        color: Colors.transparent,
      ),
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.transparent),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height / 3.6,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _chewieController?.dispose();
    // widget?.videoPlayerController?.dispose();
  }
}
