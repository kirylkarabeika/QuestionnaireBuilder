import 'dart:convert';

import 'package:test/test.dart';
import 'package:labs_questionnaire_creator/editor/editor_controller.dart';
import 'package:labs_questionnaire_creator/models/questionnaire.dart';

void main() {
  late EditorController controller;

  setUp(() {
    controller = EditorController();
  });

  group('newQuestionnaire', () {
    test('resets to a fresh questionnaire', () {
      controller.setTitle('Old title');
      controller.newQuestionnaire();
      expect(controller.questionnaire.value.title, '');
      expect(controller.questionnaire.value.questions, isEmpty);
    });

    test('generates a new id each call', () {
      final id1 = controller.questionnaire.value.id;
      controller.newQuestionnaire();
      final id2 = controller.questionnaire.value.id;
      expect(id1, isNotEmpty);
      expect(id2, isNotEmpty);
      expect(id1, isNot(equals(id2)));
    });
  });

  group('setId', () {
    test('sets id with allowed characters', () {
      controller.setId('my_questionnaire-1');
      expect(controller.questionnaire.value.id, 'my_questionnaire-1');
    });

    test('sanitizes special characters to underscores', () {
      controller.setId('hello world!@#');
      expect(controller.questionnaire.value.id, 'hello_world___');
    });

    test('trims whitespace before sanitizing', () {
      controller.setId('  my id  ');
      expect(controller.questionnaire.value.id, '__my_id__');
    });

    test('does not change id when value is empty after trim', () {
      final originalId = controller.questionnaire.value.id;
      controller.setId('   ');
      expect(controller.questionnaire.value.id, originalId);
    });
  });

  group('setTitle', () {
    test('updates title', () {
      controller.setTitle('New Title');
      expect(controller.questionnaire.value.title, 'New Title');
    });

    test('allows empty title', () {
      controller.setTitle('Something');
      controller.setTitle('');
      expect(controller.questionnaire.value.title, '');
    });
  });

  group('setDescription', () {
    test('updates description', () {
      controller.setDescription('My description');
      expect(controller.questionnaire.value.description, 'My description');
    });
  });

  group('setDateLabel', () {
    test('sets non-empty trimmed value', () {
      controller.setDateLabel('Created');
      expect(controller.questionnaire.value.dateLabel, 'Created');
    });

    test('trims whitespace', () {
      controller.setDateLabel('  Created  ');
      expect(controller.questionnaire.value.dateLabel, 'Created');
    });

    test('sets null for empty string', () {
      controller.setDateLabel('Label');
      controller.setDateLabel('');
      expect(controller.questionnaire.value.dateLabel, isNull);
    });

    test('sets null for whitespace-only string', () {
      controller.setDateLabel('Label');
      controller.setDateLabel('   ');
      expect(controller.questionnaire.value.dateLabel, isNull);
    });

    test('sets null when null is passed', () {
      controller.setDateLabel('Label');
      controller.setDateLabel(null);
      expect(controller.questionnaire.value.dateLabel, isNull);
    });
  });

  group('setShowByCondition', () {
    test('sets non-empty trimmed value', () {
      controller.setShowByCondition('condition_a');
      expect(controller.questionnaire.value.showByCondition, 'condition_a');
    });

    test('sets null for empty string', () {
      controller.setShowByCondition('condition_a');
      controller.setShowByCondition('');
      expect(controller.questionnaire.value.showByCondition, isNull);
    });
  });

  group('setBackgroundImageUrl', () {
    test('sets non-empty URL', () {
      controller.setBackgroundImageUrl('https://example.com/img.png');
      expect(controller.questionnaire.value.backgroundImageUrl, 'https://example.com/img.png');
    });

    test('sets null for empty string', () {
      controller.setBackgroundImageUrl('https://example.com/img.png');
      controller.setBackgroundImageUrl('');
      expect(controller.questionnaire.value.backgroundImageUrl, isNull);
    });
  });

  group('setSortOrderFromText', () {
    test('sets valid positive integer', () {
      controller.setSortOrderFromText('5');
      expect(controller.questionnaire.value.sortOrder, 5);
    });

    test('sets zero', () {
      controller.setSortOrderFromText('0');
      expect(controller.questionnaire.value.sortOrder, 0);
    });

    test('sets negative integer', () {
      controller.setSortOrderFromText('-3');
      expect(controller.questionnaire.value.sortOrder, -3);
    });

    test('does not update for non-numeric text', () {
      controller.setSortOrderFromText('5');
      controller.setSortOrderFromText('abc');
      expect(controller.questionnaire.value.sortOrder, 5);
    });

    test('does not update for empty string', () {
      controller.setSortOrderFromText('5');
      controller.setSortOrderFromText('');
      expect(controller.questionnaire.value.sortOrder, 5);
    });

    test('does not update for float string', () {
      controller.setSortOrderFromText('5');
      controller.setSortOrderFromText('3.14');
      expect(controller.questionnaire.value.sortOrder, 5);
    });
  });

  group('setActiveFrom / setActiveTo', () {
    test('sets activeFrom independently when no activeTo', () {
      final date = DateTime(2025, 1, 1);
      controller.setActiveFrom(date);
      expect(controller.questionnaire.value.activeFrom, date);
      expect(controller.questionnaire.value.activeTo, isNull);
    });

    test('sets activeTo independently when no activeFrom', () {
      final date = DateTime(2025, 12, 31);
      controller.setActiveTo(date);
      expect(controller.questionnaire.value.activeTo, date);
      expect(controller.questionnaire.value.activeFrom, isNull);
    });

    test('clears activeFrom with null', () {
      controller.setActiveFrom(DateTime(2025, 1, 1));
      controller.setActiveFrom(null);
      expect(controller.questionnaire.value.activeFrom, isNull);
    });

    test('clears activeTo with null', () {
      controller.setActiveTo(DateTime(2025, 12, 31));
      controller.setActiveTo(null);
      expect(controller.questionnaire.value.activeTo, isNull);
    });

    test('setActiveFrom moves activeTo forward when activeFrom is after activeTo', () {
      final to = DateTime(2025, 6, 1);
      controller.setActiveTo(to);
      final newFrom = DateTime(2025, 9, 1);
      controller.setActiveFrom(newFrom);
      // activeTo should be updated to match activeFrom
      expect(controller.questionnaire.value.activeFrom, newFrom);
      expect(controller.questionnaire.value.activeTo, newFrom);
    });

    test('setActiveFrom does not change activeTo when activeFrom is before activeTo', () {
      final to = DateTime(2025, 12, 31);
      controller.setActiveTo(to);
      controller.setActiveFrom(DateTime(2025, 1, 1));
      expect(controller.questionnaire.value.activeTo, to);
    });

    test('setActiveTo moves activeFrom backward when activeTo is before activeFrom', () {
      final from = DateTime(2025, 6, 1);
      controller.setActiveFrom(from);
      final newTo = DateTime(2025, 3, 1);
      controller.setActiveTo(newTo);
      // activeFrom should be updated to match activeTo
      expect(controller.questionnaire.value.activeFrom, newTo);
      expect(controller.questionnaire.value.activeTo, newTo);
    });

    test('setActiveTo does not change activeFrom when activeTo is after activeFrom', () {
      final from = DateTime(2025, 1, 1);
      controller.setActiveFrom(from);
      controller.setActiveTo(DateTime(2025, 12, 31));
      expect(controller.questionnaire.value.activeFrom, from);
    });
  });

  group('addQuestion', () {
    test('adds a single-select question', () {
      controller.addQuestion(QuestionType.singleSelect);
      final qs = controller.questionnaire.value.questions;
      expect(qs, hasLength(1));
      expect(qs.first.type, QuestionType.singleSelect);
    });

    test('assigns sequential order to questions', () {
      controller.addQuestion(QuestionType.singleSelect);
      controller.addQuestion(QuestionType.multiSelect);
      controller.addQuestion(QuestionType.textInput);
      final qs = controller.questionnaire.value.questions;
      expect(qs[0].order, 0);
      expect(qs[1].order, 1);
      expect(qs[2].order, 2);
    });

    test('assigns a unique non-empty id', () {
      controller.addQuestion(QuestionType.singleSelect);
      controller.addQuestion(QuestionType.singleSelect);
      final qs = controller.questionnaire.value.questions;
      expect(qs[0].id, isNotEmpty);
      expect(qs[1].id, isNotEmpty);
      expect(qs[0].id, isNot(equals(qs[1].id)));
    });

    test('adds textInput with empty options', () {
      controller.addQuestion(QuestionType.textInput);
      final q = controller.questionnaire.value.questions.first;
      expect(q.options, isEmpty);
    });
  });

  group('updateQuestion', () {
    test('replaces question with matching id', () {
      controller.addQuestion(QuestionType.singleSelect);
      final original = controller.questionnaire.value.questions.first;
      final updated = original.copyWith(title: 'Updated title');
      controller.updateQuestion(original.id, updated);
      expect(controller.questionnaire.value.questions.first.title, 'Updated title');
    });

    test('leaves other questions unchanged', () {
      controller.addQuestion(QuestionType.singleSelect);
      controller.addQuestion(QuestionType.multiSelect);
      final q1 = controller.questionnaire.value.questions[0];
      final q2 = controller.questionnaire.value.questions[1];
      final updated = q2.copyWith(title: 'Only q2 changed');
      controller.updateQuestion(q2.id, updated);
      expect(controller.questionnaire.value.questions[0].id, q1.id);
      expect(controller.questionnaire.value.questions[1].title, 'Only q2 changed');
    });
  });

  group('removeQuestion', () {
    test('removes question by id', () {
      controller.addQuestion(QuestionType.singleSelect);
      final id = controller.questionnaire.value.questions.first.id;
      controller.removeQuestion(id);
      expect(controller.questionnaire.value.questions, isEmpty);
    });

    test('re-orders remaining questions after removal', () {
      controller.addQuestion(QuestionType.singleSelect);
      controller.addQuestion(QuestionType.multiSelect);
      controller.addQuestion(QuestionType.textInput);
      final qs = controller.questionnaire.value.questions;
      controller.removeQuestion(qs[0].id); // remove first
      final remaining = controller.questionnaire.value.questions;
      expect(remaining, hasLength(2));
      expect(remaining[0].order, 0);
      expect(remaining[1].order, 1);
    });
  });

  group('reorderQuestion', () {
    setUp(() {
      controller.addQuestion(QuestionType.singleSelect); // index 0
      controller.addQuestion(QuestionType.multiSelect); // index 1
      controller.addQuestion(QuestionType.textInput); // index 2
    });

    test('moves item from lower to higher index', () {
      final originalFirst = controller.questionnaire.value.questions[0];
      controller.reorderQuestion(0, 2);
      final qs = controller.questionnaire.value.questions;
      expect(qs[1].type, originalFirst.type);
    });

    test('moves item from higher to lower index', () {
      final originalLast = controller.questionnaire.value.questions[2];
      controller.reorderQuestion(2, 0);
      final qs = controller.questionnaire.value.questions;
      expect(qs[0].type, originalLast.type);
    });

    test('updates order field after reorder', () {
      controller.reorderQuestion(2, 0);
      final qs = controller.questionnaire.value.questions;
      for (int i = 0; i < qs.length; i++) {
        expect(qs[i].order, i, reason: 'order at index $i should be $i');
      }
    });
  });

  group('enablePreScreen', () {
    test('creates default preScreen when enabling', () {
      controller.enablePreScreen(true);
      expect(controller.questionnaire.value.preScreen, isNotNull);
      expect(controller.questionnaire.value.preScreen!.title, '');
    });

    test('preserves existing preScreen when enabling again', () {
      controller.enablePreScreen(true);
      controller.setPreScreenTitle('My Pre-Screen');
      controller.enablePreScreen(true);
      expect(controller.questionnaire.value.preScreen!.title, 'My Pre-Screen');
    });

    test('removes preScreen when disabling', () {
      controller.enablePreScreen(true);
      controller.enablePreScreen(false);
      expect(controller.questionnaire.value.preScreen, isNull);
    });
  });

  group('setPreScreenTitle / setPreScreenDescription', () {
    setUp(() => controller.enablePreScreen(true));

    test('setPreScreenTitle updates title', () {
      controller.setPreScreenTitle('Welcome!');
      expect(controller.questionnaire.value.preScreen!.title, 'Welcome!');
    });

    test('setPreScreenDescription updates description', () {
      controller.setPreScreenDescription('Please answer a few questions.');
      expect(controller.questionnaire.value.preScreen!.description, 'Please answer a few questions.');
    });

    test('setPreScreenTitle does nothing when preScreen is null', () {
      controller.enablePreScreen(false);
      controller.setPreScreenTitle('Should not crash');
      expect(controller.questionnaire.value.preScreen, isNull);
    });
  });

  group('addPreScreenCard', () {
    setUp(() => controller.enablePreScreen(true));

    test('adds a card', () {
      controller.addPreScreenCard();
      expect(controller.questionnaire.value.preScreen!.cards, hasLength(1));
    });

    test('adds multiple cards', () {
      controller.addPreScreenCard();
      controller.addPreScreenCard();
      expect(controller.questionnaire.value.preScreen!.cards, hasLength(2));
    });

    test('does nothing when preScreen is null', () {
      controller.enablePreScreen(false);
      controller.addPreScreenCard();
      expect(controller.questionnaire.value.preScreen, isNull);
    });
  });

  group('updatePreScreenCard', () {
    setUp(() {
      controller.enablePreScreen(true);
      controller.addPreScreenCard();
    });

    test('updates the card at the given index', () {
      const updatedCard = PreScreenCard(
        title: 'Updated',
        description: 'Updated desc',
      );
      controller.updatePreScreenCard(0, updatedCard);
      expect(controller.questionnaire.value.preScreen!.cards.first.title, 'Updated');
    });
  });

  group('removePreScreenCard', () {
    setUp(() {
      controller.enablePreScreen(true);
      controller.addPreScreenCard();
      controller.addPreScreenCard();
    });

    test('removes the card at the given index', () {
      controller.removePreScreenCard(0);
      expect(controller.questionnaire.value.preScreen!.cards, hasLength(1));
    });

    test('does nothing when preScreen is null', () {
      controller.enablePreScreen(false);
      controller.removePreScreenCard(0);
      expect(controller.questionnaire.value.preScreen, isNull);
    });
  });

  group('exportJsonPretty / importJson', () {
    test('exportJsonPretty returns valid indented JSON', () {
      controller.setTitle('Export Test');
      controller.addQuestion(QuestionType.singleSelect);
      final json = controller.exportJsonPretty();
      expect(json, contains('"title": "Export Test"'));
      // Check it's pretty-printed (has indentation)
      expect(json, contains('\n'));
    });

    test('importJson restores questionnaire from JSON string', () {
      controller.setTitle('Import Test');
      controller.setDescription('From JSON');
      controller.addQuestion(QuestionType.multiSelect);
      final exported = controller.exportJsonPretty();

      final controller2 = EditorController();
      controller2.importJson(exported);

      expect(controller2.questionnaire.value.title, 'Import Test');
      expect(controller2.questionnaire.value.description, 'From JSON');
      expect(controller2.questionnaire.value.questions, hasLength(1));
      expect(controller2.questionnaire.value.questions.first.type, QuestionType.multiSelect);
    });

    test('round-trip preserves all fields', () {
      controller.setTitle('Round Trip');
      controller.setDescription('Full test');
      controller.setSortOrderFromText('7');
      controller.setDateLabel('Start date');
      controller.setBackgroundImageUrl('https://example.com/bg.jpg');
      controller.setShowByCondition('flag_a');
      controller.setActiveFrom(DateTime(2025, 1, 1));
      controller.setActiveTo(DateTime(2025, 12, 31));
      controller.enablePreScreen(true);
      controller.setPreScreenTitle('Pre title');
      controller.addPreScreenCard();
      controller.addQuestion(QuestionType.singleSelect);

      final exported = controller.exportJsonPretty();
      final controller2 = EditorController();
      controller2.importJson(exported);

      final q = controller2.questionnaire.value;
      expect(q.title, 'Round Trip');
      expect(q.description, 'Full test');
      expect(q.sortOrder, 7);
      expect(q.dateLabel, 'Start date');
      expect(q.backgroundImageUrl, 'https://example.com/bg.jpg');
      expect(q.showByCondition, 'flag_a');
      expect(q.activeFrom!.toUtc(), DateTime(2025, 1, 1).toUtc());
      expect(q.activeTo!.toUtc(), DateTime(2025, 12, 31).toUtc());
      expect(q.preScreen!.title, 'Pre title');
      expect(q.preScreen!.cards, hasLength(1));
      expect(q.questions, hasLength(1));
    });

    test('importJson throws on invalid JSON', () {
      expect(() => controller.importJson('not-valid-json'), throwsA(anything));
    });

    test('exportJsonPretty output is valid JSON', () {
      controller.setTitle('Valid JSON test');
      final jsonString = controller.exportJsonPretty();
      expect(() => jsonDecode(jsonString), returnsNormally);
    });
  });
}
