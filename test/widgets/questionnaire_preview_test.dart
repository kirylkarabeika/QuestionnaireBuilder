import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:labs_questionnaire_creator/editor/editor_location.dart';
import 'package:labs_questionnaire_creator/models/questionnaire.dart';
import 'package:labs_questionnaire_creator/widgets/questionnaire_preview.dart';
import 'package:labs_questionnaire_creator/widgets/editor_fields.dart';

void main() {
  for (final type in [
    QuestionType.singleSelect,
    QuestionType.multiSelect,
    QuestionType.prominentSingleSelect,
  ]) {
    testWidgets(
      'preview restricts answer images and descriptions: ${type.name}',
      (tester) async {
        final questionnaire = Questionnaire(
          id: 'survey',
          title: 'Survey',
          description: '',
          questions: [
            Question(
              id: 'q',
              title: 'Question',
              description: 'Question explanation',
              type: type,
              imageUrl: 'https://example.com/question.png',
              options: const [
                Option(
                  id: 'answer',
                  text: 'Answer',
                  description: 'Answer explanation',
                  imageUrl: 'https://example.com/answer.png',
                ),
              ],
            ),
          ],
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: QuestionnairePreview(
                  questionnaire: questionnaire,
                  location: const EditorLocation(
                    ContentKind.question,
                    questionId: 'q',
                  ),
                ),
              ),
            ),
          ),
        );
        final images = tester
            .widgetList<ContentImage>(find.byType(ContentImage))
            .map((image) => image.url)
            .toList();
        expect(find.text('Question explanation'), findsOneWidget);
        expect(
          find.text('Answer explanation'),
          type == QuestionType.prominentSingleSelect
              ? findsOneWidget
              : findsNothing,
        );
        expect(
          images,
          type == QuestionType.prominentSingleSelect
              ? [
                  'https://example.com/question.png',
                  'https://example.com/answer.png',
                ]
              : ['https://example.com/question.png'],
        );
        expect(
          questionnaire.questions.single.options.single.imageUrl,
          'https://example.com/answer.png',
        );
      },
    );
  }

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
              CarouselItem(
                id: 'm',
                title: 'Mountains',
                description: 'Route explanation',
                imageUrl: '',
              ),
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
      expect(find.text('Route explanation'), findsOneWidget);
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
