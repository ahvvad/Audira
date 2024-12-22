import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../consts/colors.dart';

class CustomAppBar extends StatefulWidget {
  final VoidCallback toggleDrawer;
  final bool isDrawerOpen;
  final String title;

  const CustomAppBar({
    Key? key,
    required this.toggleDrawer,
    required this.isDrawerOpen, required this.title,
  }) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: widget.toggleDrawer,
              icon: widget.isDrawerOpen
                  ? const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: iconsColor,
                    )
                  : SvgPicture.asset(
                      width: 20,
                      height: 20,
                      'assets/icons/drawer.svg',
                      colorFilter: const ColorFilter.mode(
                          iconsColor, BlendMode.srcIn),
                    ),
            ),
             Text(
              widget.title,
              style: TextStyle(
                fontSize: 30,
                color: whiteColor,
                fontWeight: FontWeight.bold,
                fontFamily: 'bold',
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            Get.snackbar(
              "In Progress",
              "This feature is currently being developed. Stay tuned!",
              colorText: Colors.white,
              icon: const Icon(Icons.code_rounded, color: Colors.green),
              isDismissible: true,
              animationDuration: const Duration(milliseconds: 400),
            );
          },
          icon: SvgPicture.asset(
            width: 22,
            height: 22,
            'assets/icons/setting.svg',
            colorFilter: const ColorFilter.mode(iconsColor, BlendMode.srcIn),
          ),
        )
      ],
    );
  }
}
