import 'package:flutter/material.dart';

class AudioPlayer with ChangeNotifier {

  bool _playing = false;
  late AnimationController _controller;
  Duration _current = Duration( milliseconds: 0 );
  Duration _songDuration = Duration( milliseconds: 0 );

  bool get playing => _playing;
  Duration get current => _current;
  Duration get songDuration => _songDuration;
  AnimationController get controller => _controller;
  double get percentage => (_songDuration.inSeconds > 0) ? _current.inSeconds / _songDuration.inSeconds : 0;

  String get songTotalDuration => printDuration( _songDuration );
  String get currentSecond => printDuration( _current );


  set controller( AnimationController controller ) {
    _controller = controller;
  }

  set playing( bool playing ) {
    _playing = playing;
    notifyListeners();
  }

  set current( Duration duration ) {
    _current = duration;
    notifyListeners();
  }

  set songDuration( Duration duration ) {
    _songDuration = duration;
    notifyListeners();
  }

  String printDuration( Duration duration ) {

    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    // String twoDigitHours = twoDigits(duration.inHours.remainder(60));
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return "$twoDigitMinutes:$twoDigitSeconds";
  }

}
