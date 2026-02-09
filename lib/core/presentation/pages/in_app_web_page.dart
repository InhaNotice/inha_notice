/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-09
 */

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/core/config/app_theme.dart';
import 'package:inha_notice/core/presentation/utils/app_snack_bar.dart';
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
  final Logger logger = Logger();
  bool _isDesktopMode = false;
  bool _isTransitionComplete = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 450), () {
      if (mounted) {
        setState(() {
          _isTransitionComplete = true;
        });
      }
    });
  }

  /// **현재 페이지 공유하기**
  Future<void> _shareUrl(String url) async {
    await Share.share(url);
  }

  /// **데스크탑/모바일 모드 전환 로직**
  Future<void> _toggleDesktopMode() async {
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
      AppSnackBar.success(
        context,
        _isDesktopMode ? '데스크탑 모드로 전환되었습니다.' : '모바일 모드로 전환되었습니다.',
      );
    }
  }

  /// **웹 페이지 로드 완료 시 JS 주입 (뷰포트 및 스타일 설정)**
  Future<void> _injectViewportAndStyle(
      InAppWebViewController controller) async {
    // 데스크탑 모드일 때 강제로 PC 뷰포트로 변경
    if (_isDesktopMode) {
      double screenWidth = MediaQuery.of(context).size.width;
      int desktopWidth = screenWidth < 1200 ? 1200 : screenWidth.toInt();

      await controller.evaluateJavascript(source: """
        document.querySelector('meta[name="viewport"]').setAttribute('content', 'width=$desktopWidth');
      """);
    } else {
      await controller.evaluateJavascript(source: """
        var meta = document.querySelector('meta[name="viewport"]');
        var content = 'width=device-width, initial-scale=0.90, minimum-scale=0.1, maximum-scale=5.0, user-scalable=yes';
        
        if (meta) {
          meta.setAttribute('content', content);
        } else {
          var newMeta = document.createElement('meta');
          newMeta.name = "viewport";
          newMeta.content = content;
          document.head.appendChild(newMeta);
        }
      """);
    }

    // 웹페이지 좌우 여백 추가
    await controller.evaluateJavascript(source: """
      document.body.style.paddingLeft = '16px';
      document.body.style.paddingRight = '16px';
      document.body.style.boxSizing = 'border-box';
    """);
  }

  /// **파일 다운로드 요청 처리**
  Future<void> _handleDownloadStart(
      InAppWebViewController controller, DownloadStartRequest request) async {
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
  }

  /// **AppBar 위젯 구성**
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      centerTitle: true,
      title: Text(
        widget.url,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: AppFont.pretendard.family,
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
          onPressed: _toggleDesktopMode,
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
    );
  }

  /// **로딩 화면 위젯 구성**
  Widget _buildLoadingView() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }

  /// **웹뷰 위젯 구성**
  Widget _buildWebView() {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(widget.url)),
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        useOnDownloadStart: true,
        allowsInlineMediaPlayback: true,
        supportZoom: true,
        builtInZoomControls: true,
        displayZoomControls: false,
      ),
      onWebViewCreated: (controller) {
        _webViewController = controller;
      },
      onLoadStop: (controller, url) async {
        await _injectViewportAndStyle(controller);
      },
      onDownloadStartRequest: _handleDownloadStart,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: !_isTransitionComplete ? _buildLoadingView() : _buildWebView(),
    );
  }
}
