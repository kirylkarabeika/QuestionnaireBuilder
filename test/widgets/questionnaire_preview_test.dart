import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:labs_questionnaire_creator/editor/editor_location.dart';
import 'package:labs_questionnaire_creator/models/questionnaire.dart';
import 'package:labs_questionnaire_creator/widgets/questionnaire_preview.dart';

void main() {
  testWidgets(
    'participant flow supports selection, carousel, stars, text skipping, and never modifies content',
    (tester) async {
      tester.view.physicalSize = const Size(500, 1500);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      const questionnaire = Questionnaire(
        id: 'test',
        title: 'Survey',
        description: '',
        preScreen: PreScreen(title: 'Welcome', description: 'Introduction'),
        questions: [
          Question(
            id: 'single',
            title: 'Choose one',
            type: QuestionType.singleSelect,
            isSkippable: false,
            options: [
              Option(id: 'a', text: 'First choice'),
              Option(id: 'b', text: 'Second choice'),
            ],
          ),
          Question(
            id: 'carousel',
            title: 'Choose routes',
            type: QuestionType.carousel,
            selectionMode: CarouselSelectionMode.multiSelect,
            isSkippable: false,
            items: [
              CarouselItem(id: 'm', title: 'Mountains', imageUrl: ''),
              CarouselItem(id: 'c', title: 'Coast', imageUrl: ''),
            ],
          ),
          Question(
            id: 'rating',
            title: 'Rate the trip',
            type: QuestionType.starRating,
            isSkippable: false,
            starRating: StarRating(
              title: 'Comfort',
              description: 'More is better',
            ),
          ),
          Question(
            id: 'text',
            title: 'Anything else?',
            type: QuestionType.textInput,
          ),
        ],
      );
      final original = questionnaire.toJson().toString();
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: QuestionnairePreview(
                questionnaire: questionnaire,
                location: EditorLocation(ContentKind.question),
                walkthrough: true,
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Start questionnaire'));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Continue'))
            .onPressed,
        isNull,
      );
      await tester.tap(find.text('First choice'));
      await tester.pump();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mountains'));
      await tester.pump();
      await tester.tap(find.byTooltip('Next carousel item'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Coast'));
      await tester.pump();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Rate 4 stars'));
      await tester.pump();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Your answer'),
        'A test-only response',
      );
      await tester.pump();
      await tester.tap(find.text('Previous question'));
      await tester.pumpAndSettle();
      expect(find.text('4 of 5 stars'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();
      expect(find.text('Thank you for your feedback'), findsOneWidget);
      expect(questionnaire.toJson().toString(), original);
    },
  );
}
