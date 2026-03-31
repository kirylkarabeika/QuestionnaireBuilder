import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:labs_questionnaire_creator/main.dart';
import 'package:labs_questionnaire_creator/models/questionnaire.dart';

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
