import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:smooth_video_progress/smooth_video_progress.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  // const VideoPlayerScreen({super.key});
  const VideoPlayerScreen({super.key, required this.videoUrl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  // double _sliderValue = 0.0;

  @override
  void initState() {
    super.initState();

    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        widget.videoUrl,
      ),
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.play();

    // _controller.addListener(() {
    //   setState(() {
    //     _sliderValue = _controller.value.position.inSeconds.toDouble();
    //   });
    // });

    // // Use the controller to loop the video.
    // _controller.setLooping(true);
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  // void _onSliderChanged(double value) {
  //   setState(() {
  //     final Duration newPosition = Duration(seconds: value.toInt());
  //     _controller.seekTo(newPosition);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Viewing'),
      ),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (widget.videoUrl.isEmpty) {
            // Show "Video still in processing" message
            return Center(
              child: Text(
                'Video still in processing',
                style: TextStyle(fontSize: 18),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            // _controller.play();
            return Column(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 28,
                  child: VideoPlayer(_controller),
                ),
                SmoothVideoProgress(
                  controller: _controller,
                  builder: (context, position, duration, child) => Slider(
                    // onChangeStart: (_) => _controller.play(),
                    // onChangeEnd: (value) => _controller
                    onChanged: (value) => _controller
                        .seekTo(Duration(milliseconds: value.toInt())),
                    value: position.inMilliseconds.toDouble(),
                    min: 0,
                    max: duration.inMilliseconds.toDouble(),
                  ),
                )
              ],
            );
          } else {
            // If the VideoPlayerController is still initializing, show a
            // loading spinner.
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
