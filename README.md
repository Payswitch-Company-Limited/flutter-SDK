# TheTellerCheckout (Flutter package)
Flutter package for calling the TheTeller Checkout [Android & IOS]

## Getting Started

- Add the package to your pubspec.yaml
    ```yaml
    dependencies:
    flutter:
        sdk: flutter
    thetellercheckout:
        git:
            url: git://github.com/Payswitch-Company-Limited/flutter-SDK.git
            ref: main
   ```
- Import the package
 
    ```dart
        import 'package:thetellercheckout/thetellercheckout.dart';
    ```
- Initialize the package Configure and config your checkout. open <ins> lib/main.dart </ins>

 ```dart
    void main() {

    // Initialize the package
    TheTellerCheckout.init(
        apiProdKey: "YOUR LIVE API Key", // Could be gotten from TheTeller Dashboard
        apiTestKey: "YOUR TEST API Key", // Could be gotten from TheTeller Dashboard
        merchantID: "YOUR MERCHANT ID", // Could be gotten from TheTeller Dashboard
        redirectURL: Uri(host: "YOUR REDIRECT URL", scheme: 'https'), // scheme should be https
        isProduction: true, // default to false. When false your Test API key will be used
        useWebview: true, // set to false to use Chrome Custom Tabs on Android / SFSafariViewController on iOS. You will not recieve callback response when false
        apiUser: "YOUR API USER NAME" // Could be gotten from TheTeller Dashboard
        );

    runApp(MyApp());

    }
```
 * TheTellerCheckout.init Paramerters

    |Name | Required | Data type | Description |
    |--- | --- | --- | ---|
    merchantID	| true	| String	| Your merchant ID provided when you create an account.||
    redirect_url	| true	| String	| URL to redirect to when transaction is completed.|
    apiProdKey	| true	| String	| Your merchant API key provided when your accout is profiled to go live.|
    apiTestKey	| true	| String	| Your merchant API key provided when you create an account.|
    apiuser	| true	| String	| Your merchant API Username provided when you create an account.|
    useWebview	| false	| bool default (true)	| set to false to use Chrome Custom Tabs on Android / SFSafariViewController on iOS. You will not receive callback response .|
    isProduction	| false	| bool default (false)	| default to false. When false your Test API key will be used.|
    dialogTitle | false | String default(Checkout) | Title of the checkout View|

    
- Initiate checkout

    ```dart
        TheTellerCheckout checkout = TheTellerCheckout();
        checkout.initializeCheckout(context,
            transactionID: "233243243444",
            amount: 20.3, 
            description: "Test Transaction for flutter package",
            customerEmail: "username@domain.com",
            callback: (Map<String, dynamic> data) {
        print(data);
        });
    ```

 * checkout.initializeCheckout Paramerter

    |Name | Required | Data type | Description|
    |--- | --- | --- | --- |
    transactionID	| true	| string	| Unique transaction reference provided by you and must be 12 digits.|
    description	| true	| string	| Text to be displayed as a short transaction narration.|
    amount	| true	| double	| Amount to charge.|
    currency	| true	| string	| Currency to charge customer in. Defaults to GHS.|
    paumentMethod	| false	| string	| Choose between card or mobile money payment. e.g card, momo, both.|
    customerEmail	| true	| string	| Email of the customer.|
    callback	| true if useWebview = false	| void Functon (Map<String, dynamic>)	| Called when transaction is completed (success/Failed).|


- Programmatically close Checkout

    When you initialize the package with useWebview set to false, your can maually close the checkout by do

    ```dart
        checkout.close() // this will dismiss Chrome Custom Tabs on Android / SFSafariViewController on iOS 
    ```

    When useWebview is set to true, you can do this after receiving callback response

    ```dart
        Navigator.pop(context) // this will dismiss Dialog  
    ```