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
import 'package:inha_notice/widgets/themed_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

/// **WebPage**
/// 이 클래스는 인앱 웹페이지를 구현하는 클래스입니다.
class InAppWebPage extends StatefulWidget {
  final String url;

  const InAppWebPage({super.key, required this.url});

  @override
  State<InAppWebPage> createState() => _InAppWebPageState();
}

class _InAppWebPageState extends State<InAppWebPage> {
  /// **url를 입력받아 웹 페이지를 로딩**
  Future<void> _launchInAppWebView(String url) async {
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
        throw Exception();
      }
    } catch (e) {
      if (mounted) {
        ThemedSnackbar.showSnackbar(context, '웹 페이지 로딩에 실패하였습니다.');
      }
    } finally {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _launchInAppWebView(widget.url),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Text('URL을 연결할 수 없습니다: ${snapshot.error}'),
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
