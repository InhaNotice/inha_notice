/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-02-10
 */
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/widgets/themed_snackbar.dart';
import 'package:logger/logger.dart';
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
  InAppWebViewController? _webViewController;
  final logger = Logger();

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

  /// **현재 페이지 공유하기**
  Future<void> _shareUrl(String url) async {
    final Uri uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    /// iOS는 url_launcher 방식 사용
    if (Platform.isIOS) {
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
    } else {
      /// Android는 flutter_inappwebview 사용
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          centerTitle: true,
          title: Text(
            widget.url,
            style: TextStyle(
              fontFamily: Font.kDefaultFont,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).textTheme.bodyMedium?.color ??
                  Theme.of(context).defaultColor,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: () async {
                if (_webViewController != null) {
                  WebUri? currentUrl = await _webViewController?.getUrl();
                  if (currentUrl != null) {
                    await _shareUrl(currentUrl.toString());
                  }
                }
              },
            ),
          ],
        ),
        body: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(widget.url)),
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            supportZoom: true, // 줌 활성화
            useOnDownloadStart: true, // 다운로드 이벤트 활성화
            allowsInlineMediaPlayback: true,
          ),
          onWebViewCreated: (controller) {
            _webViewController = controller;
          },
          onDownloadStartRequest: (controller, request) async {
            final Uri uri = Uri.parse(request.url.toString());
            try {
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                throw Exception();
              }
            } catch (e) {
              logger.e('InAppWebPage - 파일 다운로드 실패: $e');
            }
          },
        ),
      );
    }
  }
}
