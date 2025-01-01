import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NoticePage extends StatelessWidget {
  final String url;

  const NoticePage({super.key, required this.url});

  Future<void> _launchInAppWebView(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);

    // In-App WebView를 사용하여 URL 열기
    if (!await launchUrl(
      uri,
      mode: LaunchMode.inAppWebView, // 앱 내에서 브라우저 열기
      webViewConfiguration: const WebViewConfiguration(
        enableJavaScript: true, // JavaScript 활성화
      ),
    )) {
      throw Exception('Could not launch $url');
    }

    // URL이 열리고 나면 현재 페이지를 닫음
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _launchInAppWebView(url, context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Text('Failed to open URL: ${snapshot.error}'),
            ),
          );
        } else {
          // URL이 열렸으면 자동으로 뒤로 가게 하기
          return const SizedBox.shrink();
        }
      },
    );
  }
}