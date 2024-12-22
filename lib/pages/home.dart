import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../consts/colors.dart';
import '../consts/text_style.dart';
import '../controllers/player_controller.dart';

import '../widgets/app_bar.dart';
import '../widgets/float_botton.dart';
import 'player.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //--
  double xOffset = 0;
  double yOffset = 0;
  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());

    return Scaffold(
      floatingActionButton: FloatBotton(controller: controller),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.transparent,
      body: AnimatedContainer(
        transform: Matrix4.translationValues(xOffset, yOffset, 0)
          ..scale(isDrawerOpen ? 0.85 : 1.00)
          ..rotateZ(isDrawerOpen ? -50 : 0),
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: bgDarkColor,
          borderRadius: isDrawerOpen
              ? BorderRadius.circular(40)
              : BorderRadius.circular(0),
        ),
        child: Scaffold(
          floatingActionButton: FloatBotton(controller: controller),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          backgroundColor: Colors.transparent,
          body: Column(
            children: <Widget>[
              const SizedBox(height: 60),
              //--
              CustomAppBar(
                title: 'Music',
                toggleDrawer: () {
                  setState(() {
                    if (isDrawerOpen) {
                      xOffset = 0;
                      yOffset = 0;
                      isDrawerOpen = false;
                    } else {
                      xOffset = 290;
                      yOffset = 80;
                      isDrawerOpen = true;
                    }
                  });
                },
                isDrawerOpen: isDrawerOpen,
              ),
              Expanded(
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
                            const EdgeInsets.only(left: 10.0, bottom: 10.0),
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
                                        artworkBorder:
                                            BorderRadius.circular(12),
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
                                          if (controller.playIndex.value ==
                                              index) {
                                            if (controller.isPlaying.value) {
                                              controller.audioPlayer.pause();
                                              controller.isPlaying.value =
                                                  false;
                                            } else {
                                              controller.audioPlayer.play();
                                              controller.isPlaying.value = true;
                                            }
                                          } else {
                                            controller.playSong(
                                                snapshot.data![index].uri,
                                                index);
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                Colors.white.withOpacity(0.1),
                                          ),
                                          child: controller.playIndex.value ==
                                                      index &&
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
                                          duration:
                                              const Duration(milliseconds: 700),
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
            ],
          ),
        ),
      ),
    );
  }
}
