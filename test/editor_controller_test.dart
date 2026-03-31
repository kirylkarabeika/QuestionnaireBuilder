import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import '../lib/editor/editor_controller.dart';
import '../lib/models/questionnaire.dart';

void main() {
  late EditorController controller;

  setUp(() {
    controller = EditorController();
  });

  tearDown(() {
    controller.questionnaire.dispose();
  });

  // ── newQuestionnaire ────────────────────────────────────────

  group('newQuestionnaire', () {
    test('resets title and questions', () {
      controller.setTitle('Old Title');
      controller.addQuestion(QuestionType.textInput);

      controller.newQuestionnaire();

      expect(controller.questionnaire.value.title, '');
      expect(controller.questionnaire.value.questions, isEmpty);
    });

    test('generates a new id', () {
      final oldId = controller.questionnaire.value.id;
      controller.newQuestionnaire();
      expect(controller.questionnaire.value.id, isNot(oldId));
    });
  });

  // ── setId ───────────────────────────────────────────────────

  group('setId', () {
    test('sets a valid id', () {
      controller.setId('my_questionnaire-01');
      expect(controller.questionnaire.value.id, 'my_questionnaire-01');
    });

    test('replaces spaces and special chars with underscores', () {
      controller.setId('hello world!');
      expect(controller.questionnaire.value.id, 'hello_world_');
    });

    test('keeps existing id when sanitized result is empty', () {
      final original = controller.questionnaire.value.id;
      controller.setId('   ');
      expect(controller.questionnaire.value.id, original);
    });

    test('trims surrounding whitespace before sanitizing', () {
      controller.setId('  valid_id  ');
      expect(controller.questionnaire.value.id, 'valid_id');
    });
  });

  // ── setTitle ────────────────────────────────────────────────

  group('setTitle', () {
    test('updates the title', () {
      controller.setTitle('My Survey');
      expect(controller.questionnaire.value.title, 'My Survey');
    });

    test('allows empty string', () {
      controller.setTitle('Non-empty');
      controller.setTitle('');
      expect(controller.questionnaire.value.title, '');
    });
  });

  // ── setDescription ──────────────────────────────────────────

  group('setDescription', () {
    test('updates the description', () {
      controller.setDescription('A description');
      expect(controller.questionnaire.value.description, 'A description');
    });
  });

  // ── setDateLabel ────────────────────────────────────────────

  group('setDateLabel', () {
    test('sets a non-empty value', () {
      controller.setDateLabel('2024-01-01');
      expect(controller.questionnaire.value.dateLabel, '2024-01-01');
    });

    test('sets null for empty string', () {
      controller.setDateLabel('2024-01-01');
      controller.setDateLabel('');
      expect(controller.questionnaire.value.dateLabel, isNull);
    });

    test('sets null for whitespace-only string', () {
      controller.setDateLabel('   ');
      expect(controller.questionnaire.value.dateLabel, isNull);
    });

    test('sets null when null is passed', () {
      controller.setDateLabel('2024-01-01');
      controller.setDateLabel(null);
      expect(controller.questionnaire.value.dateLabel, isNull);
    });
  });

  // ── setShowByCondition ──────────────────────────────────────

  group('setShowByCondition', () {
    test('sets a condition string', () {
      controller.setShowByCondition('flag == true');
      expect(controller.questionnaire.value.showByCondition, 'flag == true');
    });

    test('sets null for empty string', () {
      controller.setShowByCondition('flag == true');
      controller.setShowByCondition('');
      expect(controller.questionnaire.value.showByCondition, isNull);
    });

    test('sets null when null is passed', () {
      controller.setShowByCondition(null);
      expect(controller.questionnaire.value.showByCondition, isNull);
    });
  });

  // ── setBackgroundImageUrl ───────────────────────────────────

  group('setBackgroundImageUrl', () {
    test('sets a valid URL', () {
      controller.setBackgroundImageUrl('https://example.com/img.png');
      expect(controller.questionnaire.value.backgroundImageUrl,
          'https://example.com/img.png');
    });

    test('sets null for empty string', () {
      controller.setBackgroundImageUrl('https://example.com/img.png');
      controller.setBackgroundImageUrl('');
      expect(controller.questionnaire.value.backgroundImageUrl, isNull);
    });

    test('sets null when null is passed', () {
      controller.setBackgroundImageUrl(null);
      expect(controller.questionnaire.value.backgroundImageUrl, isNull);
    });
  });

  // ── setSortOrderFromText ────────────────────────────────────

  group('setSortOrderFromText', () {
    test('parses and sets a valid integer', () {
      controller.setSortOrderFromText('5');
      expect(controller.questionnaire.value.sortOrder, 5);
    });

    test('does nothing for non-numeric input', () {
      controller.setSortOrderFromText('5');
      controller.setSortOrderFromText('abc');
      expect(controller.questionnaire.value.sortOrder, 5);
    });

    test('does nothing for empty string', () {
      controller.setSortOrderFromText('3');
      controller.setSortOrderFromText('');
      expect(controller.questionnaire.value.sortOrder, 3);
    });

    test('accepts negative numbers', () {
      controller.setSortOrderFromText('-1');
      expect(controller.questionnaire.value.sortOrder, -1);
    });
  });

  // ── setActiveFrom ───────────────────────────────────────────

  group('setActiveFrom', () {
    final date1 = DateTime(2024, 1, 1);
    final date2 = DateTime(2024, 6, 1);
    final date3 = DateTime(2024, 12, 1);

    test('sets activeFrom', () {
      controller.setActiveFrom(date1);
      expect(controller.questionnaire.value.activeFrom, date1);
    });

    test('clears activeFrom when null is passed', () {
      controller.setActiveFrom(date1);
      controller.setActiveFrom(null);
      expect(controller.questionnaire.value.activeFrom, isNull);
    });

    test('moves activeTo forward when activeFrom is set after it', () {
      controller.setActiveTo(date2);
      controller.setActiveFrom(date3);
      expect(controller.questionnaire.value.activeTo, date3);
    });

    test('does not change activeTo when activeFrom is before it', () {
      controller.setActiveTo(date3);
      controller.setActiveFrom(date1);
      expect(controller.questionnaire.value.activeTo, date3);
    });
  });

  // ── setActiveTo ─────────────────────────────────────────────

  group('setActiveTo', () {
    final date1 = DateTime(2024, 1, 1);
    final date2 = DateTime(2024, 6, 1);
    final date3 = DateTime(2024, 12, 1);

    test('sets activeTo', () {
      controller.setActiveTo(date3);
      expect(controller.questionnaire.value.activeTo, date3);
    });

    test('clears activeTo when null is passed', () {
      controller.setActiveTo(date3);
      controller.setActiveTo(null);
      expect(controller.questionnaire.value.activeTo, isNull);
    });

    test('moves activeFrom back when activeTo is set before it', () {
      controller.setActiveFrom(date3);
      controller.setActiveTo(date1);
      expect(controller.questionnaire.value.activeFrom, date1);
    });

    test('does not change activeFrom when activeTo is after it', () {
      controller.setActiveFrom(date1);
      controller.setActiveTo(date2);
      expect(controller.questionnaire.value.activeFrom, date1);
    });
  });

  // ── addQuestion ─────────────────────────────────────────────

  group('addQuestion', () {
    test('adds a question with the correct type', () {
      controller.addQuestion(QuestionType.textInput);
      expect(controller.questionnaire.value.questions.length, 1);
      expect(controller.questionnaire.value.questions.first.type,
          QuestionType.textInput);
    });

    test('assigns order sequentially', () {
      controller.addQuestion(QuestionType.textInput);
      controller.addQuestion(QuestionType.textInput);
      controller.addQuestion(QuestionType.textInput);
      final orders = controller.questionnaire.value.questions
          .map((q) => q.order)
          .toList();
      expect(orders, [0, 1, 2]);
    });

    test('new question has empty title', () {
      controller.addQuestion(QuestionType.textInput);
      expect(controller.questionnaire.value.questions.first.title, '');
    });
  });

  // ── updateQuestion ──────────────────────────────────────────

  group('updateQuestion', () {
    test('updates the matching question', () {
      controller.addQuestion(QuestionType.textInput);
      final q = controller.questionnaire.value.questions.first;
      final updated = q.copyWith(title: 'Updated');

      controller.updateQuestion(q.id, updated);

      expect(controller.questionnaire.value.questions.first.title, 'Updated');
    });

    test('does not modify other questions', () {
      controller.addQuestion(QuestionType.textInput);
      controller.addQuestion(QuestionType.textInput);
      final q0 = controller.questionnaire.value.questions[0];
      final q1 = controller.questionnaire.value.questions[1];

      controller.updateQuestion(q0.id, q0.copyWith(title: 'Changed'));

      expect(controller.questionnaire.value.questions[1].id, q1.id);
      expect(controller.questionnaire.value.questions[1].title, q1.title);
    });
  });

  // ── removeQuestion ──────────────────────────────────────────

  group('removeQuestion', () {
    test('removes the question by id', () {
      controller.addQuestion(QuestionType.textInput);
      final id = controller.questionnaire.value.questions.first.id;

      controller.removeQuestion(id);

      expect(controller.questionnaire.value.questions, isEmpty);
    });

    test('re-indexes order after removal', () {
      controller.addQuestion(QuestionType.textInput);
      controller.addQuestion(QuestionType.textInput);
      controller.addQuestion(QuestionType.textInput);
      final middleId = controller.questionnaire.value.questions[1].id;

      controller.removeQuestion(middleId);

      final orders = controller.questionnaire.value.questions
          .map((q) => q.order)
          .toList();
      expect(orders, [0, 1]);
    });
  });

  // ── reorderQuestion ─────────────────────────────────────────

  group('reorderQuestion', () {
    test('moves item from old index to new index', () {
      controller.addQuestion(QuestionType.textInput);
      controller.addQuestion(QuestionType.textInput);
      controller.addQuestion(QuestionType.textInput);

      final firstId = controller.questionnaire.value.questions[0].id;
      final secondId = controller.questionnaire.value.questions[1].id;

      controller.reorderQuestion(0, 2);

      expect(controller.questionnaire.value.questions[0].id, secondId);
      expect(controller.questionnaire.value.questions[1].id, firstId);
    });

    test('re-indexes order values after reorder', () {
      controller.addQuestion(QuestionType.textInput);
      controller.addQuestion(QuestionType.textInput);
      controller.addQuestion(QuestionType.textInput);

      controller.reorderQuestion(2, 0);

      final orders = controller.questionnaire.value.questions
          .map((q) => q.order)
          .toList();
      expect(orders, [0, 1, 2]);
    });
  });

  // ── setPreScreen ────────────────────────────────────────────

  group('setPreScreen', () {
    test('sets an explicit preScreen', () {
      const ps = PreScreen(title: 'Direct', description: 'Set directly');
      controller.setPreScreen(ps);
      expect(controller.questionnaire.value.preScreen!.title, 'Direct');
    });

    test('clears preScreen when null is passed', () {
      controller.enablePreScreen(true);
      controller.setPreScreen(null);
      expect(controller.questionnaire.value.preScreen, isNull);
    });
  });

  // ── enablePreScreen ─────────────────────────────────────────

  group('enablePreScreen', () {
    test('creates a default preScreen when enabled', () {
      controller.enablePreScreen(true);
      expect(controller.questionnaire.value.preScreen, isNotNull);
      expect(controller.questionnaire.value.preScreen!.title, '');
    });

    test('keeps existing preScreen when enabled again', () {
      controller.enablePreScreen(true);
      controller.setPreScreenTitle('Keep me');
      controller.enablePreScreen(true);
      expect(controller.questionnaire.value.preScreen!.title, 'Keep me');
    });

    test('removes preScreen when disabled', () {
      controller.enablePreScreen(true);
      controller.enablePreScreen(false);
      expect(controller.questionnaire.value.preScreen, isNull);
    });
  });

  // ── setPreScreenTitle ───────────────────────────────────────

  group('setPreScreenTitle', () {
    test('updates the preScreen title', () {
      controller.enablePreScreen(true);
      controller.setPreScreenTitle('Welcome');
      expect(controller.questionnaire.value.preScreen!.title, 'Welcome');
    });

    test('does nothing when preScreen is null', () {
      controller.setPreScreenTitle('Should not crash');
      expect(controller.questionnaire.value.preScreen, isNull);
    });
  });

  // ── setPreScreenDescription ─────────────────────────────────

  group('setPreScreenDescription', () {
    test('updates the preScreen description', () {
      controller.enablePreScreen(true);
      controller.setPreScreenDescription('Please read carefully');
      expect(controller.questionnaire.value.preScreen!.description,
          'Please read carefully');
    });

    test('does nothing when preScreen is null', () {
      controller.setPreScreenDescription('Should not crash');
      expect(controller.questionnaire.value.preScreen, isNull);
    });
  });

  // ── addPreScreenCard ────────────────────────────────────────

  group('addPreScreenCard', () {
    test('adds a card to preScreen', () {
      controller.enablePreScreen(true);
      controller.addPreScreenCard();
      expect(controller.questionnaire.value.preScreen!.cards.length, 1);
    });

    test('adds multiple cards sequentially', () {
      controller.enablePreScreen(true);
      controller.addPreScreenCard();
      controller.addPreScreenCard();
      expect(controller.questionnaire.value.preScreen!.cards.length, 2);
    });

    test('does nothing when preScreen is null', () {
      controller.addPreScreenCard();
      expect(controller.questionnaire.value.preScreen, isNull);
    });
  });

  // ── updatePreScreenCard ─────────────────────────────────────

  group('updatePreScreenCard', () {
    test('updates the card at given index', () {
      controller.enablePreScreen(true);
      controller.addPreScreenCard();
      const updated = PreScreenCard(title: 'Card Title', description: 'Desc');

      controller.updatePreScreenCard(0, updated);

      expect(controller.questionnaire.value.preScreen!.cards.first.title,
          'Card Title');
    });

    test('does nothing when preScreen is null', () {
      controller.updatePreScreenCard(
          0, const PreScreenCard(title: '', description: ''));
      expect(controller.questionnaire.value.preScreen, isNull);
    });
  });

  // ── removePreScreenCard ─────────────────────────────────────

  group('removePreScreenCard', () {
    test('removes the card at given index', () {
      controller.enablePreScreen(true);
      controller.addPreScreenCard();
      controller.addPreScreenCard();

      controller.removePreScreenCard(0);

      expect(controller.questionnaire.value.preScreen!.cards.length, 1);
    });

    test('does nothing when preScreen is null', () {
      controller.removePreScreenCard(0);
      expect(controller.questionnaire.value.preScreen, isNull);
    });
  });

  // ── exportJsonPretty ────────────────────────────────────────

  group('exportJsonPretty', () {
    test('returns a valid JSON string', () {
      controller.setTitle('Export Test');
      final jsonStr = controller.exportJsonPretty();
      expect(() => json.decode(jsonStr), returnsNormally);
    });

    test('includes the current title in the output', () {
      controller.setTitle('My Title');
      expect(controller.exportJsonPretty(), contains('My Title'));
    });

    test('output is pretty-printed with indentation', () {
      final jsonStr = controller.exportJsonPretty();
      expect(jsonStr, contains('\n'));
    });
  });

  // ── importJson ──────────────────────────────────────────────

  group('importJson', () {
    test('restores questionnaire from exported JSON (round-trip)', () {
      controller.setTitle('Round Trip');
      controller.setDescription('Testing import');
      controller.addQuestion(QuestionType.textInput);
      final jsonStr = controller.exportJsonPretty();

      controller.newQuestionnaire();
      controller.importJson(jsonStr);

      expect(controller.questionnaire.value.title, 'Round Trip');
      expect(controller.questionnaire.value.description, 'Testing import');
      expect(controller.questionnaire.value.questions.length, 1);
    });

    test('restores id from JSON', () {
      controller.setId('my-survey-id');
      final jsonStr = controller.exportJsonPretty();

      controller.newQuestionnaire();
      controller.importJson(jsonStr);

      expect(controller.questionnaire.value.id, 'my-survey-id');
    });

    test('throws FormatException on invalid JSON', () {
      expect(
        () => controller.importJson('not valid json {{{'),
        throwsA(isA<FormatException>()),
      );
    });
  });
}