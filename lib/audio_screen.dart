import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade600, Colors.grey.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.snackbar(
                        'Coming Soon',
                        'This feature is currently being developed.',
                        backgroundColor: Colors.white,
                      );
                    },
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              const Text(
                "RA7 MENNY",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "LEGE-CY",
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    formatDuration(_audioPlayer.position),
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    '|',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    formatDuration(_audioPlayer.duration ?? Duration.zero),
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(340, 340),
                    painter: CirclePainter(
                      progress: _progress,
                    ),
                  ),
                  ClipOval(
                    child: Image.asset(
                      'assets/images/pic.jpg',
                      width: 290,
                      height: 290,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      await _audioPlayer.seek(Duration.zero);
                    },
                    icon: const Icon(Icons.skip_previous_rounded,
                        color: Colors.white, size: 50),
                  ),
                  const SizedBox(width: 30),
                  IconButton(
                    onPressed: () async {
                      if (_audioPlayer.playing) {
                        await _audioPlayer.pause();
                      } else {
                        await _audioPlayer.play();
                      }
                    },
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        _audioPlayer.playing
                            ? Icons.pause_circle
                            : Icons.play_arrow_rounded,
                        key: ValueKey<bool>(
                          _audioPlayer.playing,
                        ),
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                  IconButton(
                    onPressed: () async {
                      await _audioPlayer.seekToNext();
                    },
                    icon: const Icon(Icons.skip_next_rounded,
                        color: Colors.white, size: 50),
                  ),
                ],
              ),
            ],
          ),
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
