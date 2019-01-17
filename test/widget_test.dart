//Test currently empty until I track down any keyboard tests in the Fuchsia source.

import 'package:flutter_test/flutter_test.dart';
import 'package:fuchsia_keyboard/ime_keyboard.dart';

void main() {
  testWidgets('Test keyboard widget', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(ImeKeyboard());
  });
}
