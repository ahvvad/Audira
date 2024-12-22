import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../consts/colors.dart';
import '../consts/text_style.dart';
import '../controllers/player_controller.dart';
import '../widgets/app_bar.dart';
import '../widgets/float_botton.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  //--
  double xOffset = 0;
  double yOffset = 0;
  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    return Scaffold(
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
                child: Center(
                  child: Text(
                    'This section is currently being developed. \nStay tuned for updates!',
                    style:
                        ourStyle(family: regular, color: whiteColor, size: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
