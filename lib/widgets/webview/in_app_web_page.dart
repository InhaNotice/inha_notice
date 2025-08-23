/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2025-08-23
 */

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/widgets/themed_widgets/themed_snack_bar.dart';
import 'package:logger/logger.dart';
import 'package:share_plus/share_plus.dart';
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
  bool _isDesktopMode = false;

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
        ThemedSnackBar.failSnackBar(context, '웹 페이지 로딩에 실패하였습니다.');
      }
    } finally {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  /// **현재 페이지 공유하기**
  Future<void> _shareUrl(String url) async {
    await Share.share(url);
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: Font.kDefaultFont,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).textTheme.bodyMedium?.color ??
                  Theme.of(context).defaultThemedTextColor,
            ),
          ),
          actions: [
            // 데스크탑 및 모바일 전환 버튼
            IconButton(
              icon: Icon(_isDesktopMode
                  ? Icons.desktop_windows_outlined
                  : Icons.phone_iphone_outlined),
              onPressed: () async {
                setState(() {
                  _isDesktopMode = !_isDesktopMode;
                });

                // 데스크탑 모드일 때 User-Agent 변경
                await _webViewController?.loadUrl(
                  urlRequest: URLRequest(
                    url: WebUri(widget.url),
                    headers: {
                      'User-Agent': _isDesktopMode
                          ? 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
                          : '',
                    },
                  ),
                );

                if (mounted) {
                  ThemedSnackBar.succeedSnackBar(
                    context,
                    _isDesktopMode ? '데스크탑 모드로 전환되었습니다.' : '모바일 모드로 전환되었습니다.',
                  );
                }
              },
            ),
            // 공유 버튼
            IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: () async {
                if (_webViewController != null) {
                  await _shareUrl(widget.url);
                }
              },
            ),
          ],
        ),
        body: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(widget.url)),
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            supportZoom: true,
            useOnDownloadStart: true,
            allowsInlineMediaPlayback: true,
          ),
          onWebViewCreated: (controller) {
            _webViewController = controller;
          },
          onLoadStop: (controller, url) async {
            // 데스크탑 모드일 때 강제로 PC 뷰포트로 변경
            if (_isDesktopMode) {
              double screenWidth = MediaQuery.of(context).size.width;
              int desktopWidth =
                  screenWidth < 1200 ? 1200 : screenWidth.toInt();

              await controller.evaluateJavascript(source: """
      document.querySelector('meta[name="viewport"]').setAttribute('content', 'width=$desktopWidth');
    """);
            }

            // 웹페이지 좌우 여백 추가
            await controller.evaluateJavascript(source: """
    document.body.style.paddingLeft = '16px';
    document.body.style.paddingRight = '16px';
    document.body.style.boxSizing = 'border-box';
  """);
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
