import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:io';

import 'package:thetellercheckout/loader.dart';

class CustomWebView extends StatefulWidget {
  final Function onLoadFinish;
  final Uri watch;
  final String url;
  final String title;
  CustomWebView({this.title, this.url, this.onLoadFinish, this.watch});

  @override
  _CustomWebViewState createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  InAppWebViewController webView;
  bool showLoader = true;
  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: closeCheckout,
              ),
            ),
            body: Container(
              child: Stack(
                  children: [_getWebView, if (showLoader) LoadingWidget()]),
            ),
          )
        : CupertinoPageScaffold(
            child: Container(
              child: Stack(
                  children: [_getWebView, if (showLoader) LoadingWidget()]),
            ),
            navigationBar: CupertinoNavigationBar(
              middle: Text(widget.title),
              leading: CupertinoButton(
                onPressed: closeCheckout,
                child: Icon(CupertinoIcons.clear),
              ),
            ),
          );
  }

  void closeCheckout() {
    Map<String, dynamic> data = {
      "code": -999,
      "status": "userClosed",
      "reason": "User closed",
      "transaction_id": ""
    };
    widget.onLoadFinish(data);
    if (Navigator.canPop(context)) Navigator.pop(context);
  }

  get _getWebView {
    return InAppWebView(
      initialUrl: this.widget.url,
      initialHeaders: {},
      initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
        debuggingEnabled: false,
      )),
      onWebViewCreated: (InAppWebViewController controller) {
        webView = controller;
      },
      onLoadStart: (InAppWebViewController controller, String url) {
        if (!showLoader)
          setState(() {
            showLoader = true;
          });
        if (url.startsWith(widget.watch.toString())) {
          Uri currentUri = Uri.dataFromString(url);
          Map<String, dynamic> data = {
            "code": currentUri.queryParameters['code'],
            "status": currentUri.queryParameters['status'],
            "reason": currentUri.queryParameters['reason'],
            "transaction_id": currentUri.queryParameters['transaction_id']
          };
          widget.onLoadFinish(data);
          if (Navigator.canPop(context)) Navigator.pop(context);
        }
      },
      onLoadStop: (InAppWebViewController controller, String url) async {
        setState(() {
          showLoader = false;
        });
      },
      onProgressChanged: (InAppWebViewController controller, int progress) {
        // setState(() {
        //   this.progress = progress / 100;
        // });
      },
    );
  }
}
