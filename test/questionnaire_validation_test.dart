import 'package:flutter_test/flutter_test.dart';
import 'package:labs_questionnaire_creator/editor/editor_location.dart';
import 'package:labs_questionnaire_creator/editor/questionnaire_validation.dart';
import 'package:labs_questionnaire_creator/models/questionnaire.dart';

void main() {
  for (final type in [
    QuestionType.singleSelect,
    QuestionType.multiSelect,
    QuestionType.prominentSingleSelect,
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
      if (type == QuestionType.prominentSingleSelect) {
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

  test(
    'points missing carousel content at the exact nested item and field',
    () {
      final issues = validateQuestionnaire(
        const Questionnaire(
          id: 'survey',
          title: 'Survey',
          description: '',
          questions: [
            Question(
              id: 'q',
              title: 'Routes',
              type: QuestionType.carousel,
              items: [
                CarouselItem(id: 'item', title: 'Mountains', imageUrl: ''),
              ],
            ),
          ],
        ),
      );
      expect(issues, hasLength(1));
      expect(issues.single.location.kind, ContentKind.carouselItem);
      expect(issues.single.location.questionId, 'q');
      expect(issues.single.location.itemId, 'item');
      expect(issues.single.location.field, 'image');
    },
  );
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
              items: const [
                CarouselItem(
                  id: 'item',
                  title: 'Item',
                  imageUrl: 'https://example.com/item.png',
                ),
              ],
              starRating: const StarRating(
                title: 'Comfort',
                description: 'More is better',
              ),
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
