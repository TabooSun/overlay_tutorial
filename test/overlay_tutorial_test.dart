import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:overlay_tutorial/overlay_tutorial.dart';

void main() {
  const hintText = 'This is the hello text';
  const helloText = 'Hello';

  testWidgets(
    'OverlayTutorialScope and OverlayTutorialHole works well together.',
    (widgetTester) async {
      final overlayTutorialScope = OverlayTutorialScope(
        enabled: true,
        child: Center(
          child: Column(
            children: [
              OverlayTutorialHole(
                enabled: true,
                overlayTutorialEntry: OverlayTutorialRectEntry(
                  padding: const EdgeInsets.all(16),
                  radius: const Radius.circular(16),
                  overlayTutorialHints: [
                    OverlayTutorialWidgetHint(
                      builder: (context, entryRect) {
                        return const Text(hintText);
                      },
                      position: (rect) => Offset(0, rect.bottom + 16),
                    ),
                  ],
                ),
                child: const Text(helloText),
              ),
            ],
          ),
        ),
      );
      await widgetTester.pumpWidget(
        _wrapMaterialApp(
          child: overlayTutorialScope,
        ),
      );

      await widgetTester.pumpAndSettle();
      expect(find.byWidget(overlayTutorialScope), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(2));
      expect(find.text(helloText), findsOneWidget);
      expect(find.text(hintText), findsOneWidget);
    },
  );

  group(
    'Set enabled to false for OverlayTutorialScope and OverlayTutorialHole works',
    () {
      testWidgets(
        'Set enabled to false for OverlayTutorialScope works.',
        (widgetTester) async {
          final overlayTutorialScope = OverlayTutorialScope(
            enabled: false,
            child: Center(
              child: Column(
                children: [
                  OverlayTutorialHole(
                    enabled: true,
                    overlayTutorialEntry: OverlayTutorialRectEntry(
                      padding: const EdgeInsets.all(16),
                      radius: const Radius.circular(16),
                      overlayTutorialHints: [
                        OverlayTutorialWidgetHint(
                          builder: (context, entryRect) {
                            return const Text(hintText);
                          },
                          position: (rect) => Offset(0, rect.bottom + 16),
                        ),
                      ],
                    ),
                    child: const Text(helloText),
                  ),
                ],
              ),
            ),
          );
          await widgetTester.pumpWidget(
            _wrapMaterialApp(
              child: overlayTutorialScope,
            ),
          );

          await widgetTester.pumpAndSettle();
          expect(find.byWidget(overlayTutorialScope), findsOneWidget);
          expect(find.byType(Text), findsNWidgets(1));
          expect(find.text(helloText), findsOneWidget);
          expect(find.text(hintText), findsNothing);
        },
      );

      testWidgets(
        'Set enabled to false for OverlayTutorialHole works.',
        (widgetTester) async {
          final overlayTutorialScope = OverlayTutorialScope(
            enabled: true,
            child: Center(
              child: Column(
                children: [
                  OverlayTutorialHole(
                    enabled: false,
                    overlayTutorialEntry: OverlayTutorialRectEntry(
                      padding: const EdgeInsets.all(16),
                      radius: const Radius.circular(16),
                      overlayTutorialHints: [
                        OverlayTutorialWidgetHint(
                          builder: (context, entryRect) {
                            return const Text(hintText);
                          },
                          position: (rect) => Offset(0, rect.bottom + 16),
                        ),
                      ],
                    ),
                    child: const Text(helloText),
                  ),
                ],
              ),
            ),
          );
          await widgetTester.pumpWidget(
            _wrapMaterialApp(
              child: overlayTutorialScope,
            ),
          );

          await widgetTester.pumpAndSettle();
          expect(find.byWidget(overlayTutorialScope), findsOneWidget);
          expect(find.byType(Text), findsNWidgets(1));
          expect(find.text(helloText), findsOneWidget);
          expect(find.text(hintText), findsNothing);
        },
      );
    },
  );

  group(
    'OverlayTutorialScope builds hint widget correctly',
    () {
      testWidgets(
        'OverlayTutorialScope builds OverlayTutorialWidgetHint builder of OverlayTutorialCircleEntry',
        (widgetTester) async {
          final overlayTutorialScope = OverlayTutorialScope(
            enabled: true,
            child: Center(
              child: Column(
                children: [
                  OverlayTutorialHole(
                    enabled: true,
                    overlayTutorialEntry: OverlayTutorialCircleEntry(
                      radius: 16.0,
                      overlayTutorialHints: [
                        OverlayTutorialWidgetHint(
                          builder: (context, entryRect) {
                            return const Text(hintText);
                          },
                          position: (rect) => Offset(0, rect.bottom + 16),
                        ),
                      ],
                    ),
                    child: const Text(helloText),
                  ),
                ],
              ),
            ),
          );
          await widgetTester.pumpWidget(
            _wrapMaterialApp(
              child: overlayTutorialScope,
            ),
          );

          await widgetTester.pumpAndSettle();
          expect(find.byWidget(overlayTutorialScope), findsOneWidget);
          expect(find.byType(Text), findsNWidgets(2));
          expect(find.text(helloText), findsOneWidget);
          expect(find.text(hintText), findsOneWidget);
        },
      );

      testWidgets(
        'OverlayTutorialScope builds OverlayTutorialWidgetHint builder of OverlayTutorialCustomShapeEntry',
        (widgetTester) async {
          final overlayTutorialScope = OverlayTutorialScope(
            enabled: true,
            child: Center(
              child: Column(
                children: [
                  OverlayTutorialHole(
                    enabled: true,
                    overlayTutorialEntry: OverlayTutorialCustomShapeEntry(
                      overlayTutorialHints: [
                        OverlayTutorialWidgetHint(
                          builder: (context, entryRect) {
                            return const Text(hintText);
                          },
                          position: (rect) => Offset(0, rect.bottom + 16),
                        ),
                      ],
                      shapeBuilder: (Rect rect, Path path) {
                        path = Path.combine(
                          PathOperation.difference,
                          path,
                          Path()
                            ..addOval(
                              Rect.fromLTWH(
                                rect.left - 16,
                                rect.top,
                                112,
                                64,
                              ),
                            ),
                        );
                        return path;
                      },
                    ),
                    child: const Text(helloText),
                  ),
                ],
              ),
            ),
          );
          await widgetTester.pumpWidget(
            _wrapMaterialApp(
              child: overlayTutorialScope,
            ),
          );

          await widgetTester.pumpAndSettle();
          expect(find.byWidget(overlayTutorialScope), findsOneWidget);
          expect(find.byType(Text), findsNWidgets(2));
          expect(find.text(helloText), findsOneWidget);
          expect(find.text(hintText), findsOneWidget);
        },
      );
    },
  );

  testWidgets(
    'OverlayTutorialScope handles OverlayTutorialWidgetHint state changes correctly',
    (widgetTester) async {
      const hintText2 = 'Hint 2';
      Widget hintBuilderText = const Text(hintText);
      var hasDxOffset = false;
      final overlayTutorialScope = StatefulBuilder(
        builder: (context, setState) {
          return OverlayTutorialScope(
            enabled: true,
            child: Center(
              child: Column(
                children: [
                  OverlayTutorialHole(
                    enabled: true,
                    overlayTutorialEntry: OverlayTutorialRectEntry(
                      padding: const EdgeInsets.all(16),
                      radius: const Radius.circular(16),
                      overlayTutorialHints: [
                        OverlayTutorialWidgetHint(
                          builder: (context, entryRect) {
                            return hintBuilderText;
                          },
                          position: (rect) =>
                              Offset(hasDxOffset ? 16.0 : 0, rect.bottom + 16),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        hintBuilderText = const Text(hintText2);
                        hasDxOffset = true;
                        setState(() {});
                      },
                      child: const Text(helloText),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
      await widgetTester.pumpWidget(
        _wrapMaterialApp(
          child: overlayTutorialScope,
        ),
      );

      await widgetTester.pumpAndSettle();
      expect(find.byWidget(overlayTutorialScope), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(2));
      expect(find.text(helloText), findsOneWidget);
      expect(find.text(hintText), findsOneWidget);
      expect(find.text(hintText2), findsNothing);

      await widgetTester.tap(find.byType(ElevatedButton));
      await widgetTester.pumpAndSettle();
      expect(find.byWidget(overlayTutorialScope), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(2));
      expect(find.text(helloText), findsOneWidget);
      expect(find.text(hintText), findsNothing);
      expect(find.text(hintText2), findsOneWidget);
    },
  );
}

Widget _wrapMaterialApp({required Widget child}) {
  return MaterialApp(
    home: child,
  );
}
