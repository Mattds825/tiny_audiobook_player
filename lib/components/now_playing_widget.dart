import 'dart:io';
import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';

class NowPlayingWidget extends StatefulWidget {
  final File audioFile;
  final bool fileAvailable;
  AudioPlayer audioPlayer;

  NowPlayingWidget(this.audioFile, this.fileAvailable, this.audioPlayer);

  @override
  _NowPlayingWidgetState createState() => _NowPlayingWidgetState();
}

class _NowPlayingWidgetState extends State<NowPlayingWidget> {
  AudioPlayer audioPlayer;
  int currentPosition = 0;
  int size = 100;

  @override
  void initState() {
    super.initState();
    getAudioInfo();
  }

  getAudioInfo() async {
    if (widget.fileAvailable) {
      audioPlayer = widget.audioPlayer;
      audioPlayer.onPlayerStateChanged.listen((s) {
        if (audioPlayer.duration.inSeconds != 0) {
          setState(() {
            size = audioPlayer.duration.inSeconds;
          });
        }
      });
      audioPlayer.onAudioPositionChanged.listen((p) {
        setState(() {
          currentPosition = p.inSeconds;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: _getMessage(context),
      ),
    );
  }

  _getMessage(BuildContext context) {
    if (widget.fileAvailable) {
      getAudioInfo();
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 20.0,
          ),
          Icon(
            Icons.audiotrack,
            color: Colors.white,
            size: 80.0,
          ),
          Text(
            'Playing: ${widget.audioFile.path.split('/').last}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.w200,
            ),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 5,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 30.0),
                      thumbColor: Colors.white,
                      overlayColor: Colors.transparent,
                      activeTrackColor: Colors.red[300],
                      inactiveTrackColor: Colors.grey[300],
                    ),
                    child: Slider(
                      value: currentPosition.roundToDouble(),
                      min: 0,
                      max: size.roundToDouble() ?? 100,
                      onChanged: (double newVal) {
                        setState(() {
                          audioPlayer.seek(newVal);
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.audioPlayer.duration.toString(),
                    style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey[100],
                        fontWeight: FontWeight.w300),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Text(
        'nothing playing at the moment',
        style: TextStyle(
          color: Colors.white,
          fontSize: 28.0,
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.center,
      );
    }
  }
}
