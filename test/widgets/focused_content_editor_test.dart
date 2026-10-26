import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:labs_questionnaire_creator/editor/editor_controller.dart';
import 'package:labs_questionnaire_creator/editor/editor_location.dart';
import 'package:labs_questionnaire_creator/editor/focused_content_editor.dart';
import 'package:labs_questionnaire_creator/models/questionnaire.dart';
import 'package:labs_questionnaire_creator/widgets/editor_fields.dart';

class _Harness extends StatefulWidget {
  const _Harness({required this.controller});
  final EditorController controller;
  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness> {
  late EditorLocation location = EditorLocation(
    ContentKind.question,
    questionId: widget.controller.questionnaire.value.questions.first.id,
  );
  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ValueListenableBuilder<Questionnaire>(
          valueListenable: widget.controller.questionnaire,
          builder: (context, questionnaire, _) => FocusedContentEditor(
            key: ValueKey(location.key),
            questionnaire: questionnaire,
            controller: widget.controller,
            location: location,
            onNavigate: (target) => setState(() => location = target),
            onAddQuestion: () {},
          ),
        ),
      ),
    ),
  );
}

Finder field(String label) => find.widgetWithText(TextField, label);

void main() {
  late EditorController controller;
  setUp(() => controller = EditorController());
  tearDown(() => controller.dispose());
  Future<void> reveal(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
  }

  for (final type in QuestionType.values) {
    testWidgets(
      '${type.label} has focused optional fields and common question settings',
      (tester) async {
        controller.addQuestion(type);
        await tester.pumpWidget(_Harness(controller: controller));
        expect(field('Question title'), findsOneWidget);
        expect(field('Description (optional)'), findsNothing);
        await tester.enterText(field('Question title'), 'A clear question');
        await tester.pump();
        await tester.tap(find.text('Add description'));
        await tester.pump();
        await tester.enterText(
          field('Description (optional)'),
          'First line\nSecond line',
        );
        await tester.pump();
        await reveal(tester, find.text('Add image (optional)'));
        await tester.tap(find.text('Add image (optional)'));
        await tester.pump();
        await tester.enterText(
          field('Image URL'),
          'https://example.com/question.png',
        );
        await tester.pump();
        final q = controller.questionnaire.value.questions.single;
        expect(q.title, 'A clear question');
        expect(q.description, 'First line\nSecond line');
        expect(q.imageUrl, 'https://example.com/question.png');
        await reveal(tester, find.text('Answer settings'));
        await tester.tap(find.text('Answer settings'));
        await tester.pumpAndSettle();
        await reveal(tester, find.text('Allow participants to skip'));
        await tester.tap(find.text('Allow participants to skip'));
        await tester.pump();
        expect(
          controller.questionnaire.value.questions.single.isSkippable,
          isFalse,
        );
      },
    );
  }
  for (final type in [
    QuestionType.singleSelect,
    QuestionType.multiSelect,
    QuestionType.prominentSingleSelect,
  ]) {
    testWidgets(
      '${type.label} restricts answer content without affecting question content',
      (tester) async {
        controller.addQuestion(type);
        final question = controller.questionnaire.value.questions.single;
        controller.updateQuestion(
          question.id,
          question.copyWith(
            title: 'Question',
            description: 'Question explanation',
            imageUrl: 'https://example.com/question.png',
            options: const [
              Option(
                id: 'answer',
                text: 'An answer',
                description: 'Answer explanation',
                imageUrl: 'https://example.com/answer.png',
              ),
            ],
          ),
        );
        await tester.pumpWidget(_Harness(controller: controller));
        final imageChoice = type == QuestionType.prominentSingleSelect;
        expect(
          find.byType(ContentImage),
          imageChoice ? findsNWidgets(2) : findsOneWidget,
        );
        expect(
          find.text('Answer explanation'),
          imageChoice ? findsOneWidget : findsNothing,
        );
        await reveal(tester, find.text('An answer'));
        await tester.tap(find.text('An answer'));
        await tester.pumpAndSettle();
        expect(
          find.byType(OptionalDescriptionField),
          imageChoice ? findsOneWidget : findsNothing,
        );
        expect(find.text('Add description'), findsNothing);
        expect(
          find.text('Answer explanation'),
          imageChoice ? findsOneWidget : findsNothing,
        );
        expect(
          find.byType(ImageField),
          imageChoice ? findsOneWidget : findsNothing,
        );
        if (!imageChoice) {
          expect(find.text('Remove answer image'), findsNothing);
          expect(
            controller
                .questionnaire
                .value
                .questions
                .single
                .options
                .single
                .imageUrl,
            'https://example.com/answer.png',
          );
          expect(find.text('Add image (optional)'), findsNothing);
        } else {
          await tester.enterText(
            field('Description (optional)'),
            'Updated answer explanation',
          );
          await tester.pump();
          expect(
            controller
                .questionnaire
                .value
                .questions
                .single
                .options
                .single
                .description,
            'Updated answer explanation',
          );
          await tester.enterText(field('Description (optional)'), '');
          await tester.pump();
          expect(
            controller
                .questionnaire
                .value
                .questions
                .single
                .options
                .single
                .description,
            isNull,
          );
          await tester.enterText(
            field('Description (optional)'),
            'Answer explanation',
          );
          await tester.pump();
          expect(find.byTooltip('Change image'), findsOneWidget);
          expect(
            controller
                .questionnaire
                .value
                .questions
                .single
                .options
                .single
                .imageUrl,
            'https://example.com/answer.png',
          );
        }
        expect(
          controller.questionnaire.value.questions.single.imageUrl,
          'https://example.com/question.png',
        );
        expect(
          controller.questionnaire.value.questions.single.description,
          'Question explanation',
        );
        expect(
          controller
              .questionnaire
              .value
              .questions
              .single
              .options
              .single
              .description,
          'Answer explanation',
        );
      },
    );
  }
  testWidgets('carousel descriptions and images live in their own editor', (
    tester,
  ) async {
    controller.addQuestion(QuestionType.carousel);
    await tester.pumpWidget(_Harness(controller: controller));
    await reveal(tester, find.text('Add carousel item'));
    await tester.tap(find.text('Add carousel item'));
    await tester.pumpAndSettle();
    expect(field('Question title'), findsNothing);
    expect(find.text('Edit carousel item'), findsOneWidget);
    await tester.enterText(field('Item title'), 'Mountains');
    await tester.pump();
    await tester.enterText(
      field('Item description (optional)'),
      'Scenic routes\nWinding roads',
    );
    await tester.pump();
    await reveal(tester, find.text('Add image'));
    await tester.tap(find.text('Add image'));
    await tester.pump();
    await tester.enterText(
      field('Image URL'),
      'https://example.com/mountains.png',
    );
    await tester.pump();
    await reveal(tester, find.text('Done'));
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(field('Item title'), findsNothing);
    expect(find.text('Mountains'), findsOneWidget);
    await tester.tap(find.text('Mountains'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextField>(field('Item description (optional)'))
          .controller!
          .text,
      'Scenic routes\nWinding roads',
    );
    await tester.enterText(field('Item description (optional)'), '');
    await tester.pump();
    expect(
      controller.questionnaire.value.questions.single.items.single.description,
      isEmpty,
    );
    await tester.tap(find.byTooltip('Delete carousel item'));
    await tester.pumpAndSettle();
    expect(controller.questionnaire.value.questions.single.items, isEmpty);
    controller.undo();
    await tester.pump();
    expect(
      controller.questionnaire.value.questions.single.items.single.title,
      'Mountains',
    );
  });
  testWidgets(
    'rating details have a separate editor with star count validation',
    (tester) async {
      controller.addQuestion(QuestionType.starRating);
      await tester.pumpWidget(_Harness(controller: controller));
      expect(field('Rating title'), findsNothing);
      await reveal(tester, find.text('Configure star rating'));
      await tester.tap(find.text('Configure star rating'));
      await tester.pumpAndSettle();
      expect(field('Question title'), findsNothing);
      await tester.enterText(field('Rating title'), 'Comfort');
      await tester.pump();
      await tester.enterText(field('Number of stars'), '7');
      await tester.pump();
      await tester.enterText(
        field('Rating description'),
        'More stars means better',
      );
      await tester.pump();
      await tester.enterText(field('Number of stars'), '0');
      await tester.pump();
      expect(find.text('Enter a positive whole number'), findsOneWidget);
      expect(
        controller.questionnaire.value.questions.single.starRating!.starCount,
        7,
      );
      await tester.enterText(field('Number of stars'), '3');
      await tester.pump();
      expect(
        controller.questionnaire.value.questions.single.starRating,
        const StarRating(
          title: 'Comfort',
          starCount: 3,
          description: 'More stars means better',
        ),
      );
    },
  );
  testWidgets(
    'answer choices use a separate editor and preserve the question title',
    (tester) async {
      controller.addQuestion(QuestionType.singleSelect);
      await tester.pumpWidget(_Harness(controller: controller));
      await tester.enterText(field('Question title'), 'Choose one');
      await tester.pump();
      await reveal(tester, find.text('Add answer choice'));
      await tester.tap(find.text('Add answer choice'));
      await tester.pumpAndSettle();
      await tester.enterText(field('Answer text'), 'First answer');
      await tester.pump();
      await reveal(tester, find.text('Done'));
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();
      expect(
        controller.questionnaire.value.questions.single.title,
        'Choose one',
      );
      expect(
        controller.questionnaire.value.questions.single.options.single.text,
        'First answer',
      );
    },
  );
}
