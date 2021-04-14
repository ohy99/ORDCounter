import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class MyRiveAnimation extends StatefulWidget {
  @override
  _MyRiveAnimationState createState() => _MyRiveAnimationState();
}

class _MyRiveAnimationState extends State<MyRiveAnimation> {
  // void _togglePlay() {
  //   setState(() => _controller.isActive = !_controller.isActive);
  // }

  /// Tracks if the animation is playing by whether controller is running.
  bool get isPlaying => _controller?.isActive ?? false;

  Artboard _artboard;
  RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();

    rootBundle.load('assets/images/soldieranimas1.riv').then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);
        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;
        // Add a controller to play back a known animation on the main/default
        // artboard.We store a reference to it so we can toggle playback.
        artboard.addController(_controller = SimpleAnimation('Animation 1'));
        setState(() => _artboard = artboard);
      },
    );
  }

  // loads a Rive file
  // void _loadRiveFile() async {
  //   final bytes = await rootBundle.load(riveFileName);
  //   final file = RiveFile();

  //   if (file.import(bytes)) {
  //     // Select an animation by its name
  //     setState(() => _artboard = file.mainArtboard
  //       ..addController(
  //         SimpleAnimation('Animation 1'),
  //       ));
  //   }
  // }

  /// Show the rive file, when loaded
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: _artboard == null
            ? const SizedBox()
            : Rive(artboard: _artboard, fit: BoxFit.contain),
      ),
    );
    // return _artboard != null
    //     ? Rive(
    //         artboard: _artboard,
    //         fit: BoxFit.cover,
    //         alignment: Alignment.center,
    //       )
    //     : Container();
  }
}

class MyBgAnimation extends StatefulWidget {
  @override
  _MyBgAnimationState createState() => _MyBgAnimationState();
}

class _MyBgAnimationState extends State<MyBgAnimation> {
  bool get isPlaying => _controller?.isActive ?? false;

  Artboard _artboard;
  RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();

    rootBundle.load('assets/images/bgforapp1.riv').then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);
        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;
        // Add a controller to play back a known animation on the main/default
        // artboard.We store a reference to it so we can toggle playback.
        artboard.addController(_controller = SimpleAnimation('timechange'));
        setState(() => _artboard = artboard);
      },
    );
  }

  // loads a Rive file
  // void _loadRiveFile() async {
  //   final bytes = await rootBundle.load(riveFileName);
  //   final file = RiveFile();

  //   if (file.import(bytes)) {
  //     // Select an animation by its name
  //     setState(() => _artboard = file.mainArtboard
  //       ..addController(
  //         SimpleAnimation('timechange'),
  //       ));
  //   }
  // }

  /// Show the rive file, when loaded
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: _artboard == null
            ? const FittedBox()
            : Rive(
                artboard: _artboard,
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
      ),
    );
  }
}
