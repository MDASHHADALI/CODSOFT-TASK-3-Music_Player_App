
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player_app/utils/utils.dart';
import 'package:music_player_app/widgets/audio_info.dart';
import 'constants.dart';
class PlayingScreen extends StatefulWidget {
  const PlayingScreen({super.key});

  @override
  State<PlayingScreen> createState() => _PlayingScreenState();
}

class _PlayingScreenState extends State<PlayingScreen> {
  bool isPlaying = true;
  late final AudioPlayer player;
  var au=["audios/Abhi mujh mein kahin.mp3","audios/Dekha Hazaron Dafaa.mp3","audios/Despacito.mp3","audios/Jo Bheji Thi Dua.mp3","audios/Get Ready To Fight.mp3","audios/Pehle Bhi Main.mp3"];
  Duration _duration = const Duration();
  Duration _position = const Duration();

  @override
  void initState() {
    initPlayer();
    super.initState();
    player.play(AssetSource(au[r]));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future initPlayer() async {
    player = AudioPlayer();
    player.play(AssetSource(au[r]));

    // set a callback for changing duration
    player.onDurationChanged.listen((Duration d) {
      setState(() => _duration = d);
    });

    // set a callback for position change
    player.onPositionChanged.listen((Duration p) {
      setState(() => _position = p);
    });

    // set a callback for when audio ends
    player.onPlayerComplete.listen((_) {
      setState(() => _position = _duration);
    });
  }

  void playPause() async {
    if (isPlaying) {
      player.pause();
      isPlaying = false;
    } else {
      player.play(AssetSource(au[r]));
      isPlaying = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             AudioInfo(),
            const SizedBox(height: 50),
            Slider(
              value: _position.inSeconds.toDouble(),
              onChanged: (value) async {
                await player.seek(Duration(seconds: value.toInt()));
                setState(() {


                });
              },
              min: 0,
              max: _duration.inSeconds.toDouble(),
              inactiveColor: Colors.grey,
              activeColor: Colors.red,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(_duration.format()),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        if(r==0)
                          {
                            r=t.length-1;
                          }
                        else
                          {
                            r--;
                          }
                        setState(() {
                          isPlaying=true;
                          player.play(AssetSource(au[r]));
                        });
                      });
                    },
                    child: Icon(
                      Icons.skip_previous,
                      color: Colors.red,
                      size: 50,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      player.seek(Duration(seconds: _position.inSeconds - 10));
                      setState(() {});
                    },
                    child: Icon(
                      Icons.replay_10_outlined ,
                      color: Colors.red,
                      size: 50,
                    ),
                  ),
                ),
                SizedBox(width:10),
                Expanded(
                  child: InkWell(
                    onTap: playPause,
                    child: Icon(
                      isPlaying ? Icons.pause_circle : Icons.play_circle,
                      color: Colors.red,
                      size: 80,
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      player.seek(Duration(seconds: _position.inSeconds + 10));
                      setState(() {});
                    },
                    child: Icon(
                      Icons.forward_10,
                      color: Colors.red,
                      size: 50,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: InkWell(
                    onTap: ()=>{
                      if(r==t.length-1)
                       { r=0,}
                      else
                        {r=r+1},

                      setState((){
                        isPlaying=true;
                        player.play(AssetSource(au[r]));
                      })
                    },
                    child: Icon(
                      Icons.skip_next,
                      color: Colors.red,
                      size: 50,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
