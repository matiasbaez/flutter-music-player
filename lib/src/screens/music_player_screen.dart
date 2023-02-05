import 'package:flutter/material.dart';

// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';

import 'package:musicplayer/src/helpers/helpers.dart';
import 'package:musicplayer/src/widgets/widgets.dart';
import 'package:musicplayer/src/models/models.dart';

class MusicPlayerScreen extends StatelessWidget {

  const MusicPlayerScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Stack(
        children: [

          const _Background(),

          Column(
            children: const [

              CustomAppbar(),

              _DiscImageAndDuration(),

              _TitlePlay(),

              Expanded(
                child: _Lyrics()
              )

            ],
          ),
        ],
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: screenSize.height * 0.8,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only( bottomLeft: Radius.circular(60) ),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.center,
          colors: <Color>[
            Color(0xff33333E),
            Color(0xff201E28),
          ]
        )
      ),
    );
  }
}

class _DiscImageAndDuration extends StatelessWidget {
  const _DiscImageAndDuration({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric( horizontal: 30 ),
      margin: const EdgeInsets.only( top: 80 ),
      child: Row(
        children: const <Widget>[

          _DiscImage(),
          SizedBox( width: 40 ),

          _MusicProgress(),
          // SizedBox( width: 0 ),

        ],
      ),
    );
  }
}

class _DiscImage extends StatelessWidget {

  const _DiscImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final audioPlayer = Provider.of<AudioPlayer>(context);

    return Container(
      width: 250,
      height: 250,
      padding: const EdgeInsets.all( 20 ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular( 200 ),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          colors: <Color>[
            Color(0xff484750),
            Color(0xff1E1C24),
          ]
        )
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular( 200 ),
        child: Stack(
          alignment: Alignment.center,
          children: [

            SpinPerfect(
              infinite: true,
              manualTrigger: true,
              animate: audioPlayer.playing,
              duration: const Duration( seconds: 10 ),
              controller: (controller) => audioPlayer.controller = controller,
              child: const Image(image: AssetImage('assets/aurora.jpg') )
            ),

            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular( 100 )
              ),
            ),

            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: const Color(0xff1C1C25),
                borderRadius: BorderRadius.circular( 100 )
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MusicProgress extends StatelessWidget {

  const _MusicProgress({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final textStyle = TextStyle( color: Colors.white.withOpacity(0.4) );
    final audioPlayer = Provider.of<AudioPlayer>(context);
    final percentage = audioPlayer.percentage;

    return Container(
      child: Column(
        children: [
          Text( audioPlayer.songTotalDuration, style: textStyle ),
          const SizedBox( height: 10 ),

          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: 2,
                height: 200,
                color: Colors.white.withOpacity(0.1),
              ),

              Container(
                width: 2,
                height: 230 * percentage,
                color: Colors.white.withOpacity(0.8),
              ),
            ],
          ),

          const SizedBox( height: 10 ),
          Text( audioPlayer.currentSecond, style: textStyle ),
        ],
      ),
    );
  }
}

class _TitlePlay extends StatefulWidget {
  const _TitlePlay({
    Key? key,
  }) : super(key: key);

  @override
  State<_TitlePlay> createState() => _TitlePlayState();
}

class _TitlePlayState extends State<_TitlePlay> with SingleTickerProviderStateMixin {

  bool isPlaying = false;
  bool isFirstTime = true;
  late AnimationController controller;

  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    controller = AnimationController( vsync: this, duration: const Duration( milliseconds: 500 ) );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void open() {
    final audioPlayer = Provider.of<AudioPlayer>(context, listen: false);

    assetsAudioPlayer.open(
      Audio('assets/Breaking-Benjamin-Far-Away.mp3'),
      autoStart: true,
      showNotification: true
    );

    assetsAudioPlayer.currentPosition.listen( (duration) {
      audioPlayer.current = duration;
    });

    assetsAudioPlayer.current.listen((playingAudio) {
      audioPlayer.songDuration = playingAudio?.audio.duration ?? Duration( seconds: 0 );
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric( horizontal: 50 ),
      margin: const EdgeInsets.only( top: 40 ),
      child: Row(
        children: <Widget>[

          Column(
            children: <Widget>[

              Text('Far away', style: TextStyle( fontSize: 30, color: Colors.white.withOpacity(0.8) ) ),
              Text('-Breaking Benjaming-', style: TextStyle( fontSize: 15, color: Colors.white.withOpacity(0.5) ) ),

            ],
          ),

          const Spacer(),

          FloatingActionButton(
            onPressed: () {

              final audioPlayer = Provider.of<AudioPlayer>(context, listen: false);

              if (isPlaying) {
                isPlaying = false;
                controller.reset();
                audioPlayer.controller.stop();
              } else {
                isPlaying = true;
                controller.forward();
                audioPlayer.controller.repeat();
              }

              audioPlayer.playing = isPlaying;

              if (isFirstTime) {
                open();
                isFirstTime = false;
              } else {
                assetsAudioPlayer.playOrPause();
              }

            },
            elevation: 0,
            highlightElevation: 0,
            backgroundColor: const Color(0xffF8CB51),
            child: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: controller,
            ),
          )

        ],
      ),
    );
  }
}

class _Lyrics extends StatelessWidget {
  const _Lyrics({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final lyrics = getLyrics();

    return Container(
      child: ListWheelScrollView(
        diameterRatio: 1.5,
        itemExtent: 42,
        physics: const BouncingScrollPhysics(),
        children: lyrics.map((text) => Text(text, style: TextStyle( fontSize: 20, color: Colors.white.withOpacity(0.6) ) )).toList(),
      ),
    );
  }
}
