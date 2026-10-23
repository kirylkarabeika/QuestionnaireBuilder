import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:labs_questionnaire_creator/main.dart';
import 'package:labs_questionnaire_creator/models/questionnaire.dart';
import 'package:labs_questionnaire_creator/widgets/carousel_editor.dart';
import 'package:labs_questionnaire_creator/widgets/star_rating_editor.dart';

class _QuestionCardHarness extends StatefulWidget {
  const _QuestionCardHarness({
    required this.initialQuestion,
    this.onChangedSpy,
    this.onDelete,
  });

  final Question initialQuestion;
  final void Function(Question)? onChangedSpy;
  final VoidCallback? onDelete;

  @override
  State<_QuestionCardHarness> createState() => _QuestionCardHarnessState();
}

class _QuestionCardHarnessState extends State<_QuestionCardHarness> {
  late Question current;

  @override
  void initState() {
    super.initState();
    current = widget.initialQuestion;
  }

  @override
  Widget build(BuildContext context) {
    // Wrap in ReorderableListView so ReorderableDragStartListener has an ancestor
    return ReorderableListView(
      onReorder: (_, __) {},
      children: [
        QuestionCard(
          key: ValueKey(current.id),
          index: 0,
          question: current,
          onChanged: (q) {
            setState(() => current = q);
            widget.onChangedSpy?.call(q);
          },
          onDelete: widget.onDelete ?? () {},
        ),
      ],
    );
  }
}

void main() {
  Question makeQuestion(QuestionType type) => Question(
    id: 'q1',
    order: 0,
    title: 'Test Q',
    type: type,
    options: const [],
    isSkippable: false,
  );

  Widget buildCard({
    required Question question,
    required ValueChanged<Question> onChanged,
    VoidCallback? onDelete,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: ReorderableListView(
          onReorder: (_, __) {},
          children: [
            QuestionCard(
              key: const ValueKey('q1'),
              index: 0,
              question: question,
              onChanged: onChanged,
              onDelete: onDelete ?? () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStatefulCard({
    required Question initialQuestion,
    void Function(Question)? onChangedSpy,
    VoidCallback? onDelete,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: _QuestionCardHarness(
          initialQuestion: initialQuestion,
          onChangedSpy: onChangedSpy,
          onDelete: onDelete,
        ),
      ),
    );
  }

  group('QuestionCard', () {
    void useTallViewport(WidgetTester tester) {
      tester.view.physicalSize = const Size(1200, 1800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    testWidgets(
      'edits carousel mode and items and preserves the surviving item',
      (tester) async {
        useTallViewport(tester);
        Question? updated;
        await tester.pumpWidget(
          buildStatefulCard(
            initialQuestion: makeQuestion(QuestionType.carousel),
            onChangedSpy: (question) => updated = question,
          ),
        );
        expect(find.byType(CarouselEditor), findsOneWidget);
        expect(find.byType(OptionEditor), findsNothing);

        final mode = find.byType(
          DropdownButtonFormField<CarouselSelectionMode>,
        );
        await tester.tap(mode);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Multi select').last);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Add carousel item'));
        await tester.pump();
        await tester.tap(find.text('Add carousel item'));
        await tester.pump();
        expect(updated!.items.map((item) => item.id).toSet(), hasLength(2));
        final titles = find.widgetWithText(TextField, 'Item title');
        final descriptions = find.widgetWithText(TextField, 'Item description');
        final images = find.widgetWithText(TextField, 'Item image URL');
        await tester.enterText(titles.first, 'First item');
        await tester.pump();
        await tester.enterText(descriptions.first, 'First item details');
        await tester.pump();
        await tester.enterText(images.first, 'https://example.com/first.png');
        await tester.pump();
        await tester.enterText(titles.last, 'Second item');
        await tester.pump();
        await tester.enterText(
          descriptions.last,
          'Second item details\nMore information',
        );
        await tester.pump();
        await tester.enterText(images.last, 'https://example.com/second.png');
        await tester.pump();
        final survivingId = updated!.items.last.id;
        await tester.tap(find.byTooltip('Delete carousel item').first);
        await tester.pump();

        expect(updated!.selectionMode, CarouselSelectionMode.multiSelect);
        expect(
          updated!.items.single,
          CarouselItem(
            id: survivingId,
            order: 0,
            title: 'Second item',
            description: 'Second item details\nMore information',
            imageUrl: 'https://example.com/second.png',
          ),
        );
        expect(
          tester.widget<TextField>(titles).controller!.text,
          'Second item',
        );
        expect(
          tester.widget<TextField>(descriptions).controller!.text,
          'Second item details\nMore information',
        );
        expect(
          tester.widget<TextField>(images).controller!.text,
          'https://example.com/second.png',
        );
        await tester.tap(find.byType(Switch));
        await tester.pump();
        expect(updated!.isSkippable, isTrue);
        expect(updated!.items.single.id, survivingId);
        await tester.enterText(descriptions, '');
        await tester.pump();
        expect(updated!.items.single.description, isEmpty);
        expect(updated!.items.single.title, 'Second item');
        expect(
          updated!.items.single.imageUrl,
          'https://example.com/second.png',
        );
      },
    );

    testWidgets(
      'edits rating details and accepts only positive whole star counts',
      (tester) async {
        useTallViewport(tester);
        Question? updated;
        await tester.pumpWidget(
          buildStatefulCard(
            initialQuestion: makeQuestion(QuestionType.starRating),
            onChangedSpy: (question) => updated = question,
          ),
        );
        expect(find.byType(StarRatingEditor), findsOneWidget);
        expect(find.byType(OptionEditor), findsNothing);
        final count = find.widgetWithText(TextField, 'Number of stars');
        expect(tester.widget<TextField>(count).controller!.text, '5');
        await tester.enterText(
          find.widgetWithText(TextField, 'Rating title'),
          'Comfort',
        );
        await tester.pump();
        await tester.enterText(
          find.widgetWithText(TextField, 'Rating description'),
          'More stars means better',
        );
        await tester.pump();
        await tester.enterText(count, '7');
        await tester.pump();
        for (final invalid in ['0', '-1', '2.5', '']) {
          await tester.enterText(count, invalid);
          await tester.pump();
          expect(find.text('Enter a positive whole number'), findsOneWidget);
          expect(updated!.starRating!.starCount, 7);
        }
        await tester.enterText(count, '3');
        await tester.pump();
        expect(find.text('Enter a positive whole number'), findsNothing);
        expect(
          updated!.starRating,
          const StarRating(
            title: 'Comfort',
            starCount: 3,
            description: 'More stars means better',
          ),
        );
        await tester.tap(find.byType(Switch));
        await tester.pump();
        expect(updated!.isSkippable, isTrue);
        expect(updated!.title, 'Test Q');
      },
    );

    testWidgets(
      'loads imported carousel and rating settings into existing editors',
      (tester) async {
        useTallViewport(tester);
        Future<void> load(Question question) =>
            tester.pumpWidget(buildCard(question: question, onChanged: (_) {}));
        final carousel = makeQuestion(QuestionType.carousel).copyWith(
          items: const [
            CarouselItem(
              id: 'item-1',
              title: 'Before',
              description: 'Before description',
              imageUrl: 'https://example.com/before.png',
            ),
          ],
        );
        await load(carousel);
        await load(
          carousel.copyWith(
            selectionMode: CarouselSelectionMode.multiSelect,
            items: [
              carousel.items.single.copyWith(
                title: 'After',
                description: 'Imported item description',
                imageUrl: 'https://example.com/after.png',
              ),
            ],
          ),
        );
        expect(
          tester
              .widget<TextField>(find.widgetWithText(TextField, 'Item title'))
              .controller!
              .text,
          'After',
        );
        expect(
          tester
              .widget<TextField>(
                find.widgetWithText(TextField, 'Item description'),
              )
              .controller!
              .text,
          'Imported item description',
        );
        expect(
          tester
              .widget<TextField>(
                find.widgetWithText(TextField, 'Item image URL'),
              )
              .controller!
              .text,
          'https://example.com/after.png',
        );
        expect(
          tester
              .widget<DropdownButtonFormField<CarouselSelectionMode>>(
                find.byType(DropdownButtonFormField<CarouselSelectionMode>),
              )
              .initialValue,
          CarouselSelectionMode.multiSelect,
        );
        final rating = makeQuestion(QuestionType.starRating).copyWith(
          starRating: const StarRating(title: 'Before', description: 'Before'),
        );
        await load(rating);
        await load(
          rating.copyWith(
            starRating: const StarRating(
              title: 'After',
              starCount: 8,
              description: 'Updated description',
            ),
          ),
        );
        expect(
          tester
              .widget<TextField>(find.widgetWithText(TextField, 'Rating title'))
              .controller!
              .text,
          'After',
        );
        expect(
          tester
              .widget<TextField>(
                find.widgetWithText(TextField, 'Number of stars'),
              )
              .controller!
              .text,
          '8',
        );
        expect(
          tester
              .widget<TextField>(
                find.widgetWithText(TextField, 'Rating description'),
              )
              .controller!
              .text,
          'Updated description',
        );
      },
    );

    testWidgets('renders title and type chip', (tester) async {
      await tester.pumpWidget(
        buildCard(
          question: makeQuestion(QuestionType.textInput),
          onChanged: (_) {},
        ),
      );

      expect(find.text('Test Q'), findsOneWidget);
      expect(find.text('textInput'), findsOneWidget);
    });

    testWidgets('calls onDelete when delete button tapped', (tester) async {
      bool deleted = false;
      await tester.pumpWidget(
        buildCard(
          question: makeQuestion(QuestionType.textInput),
          onChanged: (_) {},
          onDelete: () => deleted = true,
        ),
      );

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      expect(deleted, isTrue);
    });

    testWidgets('calls onChanged when title is edited', (tester) async {
      Question? updated;
      await tester.pumpWidget(
        buildCard(
          question: makeQuestion(QuestionType.textInput),
          onChanged: (q) => updated = q,
        ),
      );

      await tester.enterText(find.byType(TextField).first, 'New title');
      await tester.pump();

      expect(updated?.title, 'New title');
    });

    for (final type in QuestionType.values) {
      testWidgets('edits and clears optional fields for ${type.name}', (
        tester,
      ) async {
        Question? updated;
        const initialDescription = 'Initial description';
        const initialUrl = 'https://example.com/initial.png';
        await tester.pumpWidget(
          buildStatefulCard(
            initialQuestion: makeQuestion(
              type,
            ).copyWith(description: initialDescription, imageUrl: initialUrl),
            onChangedSpy: (q) => updated = q,
          ),
        );
        final descriptionField = find.widgetWithText(
          TextField,
          'Question description (optional)',
        );
        expect(
          tester.widget<TextField>(descriptionField).controller!.text,
          initialDescription,
        );
        const description = 'First line\nSecond line.';
        await tester.enterText(descriptionField, description);
        await tester.pump();
        expect(updated?.description, description);
        expect(updated?.imageUrl, initialUrl);
        await tester.enterText(descriptionField, '   ');
        await tester.pump();
        expect(updated?.description, isNull);
        expect(updated?.imageUrl, initialUrl);

        final field = find.widgetWithText(
          TextField,
          'Question image URL (optional)',
        );
        expect(tester.widget<TextField>(field).controller!.text, initialUrl);

        await tester.enterText(field, '  https://example.com/question.png  ');
        await tester.pump();
        expect(updated?.imageUrl, 'https://example.com/question.png');
        expect(updated?.title, 'Test Q');
        expect(updated?.type, type);
        expect(updated?.description, isNull);

        await tester.enterText(field, '   ');
        await tester.pump();
        expect(updated?.imageUrl, isNull);
      });
    }

    testWidgets('syncs optional fields when a question is loaded externally', (
      tester,
    ) async {
      final question = makeQuestion(QuestionType.textInput);
      Future<void> load(Question value) =>
          tester.pumpWidget(buildCard(question: value, onChanged: (_) {}));
      final field = find.widgetWithText(
        TextField,
        'Question image URL (optional)',
      );
      final descriptionField = find.widgetWithText(
        TextField,
        'Question description (optional)',
      );
      await load(question);
      expect(tester.widget<TextField>(field).controller!.text, isEmpty);
      expect(
        tester.widget<TextField>(descriptionField).controller!.text,
        isEmpty,
      );
      const url = 'https://example.com/imported.png';
      const description = 'Imported description';
      await load(question.copyWith(description: description, imageUrl: url));
      expect(tester.widget<TextField>(field).controller!.text, url);
      expect(
        tester.widget<TextField>(descriptionField).controller!.text,
        description,
      );
      await load(question);
      expect(tester.widget<TextField>(field).controller!.text, isEmpty);
      expect(
        tester.widget<TextField>(descriptionField).controller!.text,
        isEmpty,
      );
    });

    testWidgets('shows OptionEditor for singleSelect', (tester) async {
      await tester.pumpWidget(
        buildCard(
          question: makeQuestion(QuestionType.singleSelect),
          onChanged: (_) {},
        ),
      );

      expect(find.byType(OptionEditor), findsOneWidget);
    });

    testWidgets('shows ProminentOptionEditor for prominentSingleSelect', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildCard(
          question: makeQuestion(QuestionType.prominentSingleSelect),
          onChanged: (_) {},
        ),
      );

      expect(find.byType(ProminentOptionEditor), findsOneWidget);
    });

    testWidgets('does NOT show OptionEditor for textInput', (tester) async {
      await tester.pumpWidget(
        buildCard(
          question: makeQuestion(QuestionType.textInput),
          onChanged: (_) {},
        ),
      );

      expect(find.byType(OptionEditor), findsNothing);
    });

    testWidgets('skippable switch starts OFF', (tester) async {
      await tester.pumpWidget(
        buildCard(
          question: makeQuestion(QuestionType.textInput),
          onChanged: (_) {},
        ),
      );

      expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);
    });

    testWidgets('skippable switch calls onChanged with isSkippable: true', (
      tester,
    ) async {
      Question? updated;

      await tester.pumpWidget(
        buildStatefulCard(
          initialQuestion: makeQuestion(QuestionType.textInput),
          onChangedSpy: (q) => updated = q,
        ),
      );

      expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(updated, isNotNull);
      expect(updated?.isSkippable, isTrue);
      expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
    });

    testWidgets('skippable switch toggles back OFF when tapped twice', (
      tester,
    ) async {
      Question? updated;

      await tester.pumpWidget(
        buildStatefulCard(
          initialQuestion: makeQuestion(QuestionType.textInput),
          onChangedSpy: (q) => updated = q,
        ),
      );

      // First tap: OFF → ON
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(
        updated?.isSkippable,
        isTrue,
        reason: 'After first tap switch should be ON',
      );
      expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);

      // Second tap: ON → OFF
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(
        updated?.isSkippable,
        isFalse,
        reason: 'After second tap switch should be OFF',
      );
      expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);
    });
  });
}
