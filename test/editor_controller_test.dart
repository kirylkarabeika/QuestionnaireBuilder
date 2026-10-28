import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:labs_questionnaire_creator/editor/editor_controller.dart';
import 'package:labs_questionnaire_creator/models/questionnaire.dart';

void main() {
  late EditorController controller;

  setUp(() {
    controller = EditorController();
  });

  tearDown(() {
    controller.dispose();
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

  // ── setShowNotSeenMarker ───────────────────────────────────

  group('setShowNotSeenMarker', () {
    test('defaults to true', () {
      expect(controller.questionnaire.value.showNotSeenMarker, isTrue);
    });

    test('updates the flag', () {
      controller.setShowNotSeenMarker(false);
      expect(controller.questionnaire.value.showNotSeenMarker, isFalse);
    });
  });

  // ── setBackgroundImageUrl ───────────────────────────────────

  group('setBackgroundImageUrl', () {
    test('sets a valid URL', () {
      controller.setBackgroundImageUrl('https://example.com/img.png');
      expect(
        controller.questionnaire.value.backgroundImageUrl,
        'https://example.com/img.png',
      );
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
      expect(
        controller.questionnaire.value.questions.first.type,
        QuestionType.textInput,
      );
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

  group('extended questions', () {
    const types = {
      'carousel_single_select': QuestionType.carouselSingleSelect,
      'carousel_multi_select': QuestionType.carouselMultiSelect,
      'star_rating': QuestionType.starRating,
    };
    for (final entry in types.entries) {
      test('adding ${entry.key} requires the extended condition', () {
        controller.setShowByCondition('try_new_features');
        controller.addQuestion(entry.value);
        final question = controller.questionnaire.value.questions.single;
        expect(question.type, entry.value);
        expect(question.options, isEmpty);
        expect(question.isSkippable, isTrue);
        expect(
          controller.questionnaire.value.showByCondition,
          extendedQuestionnaireCondition,
        );
        controller.setShowByCondition(null);
        expect(
          controller.questionnaire.value.showByCondition,
          extendedQuestionnaireCondition,
        );
        controller.removeQuestion(question.id);
        controller.setShowByCondition(null);
        expect(controller.questionnaire.value.showByCondition, isNull);
      });
      test('round-trips ${entry.key} using the shared option structure', () {
        controller.importJson(
          jsonEncode({
            'id': 'extended',
            'title': 'Survey',
            'description': '',
            'questions': [
              {
                'id': 'q',
                'title': 'Trip feedback',
                'description': 'Think about your latest drive',
                'imageUrl': 'https://example.com/question.png',
                'type': entry.key,
                'isSkippable': false,
                'options': [
                  {'id': 'a', 'order': 0, 'text': 'Comfort'},
                  {
                    'id': 'b',
                    'order': 1,
                    'text': 'Safety',
                    'description': 'Details\nMore information',
                  },
                ],
              },
            ],
          }),
        );
        final questionnaire = controller.questionnaire.value;
        final question = questionnaire.questions.single;
        expect(question.type, entry.value);
        expect(question.options.map((option) => option.text), [
          'Comfort',
          'Safety',
        ]);
        expect(question.options.first.description, isNull);
        expect(question.options.last.description, 'Details\nMore information');
        expect(question.isSkippable, isFalse);
        final exported = jsonDecode(controller.exportJsonPretty());
        expect(exported['showByCondition'], extendedQuestionnaireCondition);
        final output = exported['questions'][0] as Map;
        expect(output['type'], entry.key);
        expect(output.containsKey('items'), isFalse);
        expect(output.containsKey('starRating'), isFalse);
        expect(output.containsKey('starCount'), isFalse);
        expect(output['options'][1], {
          'id': 'b',
          'order': 1,
          'text': 'Safety',
          'description': 'Details\nMore information',
          'imageUrl': null,
        });
        controller.newQuestionnaire();
        controller.importJson(jsonEncode(exported));
        expect(controller.questionnaire.value, questionnaire);
      });
    }
    test('updating a question type applies the extended condition', () {
      controller.addQuestion(QuestionType.textInput);
      final question = controller.questionnaire.value.questions.single;
      controller.updateQuestion(
        question.id,
        question.copyWith(type: QuestionType.starRating),
      );
      expect(
        controller.questionnaire.value.showByCondition,
        extendedQuestionnaireCondition,
      );
    });
    test('legacy question types keep the selected condition', () {
      controller.setShowByCondition('try_new_features');
      controller.addQuestion(QuestionType.singleSelect);
      expect(
        controller.questionnaire.value.showByCondition,
        'try_new_features',
      );
      controller.setShowByCondition(extendedQuestionnaireCondition);
      final exported = controller.exportJsonPretty();
      controller.newQuestionnaire();
      controller.importJson(exported);
      expect(
        controller.questionnaire.value.showByCondition,
        extendedQuestionnaireCondition,
      );
    });
  });

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

  group('question optional fields', () {
    for (final type in QuestionType.values) {
      test('supports descriptions and image URLs for ${type.name}', () {
        final legacy =
            Question(id: 'question-1', title: 'Question', type: type).toJson()
              ..remove('description')
              ..remove('imageUrl');
        controller.importJson(
          jsonEncode({
            'id': 'survey',
            'title': 'Survey',
            'description': '',
            'questions': [legacy],
          }),
        );
        final question = controller.questionnaire.value.questions.single;
        expect(question.description, isNull);
        expect(question.imageUrl, isNull);

        const description = 'First line\nSecond line.';
        const imageUrl = 'https://example.com/question.png';
        controller.updateQuestion(
          question.id,
          question.copyWith(description: description, imageUrl: imageUrl),
        );
        final exported = controller.exportJsonPretty();
        expect(
          jsonDecode(exported)['questions'][0]['description'],
          description,
        );
        expect(jsonDecode(exported)['questions'][0]['imageUrl'], imageUrl);
        expect(
          (jsonDecode(exported)['questions'][0] as Map).containsKey(
            'selectionMode',
          ),
          isFalse,
        );
        controller.newQuestionnaire();
        controller.importJson(exported);
        final restored = controller.questionnaire.value.questions.single;
        expect(restored.type, type);
        expect(restored.description, description);
        expect(restored.imageUrl, imageUrl);

        controller.updateQuestion(
          restored.id,
          restored.copyWith(description: null, imageUrl: null),
        );
        expect(
          jsonDecode(
            controller.exportJsonPretty(),
          )['questions'][0]['description'],
          isNull,
        );
        expect(
          jsonDecode(controller.exportJsonPretty())['questions'][0]['imageUrl'],
          isNull,
        );
      });
    }
  });

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
      expect(
        controller.questionnaire.value.preScreen!.description,
        'Please read carefully',
      );
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

      expect(
        controller.questionnaire.value.preScreen!.cards.first.title,
        'Card Title',
      );
    });

    test('does nothing when preScreen is null', () {
      controller.updatePreScreenCard(
        0,
        const PreScreenCard(title: '', description: ''),
      );
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

  group('list pre-screen', () {
    test('round-trips items with omitted, null, empty, or populated icons', () {
      for (final icon in <Map<String, dynamic>>[
        {},
        {'iconURL': null},
        {'iconURL': ''},
        {'iconURL': 'https://example.com/key.png'},
      ]) {
        controller.importJson(
          jsonEncode({
            'id': 'survey',
            'title': 'Survey',
            'description': '',
            'preScreen': {
              'title': 'Welcome',
              'description': '',
              'style': 'list',
              'items': [
                {'title': 'Bring your keys', ...icon},
              ],
            },
          }),
        );
        expect(
          controller.questionnaire.value.preScreen!.items.single.iconUrl,
          icon['iconURL'],
        );
        final exported = jsonDecode(controller.exportJsonPretty());
        expect(exported['preScreen']['items'], [
          {'title': 'Bring your keys', 'iconURL': icon['iconURL']},
        ]);
        controller.importJson(jsonEncode(exported));
        expect(
          controller.questionnaire.value.preScreen!.items.single.iconUrl,
          icon['iconURL'],
        );
      }
    });
    test('imports and exports items with the exact iconURL key', () {
      controller.importJson(
        jsonEncode({
          'id': 'list-survey',
          'title': 'Survey',
          'description': '',
          'preScreen': {
            'title': 'Before you start',
            'description': 'Please read',
            'style': 'list',
            'items': [
              {
                'title': 'Have your keys ready',
                'iconURL': 'https://example.com/key.png',
              },
              {
                'title': 'Allow a few minutes',
                'iconURL': 'https://example.com/clock.png',
              },
            ],
          },
        }),
      );

      final preScreen = controller.questionnaire.value.preScreen!;
      expect(preScreen.style, PreScreenStyle.list);
      expect(preScreen.cards, isEmpty);
      expect(preScreen.items.map((item) => item.title), [
        'Have your keys ready',
        'Allow a few minutes',
      ]);
      final exported = jsonDecode(controller.exportJsonPretty());
      expect(exported['preScreen']['style'], 'list');
      expect(exported['preScreen']['items'], [
        {
          'title': 'Have your keys ready',
          'iconURL': 'https://example.com/key.png',
        },
        {
          'title': 'Allow a few minutes',
          'iconURL': 'https://example.com/clock.png',
        },
      ]);

      controller.newQuestionnaire();
      controller.importJson(jsonEncode(exported));
      expect(controller.questionnaire.value.preScreen, preScreen);
    });

    test('imports legacy cards without a style', () {
      controller.importJson(
        jsonEncode({
          'id': 'legacy',
          'title': 'Survey',
          'description': '',
          'preScreen': {
            'title': 'Welcome',
            'description': 'Please read',
            'cards': [
              {
                'title': 'Original card',
                'description': 'Original description',
                'imageUrl': 'https://example.com/card.png',
                'buttonTitle': 'Learn more',
                'buttonUrl': 'https://example.com',
              },
            ],
          },
        }),
      );

      final preScreen = controller.questionnaire.value.preScreen!;
      expect(preScreen.style, PreScreenStyle.cards);
      expect(preScreen.items, isEmpty);
      expect(
        preScreen.cards.single,
        const PreScreenCard(
          title: 'Original card',
          description: 'Original description',
          imageUrl: 'https://example.com/card.png',
          buttonTitle: 'Learn more',
          buttonUrl: 'https://example.com',
        ),
      );
    });

    test('edits and removes items while preserving content across styles', () {
      controller.enablePreScreen(true);
      controller.addPreScreenCard();
      const card = PreScreenCard(
        title: 'Keep this card',
        description: 'Details',
      );
      controller.updatePreScreenCard(0, card);
      controller.setPreScreenStyle(PreScreenStyle.list);
      controller.addPreScreenItem();
      controller.addPreScreenItem();
      const item = PreScreenItem(
        title: 'Keep this item',
        iconUrl: 'https://example.com/icon.png',
      );
      controller.updatePreScreenItem(1, item);
      controller.removePreScreenItem(0);
      controller.setPreScreenStyle(PreScreenStyle.cards);

      final exported = controller.exportJsonPretty();
      controller.newQuestionnaire();
      controller.importJson(exported);
      expect(controller.questionnaire.value.preScreen!.cards, [card]);
      controller.setPreScreenStyle(PreScreenStyle.list);
      expect(controller.questionnaire.value.preScreen!.items, [item]);
    });

    test('does nothing when the pre-screen is disabled', () {
      controller.setPreScreenStyle(PreScreenStyle.list);
      controller.addPreScreenItem();
      controller.updatePreScreenItem(
        0,
        const PreScreenItem(title: '', iconUrl: ''),
      );
      controller.removePreScreenItem(0);

      expect(controller.questionnaire.value.preScreen, isNull);
    });
  });

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

    test('defaults showNotSeenMarker to true for older JSON', () {
      controller.importJson(
        '{"id":"legacy","title":"Legacy","description":"Imported","questions":[]}',
      );

      expect(controller.questionnaire.value.showNotSeenMarker, isTrue);
    });
  });
}
