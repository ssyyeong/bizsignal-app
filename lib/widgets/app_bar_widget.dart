import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButton;

  const AppBarWidget({
    super.key,
    required this.title,
    required this.isBackButton,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        widget.title,
        style: TextStyle(
          color: AppColors.gray900,
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
      leading:
          widget.isBackButton
              ? Padding(
                padding: const EdgeInsets.only(left: 16, top: 13, bottom: 13),
                child: SvgPicture.asset(
                  'assets/images/icon/arrow_back.svg',
                  width: 24,
                  height: 24,
                ),
              )
              : null,
      leadingWidth: 48, 
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
    );
  }
}
