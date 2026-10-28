import 'package:flutter_test/flutter_test.dart';
import 'package:labs_questionnaire_creator/editor/editor_location.dart';
import 'package:labs_questionnaire_creator/editor/questionnaire_validation.dart';
import 'package:labs_questionnaire_creator/models/questionnaire.dart';

void main() {
  for (final type in [
    QuestionType.singleSelect,
    QuestionType.multiSelect,
    QuestionType.prominentSingleSelect,
    QuestionType.carouselSingleSelect,
    QuestionType.carouselMultiSelect,
    QuestionType.starRating,
  ]) {
    test('validates only supported answer image URLs for ${type.name}', () {
      final questionnaire = Questionnaire(
        id: 'survey',
        title: 'Survey',
        description: '',
        questions: [
          Question(
            id: 'q',
            title: 'Question',
            type: type,
            imageUrl: 'https://example.com/question.png',
            options: const [
              Option(
                id: 'answer',
                text: 'Answer',
                imageUrl: 'not-an-image-url',
              ),
            ],
          ),
        ],
      );
      final issues = validateQuestionnaire(questionnaire);
      if (type == QuestionType.prominentSingleSelect || type.isCarousel) {
        expect(issues, hasLength(1));
        expect(issues.single.message, contains('Use a full http or https URL'));
        expect(issues.single.location.kind, ContentKind.option);
        expect(issues.single.location.itemId, 'answer');
        expect(issues.single.location.field, 'image');
      } else {
        expect(issues, isEmpty);
      }
    });
  }

  for (final type in [
    QuestionType.carouselSingleSelect,
    QuestionType.carouselMultiSelect,
    QuestionType.starRating,
  ]) {
    test('${type.name} requires option text but no description or image', () {
      final questionnaire = Questionnaire(
        id: 'survey',
        title: 'Survey',
        description: '',
        questions: [Question(id: 'q', title: 'Question', type: type)],
      );
      expect(
        validateQuestionnaire(questionnaire).single.location.field,
        'options',
      );
      final question = questionnaire.questions.single.copyWith(
        options: const [Option(id: 'answer', text: '  ')],
      );
      final issues = validateQuestionnaire(
        questionnaire.copyWith(questions: [question]),
      );
      expect(issues, hasLength(1));
      expect(issues.single.location.kind, ContentKind.option);
      expect(issues.single.location.questionId, 'q');
      expect(issues.single.location.itemId, 'answer');
      expect(issues.single.location.field, 'title');
      expect(
        validateQuestionnaire(
          questionnaire.copyWith(
            questions: [
              question.copyWith(
                options: const [Option(id: 'answer', text: 'Answer')],
              ),
            ],
          ),
        ),
        isEmpty,
      );
    });
  }
  test(
    'validates all formats while keeping optional descriptions and images optional',
    () {
      final questionnaire = Questionnaire(
        id: 'survey',
        title: 'Survey',
        description: '',
        questions: [
          for (final type in QuestionType.values)
            Question(
              id: type.name,
              title: 'Question',
              type: type,
              options: const [Option(id: 'answer', text: 'Choice')],
            ),
        ],
      );
      expect(validateQuestionnaire(questionnaire), isEmpty);
      expect(isImageUrl('https://example.com/a.png'), isTrue);
      for (final invalid in [
        'image.png',
        'https://',
        'ftp://example.com/a.png',
      ]) {
        expect(isImageUrl(invalid), isFalse);
      }
    },
  );
  test('welcome item icons are optional and validate URLs when provided', () {
    const questionnaire = Questionnaire(
      id: 'survey',
      title: 'Survey',
      description: '',
      questions: [
        Question(id: 'q', title: 'Question', type: QuestionType.textInput),
      ],
      preScreen: PreScreen(
        title: 'Welcome',
        description: '',
        style: PreScreenStyle.list,
      ),
    );
    List<ContentIssue> validateItem(PreScreenItem item) =>
        validateQuestionnaire(
          questionnaire.copyWith(
            preScreen: questionnaire.preScreen!.copyWith(items: [item]),
          ),
        );
    for (final icon in [null, '', '  ', 'https://example.com/key.png']) {
      expect(
        validateItem(PreScreenItem(title: 'Bring your keys', iconUrl: icon)),
        isEmpty,
      );
    }
    final invalid = validateItem(
      const PreScreenItem(title: 'Bring your keys', iconUrl: 'key.png'),
    );
    expect(invalid, hasLength(1));
    expect(invalid.single.location.kind, ContentKind.welcomeItem);
    expect(invalid.single.location.index, 0);
    expect(invalid.single.location.field, 'image');
    final missingText = validateItem(const PreScreenItem(title: '  '));
    expect(missingText, hasLength(1));
    expect(missingText.single.location.field, 'title');
  });
  test(
    'validates only the selected welcome layout and preserves inactive content',
    () {
      const questionnaire = Questionnaire(
        id: 'survey',
        title: 'Survey',
        description: '',
        questions: [
          Question(id: 'q', title: 'Question', type: QuestionType.textInput),
        ],
        preScreen: PreScreen(
          title: 'Welcome',
          description: '',
          style: PreScreenStyle.list,
          cards: [PreScreenCard(title: '', description: '')],
          items: [
            PreScreenItem(
              title: 'Bring your keys',
              iconUrl: 'https://example.com/key.png',
            ),
          ],
        ),
      );
      expect(validateQuestionnaire(questionnaire), isEmpty);
      expect(
        validateQuestionnaire(
          questionnaire.copyWith(
            preScreen: questionnaire.preScreen!.copyWith(
              style: PreScreenStyle.cards,
            ),
          ),
        ).single.location.kind,
        ContentKind.welcomeCard,
      );
    },
  );
}
