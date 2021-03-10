import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CheckoutAppBrowser extends InAppBrowser {
  @override
  Future onLoadStart(url) async {
    print("\n\nStarted $url\n\n");
  }

  @override
  Future onLoadStop(url) async {
    print("\n\nStopped $url\n\n");
  }

  @override
  void onLoadError(url, code, message) {
    print("\n\nCan't load $url.. Error: $message\n\n");
  }

  @override
  void onExit() {
    print("\n\nBrowser closed!\n\n");
  }
}
