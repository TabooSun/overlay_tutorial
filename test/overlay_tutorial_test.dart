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
                      builder: (context, rect, rRect) {
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
      await widgetTester.pumpWidget(_wrapMaterialApp(
        child: overlayTutorialScope,
      ));

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
                          builder: (context, rect, rRect) {
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
          await widgetTester.pumpWidget(_wrapMaterialApp(
            child: overlayTutorialScope,
          ));

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
                          builder: (context, rect, rRect) {
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
          await widgetTester.pumpWidget(_wrapMaterialApp(
            child: overlayTutorialScope,
          ));

          await widgetTester.pumpAndSettle();
          expect(find.byWidget(overlayTutorialScope), findsOneWidget);
          expect(find.byType(Text), findsNWidgets(1));
          expect(find.text(helloText), findsOneWidget);
          expect(find.text(hintText), findsNothing);
        },
      );
    },
  );
}

Widget _wrapMaterialApp({required Widget child}) {
  return MaterialApp(
    home: child,
  );
}
