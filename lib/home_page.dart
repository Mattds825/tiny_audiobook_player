import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayer/audioplayer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiny_audiobook_player/components/expanded_column_widget.dart';
import 'package:tiny_audiobook_player/components/file_picker_widget.dart';
import 'package:tiny_audiobook_player/components/now_playing_widget.dart';

class HomeScreen extends StatefulWidget {
  bool fileAvailable = false;
  File audioFile;
  AudioPlayer audioPlugin = AudioPlayer();
  bool playing = false;
  int currentTime = 0;
  SharedPreferences prefs;

  HomeScreen() {
    audioPlugin.onAudioPositionChanged.listen((p) {
      currentTime = p.inSeconds;
    });
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();

  onPausePressed() {
    print('clicking pause');
    if (audioFile != null) {
      audioPlugin.pause();
      prefs.setInt('position', currentTime);
    }
  }

  onPlayPressed() {
    print('clicking play');
    if (audioFile != null) audioPlugin.play(audioFile.path);
  }

  onSkipBackwardPressed() {
    print('clicking back');
    if (audioFile != null) audioPlugin.seek(currentTime.round() - 10.0);
  }

  onSkipForwardPressed() {
    print('clicking forward');
    if (audioFile != null) audioPlugin.seek(currentTime.round() + 10.0);
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  _initPrefs() async {
    widget.prefs = await SharedPreferences.getInstance();
    setState(() {
      if (widget.prefs.containsKey('fileUri')) {
        print('has previous save');
        widget.audioFile = File.fromUri(
          Uri(
            path: widget.prefs.getString('fileUri'),
          ),
        );
        if (widget.prefs.containsKey('position')) {
          //widget.currentTime = widget.prefs.getInt('position');
          widget.audioPlugin.seek(widget.prefs.getInt('position').toDouble());
        }
        setState(() {
          widget.fileAvailable = true;
        });
      }
    });
  }

  @override
  void dispose() {
    //widget.prefs.setInt('position', widget.currentTime);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: SafeArea(
        child: Column(
          children: [
            ExpandedColumnWidget(
              flex: 1,
              itemType: ItemType.top,
              widget: Center(
                child: GestureDetector(
                  onTap: () {
                    _onPressedFileExpore();
                  },
                  child: FilePickerWidget(),
                ),
              ),
            ),
            ExpandedColumnWidget(
              flex: 4,
              itemType: ItemType.middle,
              widget: NowPlayingWidget(
                widget.audioFile,
                widget.fileAvailable,
                widget.audioPlugin,
              ),
            ),
            ExpandedColumnWidget(
              flex: 1,
              itemType: ItemType.bottom,
              widget: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.skip_previous,
                        color: Colors.white,
                        size: 40.0,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.onSkipBackwardPressed();
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        (!widget.playing)
                            ? Icons.play_circle_filled
                            : Icons.pause_circle_filled,
                        color: Colors.white,
                        size: 40.0,
                      ),
                      onPressed: () {
                        setState(() {
                          if (widget.playing) {
                            widget.onPausePressed();
                            widget.playing = false;
                          } else {
                            widget.onPlayPressed();
                            widget.playing = true;
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.skip_next,
                        color: Colors.white,
                        size: 40.0,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.onSkipForwardPressed();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPressedFileExpore() async {
    widget.audioFile = await FilePicker.getFile();
    widget.audioPlugin.pause();
    print(widget.audioFile.uri);
    widget.prefs.setString('fileUri', widget.audioFile.uri.path);
    setState(() {
      widget.fileAvailable = true;
    });
  }
}
