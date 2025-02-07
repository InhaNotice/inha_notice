import 'package:flutter/material.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/themes/theme.dart';

/// **ThemedAppBar**
/// 이 클래스는 화이트/다크모드가 적용된 AppBar 클래스입니다.
class ThemedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double titleSize;
  final bool isCenter;

  const ThemedAppBar({
    super.key,
    required this.title,
    required this.titleSize,
    required this.isCenter,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      centerTitle: isCenter,
      title: Text(
        title,
        style: TextStyle(
          fontFamily: Font.kDefaultFont,
          fontWeight: FontWeight.bold,
          fontSize: titleSize,
          color: Theme.of(context).textTheme.bodyMedium?.color ??
              Theme.of(context).defaultColor,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
