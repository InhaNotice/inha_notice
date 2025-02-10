/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-02-10
 */
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WebPage extends StatelessWidget {
  final String url;

  const WebPage({super.key, required this.url});

  Future<void> _launchInAppWebView(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        launchUrl(
          uri,
          mode: LaunchMode.inAppWebView,
          webViewConfiguration: const WebViewConfiguration(
            enableJavaScript: true,
          ),
        );
      } else {
        throw Exception("Could not launch the URL: $url");
      }
    } catch (e) {
      // 예외 처리: 에러 발생 시 사용자에게 알림
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to open URL: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // URL이 열리지 않아도 현재 화면 닫기
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
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
          // URL이 열렸으면 빈 화면 반환
          return const SizedBox.shrink();
        }
      },
    );
  }
}
