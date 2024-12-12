import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebView extends StatefulWidget {
  const CustomWebView({required this.initialUrl, required this.header, Key? key, this.cookieManager}) : super(key: key);

  final CookieManager? cookieManager;
  final String initialUrl;
  final String header;

  @override
  State<CustomWebView> createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = AndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar:AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: GradientBoxBorder (gradient:  LinearGradient(colors:[ Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary]), width: 2),
                  borderRadius: BorderRadius.circular(10)
                ),
                child:  SvgPicture.asset(
                  'assets/icons/back.svg',
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(width: 10,),
            Text(
            widget.header,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color:
                  Color.fromARGB(255, 33, 33, 33),
            ),
            ),
          ],
        )
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: WebView(
          initialUrl: widget.initialUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          onProgress: (int progress) {
            print('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },

          gestureNavigationEnabled: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }


}

