import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NoticePage extends StatelessWidget {
  final String url;

  const NoticePage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    // WebViewController 생성
    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // JavaScript 활성화
      ..setBackgroundColor(const Color(0x00000000)) // 투명 배경
      ..loadRequest(Uri.parse(url)); // 초기 URL 로드

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notice'),
      ),
      body: WebViewWidget(controller: controller), // WebView 위젯
    );
  }
}