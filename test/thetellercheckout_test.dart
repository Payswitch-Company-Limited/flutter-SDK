import 'package:flutter_test/flutter_test.dart';

import 'package:thetellercheckout/thetellercheckout.dart';

void main() {
  test('adds one to input values', () {
    final calculator = TheTellerCheckout();
    expect(calculator.minorUnit(20.5).length, 12);
    // expect(() => calculator.minorUnit(null), isAssertionError);
  });
}
