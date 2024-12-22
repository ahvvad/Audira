import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart';
import 'circle_painter.dart';

class ForestSoundUI extends StatefulWidget {
  const ForestSoundUI({super.key});

  @override
  _ForestSoundUIState createState() => _ForestSoundUIState();
}

class _ForestSoundUIState extends State<ForestSoundUI>
    with SingleTickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  double _progress = 0.0; // Start progress at 0%

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Load the audio file
    _audioPlayer.setAsset('assets/audio/Ra7-Menny.mp3').then((_) {
      // Listen to position changes to update progress
      _audioPlayer.positionStream.listen((position) {
        final duration = _audioPlayer.duration ?? Duration.zero;
        if (duration.inMilliseconds > 0) {
          setState(() {
            _progress = position.inMilliseconds / duration.inMilliseconds;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade700,
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        leading: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.white,
          size: 35,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Forest Sound",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Forest Sound",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(350, 350),
                  painter: CirclePainter(progress: _progress),
                ),
                ClipOval(
                  child: SvgPicture.asset(
                    "assets/images/headphones.svg",
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  formatDuration(_audioPlayer.position),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  formatDuration(_audioPlayer.duration ?? Duration.zero),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    await _audioPlayer.seek(Duration.zero);
                  },
                  icon: const Icon(Icons.skip_previous,
                      color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () async {
                    if (_audioPlayer.playing) {
                      await _audioPlayer.pause();
                    } else {
                      await _audioPlayer.play();
                    }
                  },
                  icon: Icon(
                    _audioPlayer.playing ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () async {
                    await _audioPlayer.seekToNext();
                  },
                  icon: const Icon(Icons.skip_next,
                      color: Colors.white, size: 32),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
