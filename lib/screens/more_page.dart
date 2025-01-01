import 'package:flutter/material.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('더보기')),
      body: const Center(
        child: Text('더보기 화면'),
      ),
    );
  }
}