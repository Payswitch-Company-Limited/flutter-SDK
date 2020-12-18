import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CheckoutAppBrowser extends InAppBrowser {
  @override
  Future onLoadStart(String url) async {
    print("\n\nStarted $url\n\n");
    // print(
    //     'Checkout url match :: ${watch.toString().contains(Uri.dataFromString(url).host)}');
  }

  @override
  Future onLoadStop(String url) async {
    print("\n\nStopped $url\n\n");
    // print(
    //     'Checkout url match :: ${watch.toString().contains(Uri.dataFromString(url).host)}');
    // if (watch.toString().contains(Uri.dataFromString(url).host)) {
    //   Uri currentUri = Uri(host: url);
    //   Map<String, dynamic> data = {
    //     "code": currentUri.queryParameters['code'],
    //     "status": currentUri.queryParameters['status'],
    //     "reason": currentUri.queryParameters['reason'],
    //     "transaction_id": currentUri.queryParameters['transaction_id']
    //   };

    //   this.onLoadFinish(data);
    // }
  }

  @override
  void onLoadError(String url, int code, String message) {
    print("\n\nCan't load $url.. Error: $message\n\n");
  }

  @override
  void onExit() {
    print("\n\nBrowser closed!\n\n");
  }
}
