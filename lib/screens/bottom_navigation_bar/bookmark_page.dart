import 'package:flutter/material.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('북마크')),
      body: const Center(
        child: Text('북마크 화면'),
      ),
    );
  }
}