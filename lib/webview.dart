import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:thetellercheckout/appbrowser.dart';

class CheckoutView extends ChromeSafariBrowser {
  CheckoutView() : super(bFallback: CheckoutAppBrowser());

  // @override
  // void onOpened() {
  //   print("ChromeSafari browser opened");
  // }

  // @override
  // void onCompletedInitialLoad() {
  //   print("ChromeSafari browser initial load completed");
  // }

  // @override
  // void onClosed() {
  //   print("ChromeSafari browser closed");
  // }
}
