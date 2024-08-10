import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doodle_app/main.dart';

void main() {
  testWidgets('Doodle screen with dynamic tools test',
      (WidgetTester tester) async {
    // Build the Doodle app and trigger a frame.
    await tester.pumpWidget(DoodleApp());

    // Verify that the AppBar title is correct.
    expect(find.text('Doodle App'), findsOneWidget);

    // Ensure the GestureDetector and canvas area is rendered.
    expect(find.byType(GestureDetector), findsOneWidget);

    // Verify initial state of pen size and eraser.
    expect(find.byType(Slider), findsOneWidget);
    expect(
        find.byType(Image), findsOneWidget); // Check for the custom eraser icon

    // Simulate drawing with default black color and pen size.
    await tester.drag(find.byType(GestureDetector), Offset(100, 100));
    await tester.pumpAndSettle();

    // Verify the presence of color buttons.
    expect(find.byIcon(Icons.brush), findsNWidgets(4));

    // Change pen color to red.
    await tester.tap(find.byIcon(Icons.brush).at(1));
    await tester.pumpAndSettle();

    // Simulate drawing with red color.
    await tester.drag(find.byType(GestureDetector), Offset(50, 50));
    await tester.pumpAndSettle();

    // Change pen size.
    await tester.drag(find.byType(Slider), Offset(20, 0));
    await tester.pumpAndSettle();

    // Activate eraser.
    await tester.tap(find.byType(Image)); // Simulate tapping on the eraser icon
    await tester.pumpAndSettle();

    // Draw with eraser.
    await tester.drag(find.byType(GestureDetector), Offset(150, 150));
    await tester.pumpAndSettle();

    // Check that the canvas is still present (i.e., the app didn't crash).
    expect(find.byType(GestureDetector), findsOneWidget);
  });
}
