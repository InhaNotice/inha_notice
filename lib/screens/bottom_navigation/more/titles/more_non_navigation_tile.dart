import 'package:flutter/material.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/themes/theme.dart';

class MoreNonNavigationTile extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;

  const MoreNonNavigationTile(
      {super.key,
      required this.title,
      required this.description,
      required this.icon});

  @override
  State<MoreNonNavigationTile> createState() => _MoreNonNavigationTileState();
}

class _MoreNonNavigationTileState extends State<MoreNonNavigationTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(widget.icon,
                  size: 20, color: Theme.of(context).iconTheme.color),
              const SizedBox(width: 8),
              Text(
                widget.title,
                style: TextStyle(
                  fontFamily: Font.kDefaultFont,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).textTheme.bodyMedium?.color ??
                      Theme.of(context).defaultColor,
                ),
              ),
            ],
          ),
          Text(
            widget.description,
            style: TextStyle(
              fontFamily: Font.kDefaultFont,
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Theme.of(context).textTheme.bodyMedium?.color ??
                  Theme.of(context).defaultColor,
            ),
          ),
        ],
      ),
    );
  }
}
