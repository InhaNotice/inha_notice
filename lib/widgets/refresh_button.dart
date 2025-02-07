import 'package:flutter/material.dart';

/// **RefreshButton**
/// 이 클래스는 새로고침 버튼을 제공하는 클래스입니다.
class RefreshButton extends StatelessWidget {
  final VoidCallback onTap;

  const RefreshButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border:
              Border.all(color: Theme.of(context).iconTheme.color!, width: 2.0),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Icon(
          Icons.refresh,
          color: Theme.of(context).iconTheme.color,
          size: 16.0,
        ),
      ),
    );
  }
}
