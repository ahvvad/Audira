import 'package:audio_player/controllers/player_controller.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../consts/colors.dart';
import 'package:flutter/material.dart';
import '../consts/text_style.dart';
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
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: whiteColor,
            ),
          )
        ],
        leading: const Icon(
          Icons.sort_rounded,
          color: whiteColor,
        ),
        title: Text(
          'Audira',
          style: ourStyle(
            family: bold,
            size: 18,
          ),
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
                  'No Song Found',
                  style: ourStyle(),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Obx(
                        () => ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          tileColor: bgColor,
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
                              family: regular,
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
                              size: 32,
                            ),
                          ),
                          trailing: controller.playIndex.value == index &&
                                  controller.isPlaying.value
                              ? const Icon(
                                  Icons.pause,
                                  color: whiteColor,
                                  size: 26,
                                )
                              : const Icon(
                                  Icons.play_arrow,
                                  color: whiteColor,
                                  size: 26,
                                ),
                          onTap: () {
                            controller.playSong(
                              snapshot.data![index].uri,
                              index,
                            );
                            Get.to(
                              () => Player(data: snapshot.data!),
                              transition: Transition.cupertino,
                              fullscreenDialog: false,
                              duration: const Duration(milliseconds: 900),
                            );
                          },
                        ),
                      ),
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
