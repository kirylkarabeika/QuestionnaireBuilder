import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:labs_questionnaire_creator/editor/draft_store.dart';
import 'package:labs_questionnaire_creator/editor/editor_controller.dart';
import 'package:labs_questionnaire_creator/main.dart';
import 'package:labs_questionnaire_creator/models/questionnaire.dart';
import 'package:labs_questionnaire_creator/widgets/editor_fields.dart';

void main() {
  testWidgets(
    'welcome content uses focused item editors and preserves both layouts',
    (tester) async {
      tester.view.physicalSize = const Size(1450, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final controller = EditorController();
      await tester.pumpWidget(
        App(controller: controller, draftStore: MemoryDraftStore()),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Include a welcome screen'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Edit welcome screen'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextField, 'Welcome title'),
        'Before you start',
      );
      await tester.pump();
      final layout = find.byType(DropdownButtonFormField<PreScreenStyle>);
      await tester.tap(layout);
      await tester.pumpAndSettle();
      await tester.tap(find.text('List with icons').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add welcome item'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(TextField, 'Welcome title'), findsNothing);
      await tester.enterText(
        find.widgetWithText(TextField, 'Item text'),
        'Bring your keys',
      );
      await tester.pump();
      expect(
        controller.questionnaire.value.preScreen!.items.single.iconUrl,
        isNull,
      );
      expect(find.byType(ContentImage), findsNothing);
      await tester.tap(find.text('Add icon (optional)'));
      await tester.pump();
      await tester.enterText(
        find.widgetWithText(TextField, 'Icon URL'),
        'https://example.com/key.png',
      );
      await tester.pump();
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();
      await tester.tap(layout);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cards').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add welcome card'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextField, 'Card title'),
        'Welcome card',
      );
      await tester.pump();
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();
      await tester.tap(layout);
      await tester.pumpAndSettle();
      await tester.tap(find.text('List with icons').last);
      await tester.pumpAndSettle();
      expect(
        controller.questionnaire.value.preScreen!.items.single.title,
        'Bring your keys',
      );
      expect(
        controller.questionnaire.value.preScreen!.cards.single.title,
        'Welcome card',
      );
      await tester.tap(find.text('Bring your keys').first);
      await tester.pumpAndSettle();
      expect(
        controller.questionnaire.value.preScreen!.items.single.iconUrl,
        'https://example.com/key.png',
      );
      await tester.tap(find.byTooltip('Remove image'));
      await tester.pumpAndSettle();
      expect(
        controller.questionnaire.value.preScreen!.items.single.iconUrl,
        isNull,
      );
      expect(find.byType(ContentImage), findsNothing);
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();
      expect(find.byType(ContentImage), findsNothing);
      await tester.tap(find.text('Bring your keys').first);
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Delete welcome item'));
      await tester.pumpAndSettle();
      expect(controller.questionnaire.value.preScreen!.items, isEmpty);
    },
  );
}
