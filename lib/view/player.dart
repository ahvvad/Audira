import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../consts/colors.dart';
import '../consts/text_style.dart';
import '../controllers/player_controller.dart';

class Player extends StatelessWidget {
  final List<SongModel> data;
  const Player({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    var conteoller = Get.find<PlayerController>();
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: whiteColor,
            size: 30,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(
              () => Expanded(
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  height: 300,
                  width: 300,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: QueryArtworkWidget(
                    id: data[conteoller.playIndex.value].id,
                    type: ArtworkType.AUDIO,
                    artworkHeight: double.infinity,
                    artworkWidth: double.infinity,
                    nullArtworkWidget: const Icon(
                      Icons.music_note,
                      size: 48,
                      color: whiteColor,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Obx(
                  () => Column(
                    children: [
                      Text(
                        data[conteoller.playIndex.value].displayNameWOExt,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: ourStyle(
                          color: bgDarkColor,
                          family: bold,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        data[conteoller.playIndex.value].artist.toString(),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: ourStyle(
                          color: bgDarkColor,
                          family: regular,
                          size: 18,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Obx(
                        () => Row(
                          children: [
                            Text(
                              conteoller.position.value,
                              style: ourStyle(color: bgDarkColor),
                            ),
                            Expanded(
                                child: Slider(
                              thumbColor: sliderColor,
                              inactiveColor: bgColor,
                              activeColor: sliderColor,
                              min: const Duration(seconds: 0)
                                  .inSeconds
                                  .toDouble(),
                              max: conteoller.value.value,
                              value: conteoller.value.value,
                              onChanged: (newValue) {
                                conteoller
                                    .changeDurationToSeconds(newValue.toInt());
                                newValue = newValue;
                              },
                            )),
                            Text(
                              conteoller.duration.value,
                              style: ourStyle(color: bgDarkColor),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: () {
                              conteoller.playSong(
                                data[conteoller.playIndex.value - 1].uri,
                                [conteoller.playIndex.value - 1],
                              );
                            },
                            icon: const Icon(
                              Icons.skip_previous_rounded,
                              size: 60,
                              color: bgDarkColor,
                            ),
                          ),
                          Obx(
                            () => CircleAvatar(
                              radius: 35,
                              backgroundColor: bgDarkColor,
                              child: Transform.scale(
                                scale: 1,
                                child: IconButton(
                                  onPressed: () {
                                    if (conteoller.isPlaying.value) {
                                      conteoller.audioPlayer.pause();
                                      conteoller.isPlaying(false);
                                    } else {
                                      conteoller.audioPlayer.play();
                                      conteoller.isPlaying(true);
                                    }
                                  },
                                  icon: conteoller.isPlaying.value
                                      ? const Icon(
                                          Icons.pause,
                                          size: 55,
                                          color: whiteColor,
                                        )
                                      : const Icon(
                                          Icons.play_arrow_rounded,
                                          size: 55,
                                          color: whiteColor,
                                        ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              conteoller.playSong(
                                  data[conteoller.playIndex.value + 1].uri,
                                  [conteoller.playIndex.value + 1]);
                            },
                            icon: const Icon(
                              Icons.skip_next_rounded,
                              size: 60,
                              color: bgDarkColor,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
