import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:labs_questionnaire_creator/editor/draft_store.dart';
import 'package:labs_questionnaire_creator/editor/editor_controller.dart';
import 'package:labs_questionnaire_creator/main.dart';
import 'package:labs_questionnaire_creator/models/questionnaire.dart';

void main() {
  testWidgets(
    'adds extended types, keeps compatibility automatic, and restores editing after undo',
    (tester) async {
      tester.view.physicalSize = const Size(1500, 1100);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final controller = EditorController();
      await tester.pumpWidget(
        App(controller: controller, draftStore: MemoryDraftStore()),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('2 · Questions'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add question').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Carousel'));
      await tester.pumpAndSettle();
      expect(
        controller.questionnaire.value.questions.single.type,
        QuestionType.carousel,
      );
      expect(
        controller.questionnaire.value.showByCondition,
        extendedQuestionnaireCondition,
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Question title'),
        'Route preferences',
      );
      await tester.pump();
      expect(
        find.byKey(const ValueKey('preview-question-title')),
        findsOneWidget,
      );
      expect(
        tester
            .widget<Text>(find.byKey(const ValueKey('preview-question-title')))
            .data,
        'Route preferences',
      );
      await tester.tap(find.text('Add question').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Star rating'));
      await tester.pumpAndSettle();
      expect(
        controller.questionnaire.value.questions.last.type,
        QuestionType.starRating,
      );
      await tester.tap(find.byTooltip('Duplicate question'));
      await tester.pumpAndSettle();
      expect(controller.questionnaire.value.questions, hasLength(3));
      await tester.tap(find.byTooltip('Delete question'));
      await tester.pumpAndSettle();
      expect(controller.questionnaire.value.questions, hasLength(2));
      await tester.tap(find.byTooltip('Undo'));
      await tester.pumpAndSettle();
      expect(controller.questionnaire.value.questions, hasLength(3));
      expect(tester.takeException(), isNull);
    },
  );
  for (final width in [360.0, 800.0, 1100.0, 1500.0]) {
    testWidgets('workspace fits a ${width.toInt()}px viewport', (tester) async {
      tester.view.physicalSize = Size(width, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final controller = EditorController();
      controller.addQuestion(QuestionType.carousel);
      await tester.pumpWidget(
        App(controller: controller, draftStore: MemoryDraftStore()),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('2 · Questions'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('3 · Review'));
      await tester.pumpAndSettle();
      expect(find.text('Review your questionnaire'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
