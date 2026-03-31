import 'dart:convert';

import 'package:test/test.dart';
import 'package:labs_questionnaire_creator/models/questionnaire.dart';

/// Round-trip helper: converts [obj] to JSON string and back to a plain
/// `Map<String, dynamic>`, so that nested Freezed objects are fully
/// serialized before being fed back to [fromJson].
Map<String, dynamic> _jsonRoundTrip(Map<String, dynamic> map) =>
    json.decode(json.encode(map)) as Map<String, dynamic>;

void main() {
  group('Questionnaire', () {
    test('creates with required fields', () {
      const q = Questionnaire(id: 'q1', title: 'My Q', description: 'Desc', questions: []);
      expect(q.id, 'q1');
      expect(q.title, 'My Q');
      expect(q.description, 'Desc');
      expect(q.questions, isEmpty);
    });

    test('has correct defaults', () {
      const q = Questionnaire(id: 'x', title: '', description: '', questions: []);
      expect(q.sortOrder, 0);
      expect(q.isActive, isTrue);
      expect(q.isComingSoon, isFalse);
      expect(q.activeFrom, isNull);
      expect(q.activeTo, isNull);
      expect(q.preScreen, isNull);
    });

    test('serializes to/from JSON', () {
      const original = Questionnaire(
        id: 'q1',
        title: 'My Questionnaire',
        description: 'A description',
        sortOrder: 5,
        isActive: false,
        isComingSoon: true,
        questions: [],
      );
      final json = original.toJson();
      final restored = Questionnaire.fromJson(json);
      expect(restored.id, original.id);
      expect(restored.title, original.title);
      expect(restored.description, original.description);
      expect(restored.sortOrder, original.sortOrder);
      expect(restored.isActive, original.isActive);
      expect(restored.isComingSoon, original.isComingSoon);
    });

    test('serializes optional fields to/from JSON', () {
      const original = Questionnaire(
        id: 'q2',
        title: 'T',
        description: 'D',
        dateLabel: 'Created on',
        backgroundImageUrl: 'https://example.com/img.png',
        showByCondition: 'condition_a',
        questions: [],
      );
      final restored = Questionnaire.fromJson(original.toJson());
      expect(restored.dateLabel, original.dateLabel);
      expect(restored.backgroundImageUrl, original.backgroundImageUrl);
      expect(restored.showByCondition, original.showByCondition);
    });

    test('serializes activeFrom/activeTo as UTC ISO 8601', () {
      final from = DateTime(2025, 1, 15, 10, 30);
      final to = DateTime(2025, 6, 20, 18, 0);
      final original = Questionnaire(
        id: 'q3',
        title: 'T',
        description: 'D',
        activeFrom: from,
        activeTo: to,
        questions: const [],
      );
      final json = original.toJson();
      expect(json['activeFrom'] as String, endsWith('Z'));
      expect(json['activeTo'] as String, endsWith('Z'));

      final restored = Questionnaire.fromJson(json);
      expect(restored.activeFrom, isNotNull);
      expect(restored.activeTo, isNotNull);
      // Round-trip preserves the same moment in time
      expect(restored.activeFrom!.toUtc(), from.toUtc());
      expect(restored.activeTo!.toUtc(), to.toUtc());
    });

    test('serializes null dates as null JSON values', () {
      const original = Questionnaire(id: 'q4', title: '', description: '', questions: []);
      final json = original.toJson();
      expect(json['activeFrom'], isNull);
      expect(json['activeTo'], isNull);
    });

    test('serializes with pre-screen', () {
      const preScreen = PreScreen(
        title: 'Welcome',
        description: 'This is the pre-screen',
        cards: [
          PreScreenCard(
            title: 'Card 1',
            description: 'Card description',
            imageUrl: 'https://img.example.com/1.jpg',
            buttonTitle: 'Click me',
            buttonUrl: 'https://example.com',
          ),
        ],
      );
      const original = Questionnaire(
        id: 'q5',
        title: 'T',
        description: 'D',
        questions: [],
        preScreen: preScreen,
      );
      final restored = Questionnaire.fromJson(_jsonRoundTrip(original.toJson()));
      expect(restored.preScreen, isNotNull);
      expect(restored.preScreen!.title, 'Welcome');
      expect(restored.preScreen!.cards, hasLength(1));
      expect(restored.preScreen!.cards.first.buttonTitle, 'Click me');
    });
  });

  group('Question', () {
    test('creates with defaults', () {
      const q = Question(id: 'q1', title: 'My question', type: QuestionType.singleSelect);
      expect(q.order, 0);
      expect(q.isSkippable, isTrue);
      expect(q.options, isEmpty);
    });

    test('serializes to/from JSON', () {
      const original = Question(
        id: 'q1',
        order: 2,
        title: 'Pick one',
        type: QuestionType.singleSelect,
        isSkippable: false,
        options: [Option(id: 'o1', text: 'Yes', order: 0)],
      );
      final restored = Question.fromJson(_jsonRoundTrip(original.toJson()));
      expect(restored.id, original.id);
      expect(restored.order, original.order);
      expect(restored.title, original.title);
      expect(restored.type, original.type);
      expect(restored.isSkippable, original.isSkippable);
      expect(restored.options, hasLength(1));
      expect(restored.options.first.text, 'Yes');
    });

    test('serializes all QuestionType values', () {
      final types = QuestionType.values;
      for (final type in types) {
        final q = Question(id: 'q', title: 't', type: type);
        final restored = Question.fromJson(_jsonRoundTrip(q.toJson()));
        expect(restored.type, type, reason: 'Failed for type $type');
      }
    });
  });

  group('QuestionType JSON values', () {
    test('singleSelect serializes as single_select', () {
      const q = Question(id: 'x', title: '', type: QuestionType.singleSelect);
      expect(q.toJson()['type'], 'single_select');
    });

    test('multiSelect serializes as multi_select', () {
      const q = Question(id: 'x', title: '', type: QuestionType.multiSelect);
      expect(q.toJson()['type'], 'multi_select');
    });

    test('textInput serializes as text_input', () {
      const q = Question(id: 'x', title: '', type: QuestionType.textInput);
      expect(q.toJson()['type'], 'text_input');
    });

    test('prominentSingleSelect serializes as prominent_single_select', () {
      const q = Question(id: 'x', title: '', type: QuestionType.prominentSingleSelect);
      expect(q.toJson()['type'], 'prominent_single_select');
    });
  });

  group('Option', () {
    test('creates with required fields', () {
      const o = Option(id: 'o1', text: 'Option A');
      expect(o.id, 'o1');
      expect(o.text, 'Option A');
      expect(o.order, 0);
      expect(o.description, isNull);
      expect(o.imageUrl, isNull);
    });

    test('serializes to/from JSON', () {
      const original = Option(
        id: 'o1',
        order: 3,
        text: 'My option',
        description: 'Some desc',
        imageUrl: 'https://example.com/img.jpg',
      );
      final restored = Option.fromJson(original.toJson());
      expect(restored.id, original.id);
      expect(restored.order, original.order);
      expect(restored.text, original.text);
      expect(restored.description, original.description);
      expect(restored.imageUrl, original.imageUrl);
    });
  });

  group('PreScreen', () {
    test('creates with defaults', () {
      const ps = PreScreen(title: 'T', description: 'D');
      expect(ps.cards, isEmpty);
    });

    test('serializes to/from JSON', () {
      const original = PreScreen(
        title: 'Pre Screen Title',
        description: 'Pre Screen Desc',
        cards: [
          PreScreenCard(title: 'Card', description: 'Card desc'),
        ],
      );
      final restored = PreScreen.fromJson(_jsonRoundTrip(original.toJson()));
      expect(restored.title, original.title);
      expect(restored.description, original.description);
      expect(restored.cards, hasLength(1));
    });
  });

  group('PreScreenCard', () {
    test('serializes all fields to/from JSON', () {
      const original = PreScreenCard(
        title: 'Card title',
        description: 'Card description',
        imageUrl: 'https://img.example.com/card.jpg',
        buttonTitle: 'Go',
        buttonUrl: 'https://example.com',
      );
      final restored = PreScreenCard.fromJson(original.toJson());
      expect(restored.title, original.title);
      expect(restored.description, original.description);
      expect(restored.imageUrl, original.imageUrl);
      expect(restored.buttonTitle, original.buttonTitle);
      expect(restored.buttonUrl, original.buttonUrl);
    });

    test('optional fields serialize as null', () {
      const original = PreScreenCard(title: 'T', description: 'D');
      final json = original.toJson();
      expect(json['imageUrl'], isNull);
      expect(json['buttonTitle'], isNull);
      expect(json['buttonUrl'], isNull);
    });
  });
}
