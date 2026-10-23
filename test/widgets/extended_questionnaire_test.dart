import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:labs_questionnaire_creator/main.dart';
import 'package:labs_questionnaire_creator/models/questionnaire.dart';

void main() {
  testWidgets(
    'adds both extended question types and keeps the condition in sync',
    (tester) async {
      tester.view.physicalSize = const Size(1500, 1800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const App());

      Future<void> reveal(Finder finder, double delta) async {
        await tester.scrollUntilVisible(
          finder,
          delta,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.ensureVisible(finder);
        await tester.pumpAndSettle();
      }

      final condition = find.byType(DropdownButtonFormField<String?>);
      await reveal(condition, -250);
      await tester.tap(condition);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Extended questionnaire').last);
      await tester.pumpAndSettle();
      expect(
        tester.widget<DropdownButtonFormField<String?>>(condition).initialValue,
        extendedQuestionnaireCondition,
      );

      await tester.tap(find.byTooltip('New'));
      await tester.pumpAndSettle();
      await reveal(condition, -250);
      expect(
        tester.widget<DropdownButtonFormField<String?>>(condition).initialValue,
        isNull,
      );
      await reveal(find.text('Carousel'), 250);
      await tester.tap(find.text('Carousel'));
      await tester.pumpAndSettle();
      await reveal(condition, -250);
      expect(
        tester.widget<DropdownButtonFormField<String?>>(condition).initialValue,
        extendedQuestionnaireCondition,
      );
      expect(
        tester.widget<DropdownButtonFormField<String?>>(condition).onChanged,
        isNull,
      );

      await reveal(find.text('Star rating'), 250);
      await tester.tap(find.widgetWithText(ElevatedButton, 'Star rating'));
      await tester.pumpAndSettle();
      expect(
        tester
            .widgetList<QuestionCard>(find.byType(QuestionCard))
            .map((card) => card.question.type),
        [QuestionType.carousel, QuestionType.starRating],
      );

      await tester.tap(find.byTooltip('New'));
      await tester.pumpAndSettle();
      await reveal(condition, -250);
      expect(
        tester.widget<DropdownButtonFormField<String?>>(condition).initialValue,
        isNull,
      );
      expect(
        tester.widget<DropdownButtonFormField<String?>>(condition).onChanged,
        isNotNull,
      );
    },
  );
}
