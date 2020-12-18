library thetellercheckout;

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:thetellercheckout/inappwebview.dart';
import 'package:thetellercheckout/loader.dart';
import 'package:thetellercheckout/webview.dart';
import 'dart:convert' as convert;

Uri redirect;
String merchantProdKey;
String merchantTestKey;
String merchantId;
String apiuser;
String dialogtitle = "Checkout";
bool production = false;
bool useWebView = true;
String defaultcurrency = "GHS";

class TheTellerCheckout {
  final String _liveEndPoint = "https://checkout.theteller.net/initiate";
  final String _testEndPoint = "https://test.theteller.net/checkout/initiate";

  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;

  static void init(
      {@required Uri redirectURL,
      @required String apiProdKey,
      @required String apiTestKey,
      @required String merchantID,
      @required String apiUser,
      String dialogTitle,
      @required bool isProduction,
      bool useWebview}) {
    assert(redirectURL != null &&
        apiProdKey != null &&
        apiTestKey != null &&
        merchantID != null &&
        apiUser != null);

    redirect = redirectURL;
    merchantProdKey = apiProdKey;
    merchantTestKey = apiTestKey;
    merchantId = merchantID;
    apiuser = apiUser;
    if (isProduction != null) production = isProduction;
    if (dialogTitle != null) dialogtitle = dialogTitle;
    if (useWebview != null) useWebView = useWebview;
  }

  void initializeCheckout(
    BuildContext context, {
    @required String transactionID,
    @required double amount,
    @required String description,
    @required String customerEmail,
    String paymentMethod,
    String currency,
    void Function(Map<String, dynamic> data) callback,
  }) async {
    if (!useWebView) assert(callback != null);
    showLoader(context);
    http.Response res = await talkToServer({
      "transaction_id": transactionID,
      "amount": minorUnit(amount),
      "desc": description,
      "email": customerEmail,
      "redirect_url": redirect.toString(),
      "merchant_id": merchantId,
      "currency": currency ?? defaultcurrency,
      "payment_method": paymentMethod ?? "both"
    });
    if (Navigator.canPop(context)) Navigator.pop(context);
    if (res.statusCode >= 200 && res.statusCode <= 299) {
      Map<String, dynamic> data = convert.jsonDecode(res.body);
      if (data["status"] != "success")
        callback(data);
      else if (useWebView)
        await __launchWebView2(context, data["checkout_url"], callback);
      else
        await __launchWebView(data["checkout_url"]);
    } else
      throw Exception(res.body);
  }

  String minorUnit(double amount) {
    assert(amount != null);
    String strAmt = (amount * 100).round().toString();
    return ("0" * (12 - strAmt.length)) + strAmt;
  }

  Future<http.Response> talkToServer(Map<String, dynamic> payload) async {
    return await http.post(production ? this._liveEndPoint : this._testEndPoint,
        headers: {
          "Authorization": "Basic " +
              convert.base64Encode(convert.utf8.encode(
                  '$apiuser:${production ? merchantProdKey : merchantTestKey}')),
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: convert.jsonEncode(payload));
  }

  // void _checkTransactionStatus(String id, Function callback) async {
  //   http.Response res = await http.get(
  //       "https://prod.theteller.net/v1.1/users/transactions/$id/status",
  //       headers: {
  //         "Merchant-Id": merchantId,
  //         "Content-Type": "application/json",
  //         "Accept": "application/json",
  //         "Cache-Control": "no-cache"
  //       });
  //   if (res.statusCode >= 200 && res.statusCode <= 299) {
  //     Map<String, dynamic> data = convert.jsonDecode(res.body);
  //     if (data["status"] != "pending")
  //       callback(data);
  //     else {
  //       print(data);
  //       _checkTransactionStatus(id, callback);
  //     }
  //   }
  // }

  Future __launchWebView2(BuildContext context, String url,
      void Function(Map<String, dynamic> payload) callback) async {
    if (Platform.isAndroid) {
      showDialog(
          context: context,
          builder: (c) => CustomWebView(
                title: dialogtitle,
                url: url,
                onLoadFinish: callback,
                watch: redirect,
              ));
    } else {
      showCupertinoModalPopup(
          context: context,
          builder: (c) => CustomWebView(
                url: url,
                onLoadFinish: callback,
                watch: redirect,
              ));
    }
  }

  void showLoader(BuildContext context) {
    if (Platform.isAndroid) {
      showDialog(context: context, builder: (c) => LoadingWidget());
    } else {
      showCupertinoDialog(context: context, builder: (c) => LoadingWidget());
    }
  }

  Future<ChromeSafariBrowser> __launchWebView(String url) async {
    final ChromeSafariBrowser browser = CheckoutView();
    await browser.open(
        url: url,
        options: ChromeSafariBrowserClassOptions(
            android: AndroidChromeCustomTabsOptions(
                addDefaultShareMenuItem: false, keepAliveEnabled: true),
            ios: IOSSafariOptions(
                dismissButtonStyle: IOSSafariDismissButtonStyle.CLOSE,
                presentationStyle:
                    IOSUIModalPresentationStyle.OVER_FULL_SCREEN)));
    return browser;
  }
}
