import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(WebApp());
}
class WebApp extends StatefulWidget {
  const WebApp({super.key});

  @override
  State<WebApp> createState() => _WebAppState();
}

class _WebAppState extends State<WebApp> {
  late WebViewController controller;
  @override
  void initState() {
    super.initState();
    controller=WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://bdmall.com.bd'));
  }
  Future<bool> _onWillPop() async {
    if (await controller.canGoBack()) {
      controller.goBack();
      return Future.value(false); // Prevent app from closing
    }
    return Future.value(true); // Allow the app to close if no back history
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            // appBar: AppBar(
            //   centerTitle: true,
            //   title: Text('Flutter Webview'),
            // ),
            body: WebViewWidget(controller: controller)
          ),
        ),
      ),
    )
    ;
  }
}
