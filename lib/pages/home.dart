import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../consts/colors.dart';
import '../consts/text_style.dart';
import '../controllers/player_controller.dart';

import 'player.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());

    return Scaffold(
      backgroundColor: bgDarkColor,
      appBar: AppBar(
        backgroundColor: bgDarkColor,
        // centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.snackbar(
                "In Progress",
                "This feature is currently being developed. Stay tuned!",
                colorText: Colors.white,
                icon: const Icon(Icons.code_rounded, color: Colors.white),
                isDismissible: true,
                animationDuration: const Duration(milliseconds: 400),
              );
            },
            icon: SvgPicture.asset(
              width: 22,
              height: 22,
              'assets/images/setting.svg',
              colorFilter: const ColorFilter.mode(iconsColor, BlendMode.srcIn),
            ),
          )
        ],
        leading: IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            width: 20,
            height: 20,
            'assets/images/drawer.svg',
            colorFilter: const ColorFilter.mode(iconsColor, BlendMode.srcIn),
          ),
        ),
        title: const Text(
          'Audira',
          style: TextStyle(
              fontSize: 30,
              color: whiteColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'bold'),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<SongModel>>(
          future: controller.audioQuery.querySongs(
            ignoreCase: true,
            orderType: OrderType.ASC_OR_SMALLER,
            sortType: null,
            uriType: UriType.EXTERNAL,
          ),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'There are no audio files.',
                  style: ourStyle(),
                ),
              );
            } else {
              return Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, left: 10.0, bottom: 10.0),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          child: Obx(
                            () => ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              title: Text(
                                snapshot.data![index].displayNameWOExt,
                                style: ourStyle(
                                  family: bold,
                                  size: 15,
                                ),
                              ),
                              subtitle: Text(
                                "${snapshot.data![index].artist}",
                                style: ourStyle(
                                  family: bold,
                                  size: 12,
                                ),
                              ),
                              leading: QueryArtworkWidget(
                                artworkBorder: BorderRadius.circular(12),
                                id: snapshot.data![index].id,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: const Icon(
                                  Icons.music_note,
                                  color: whiteColor,
                                  size: 50,
                                ),
                              ),
                              trailing: GestureDetector(
                                onTap: () {
                                  if (controller.playIndex.value == index) {
                                    if (controller.isPlaying.value) {
                                      controller.audioPlayer.pause();
                                      controller.isPlaying.value = false;
                                    } else {
                                      controller.audioPlayer.play();
                                      controller.isPlaying.value = true;
                                    }
                                  } else {
                                    controller.playSong(
                                        snapshot.data![index].uri, index);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                  child: controller.playIndex.value == index &&
                                          controller.isPlaying.value
                                      ? const Icon(
                                          Icons.pause,
                                          color: whiteColor,
                                          size: 26,
                                        )
                                      : const Icon(
                                          Icons.play_arrow_rounded,
                                          color: whiteColor,
                                          size: 26,
                                        ),
                                ),
                              ),
                              onTap: () {
                                controller.playSong(
                                  snapshot.data![index].uri,
                                  index,
                                );
                                Get.to(
                                  () => Player(data: snapshot.data!),
                                  transition: Transition.downToUp,
                                  fullscreenDialog: false,
                                  duration: const Duration(milliseconds: 700),
                                );
                              },
                            ),
                          ),
                        ),
                        const Divider(
                          color: iconsColor,
                          thickness: 1,
                          indent: 72,
                        ),
                      ],
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
