import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../consts/colors.dart';
import '../controllers/nav_bar_controller.dart';
import '../pages/albums_screen.dart';
import '../pages/home.dart';
import '../pages/playlist_screen.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NavBarController navBarController = Get.put(NavBarController());
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth * 0.3;

    return Container(
      padding: EdgeInsets.only(left: 25, top: 15, bottom: 15),
      color: Colors.transparent,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                navBarController.setSelectedIndex(0);
                Get.to(
                  () => PlaylistScreen(),
                );
              },
              child: Obx(() {
                return Container(
                  decoration: BoxDecoration(
                    color: navBarController.selectedIndex.value == 0
                        ? whiteColor
                        : whiteColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  height: 55,
                  width: containerWidth,
                  child: Center(
                    child: Text(
                      'Playlists',
                      style: TextStyle(
                        fontSize: 16,
                        color: navBarController.selectedIndex.value == 0
                            ? bgDarkColor
                            : whiteColor,
                        fontFamily: 'bold',
                      ),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(width: 20),
            GestureDetector(
              onTap: () {
                navBarController.setSelectedIndex(1);
                Get.to(() => Home());
              },
              child: Obx(() {
                return Container(
                  decoration: BoxDecoration(
                    color: navBarController.selectedIndex.value == 1
                        ? whiteColor
                        : whiteColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  height: 55,
                  width: containerWidth,
                  child: Center(
                    child: Text(
                      'Home',
                      style: TextStyle(
                        fontSize: 16,
                        color: navBarController.selectedIndex.value == 1
                            ? bgDarkColor
                            : whiteColor,
                        fontFamily: 'bold',
                      ),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(width: 20),
            GestureDetector(
              onTap: () {
                navBarController.setSelectedIndex(2);
                Get.to(() => AlbumsScreen());
              },
              child: Obx(() {
                return Container(
                  decoration: BoxDecoration(
                    color: navBarController.selectedIndex.value == 2
                        ? whiteColor
                        : whiteColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  height: 55,
                  width: containerWidth,
                  child: Center(
                    child: Text(
                      'Albums',
                      style: TextStyle(
                        fontSize: 16,
                        color: navBarController.selectedIndex.value == 2
                            ? bgDarkColor
                            : whiteColor,
                        fontFamily: 'bold',
                      ),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
