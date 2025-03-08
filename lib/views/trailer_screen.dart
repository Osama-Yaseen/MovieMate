import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrailerScreen extends StatefulWidget {
  final String trailerKey;

  const TrailerScreen({super.key, required this.trailerKey});

  @override
  State<TrailerScreen> createState() => _TrailerScreenState();
}

class _TrailerScreenState extends State<TrailerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.trailerKey,
      flags: YoutubePlayerFlags(autoPlay: true, mute: false),
    )..addListener(_handleFullScreen);
  }

  void _handleFullScreen() {
    if (!_controller.value.isFullScreen) {
      _forcePortraitMode();
    }
  }

  void _forcePortraitMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleFullScreen);
    _controller.dispose();
    _forcePortraitMode(); // ✅ Ensure portrait mode when closing screen
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true, // ✅ Allows back navigation
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          _forcePortraitMode(); // ✅ Ensure portrait mode on back press
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("movie_trailer".tr),
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              _forcePortraitMode(); // ✅ Ensure portrait mode before exiting
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Center(
          child: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.red,
            onReady: _forcePortraitMode,
          ),
        ),
      ),
    );
  }
}
