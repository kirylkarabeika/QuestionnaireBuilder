import '../models/questionnaire.dart';
import 'editor_location.dart';

class ContentIssue {
  const ContentIssue(this.message, this.location);
  final String message;
  final EditorLocation location;
}

bool isImageUrl(String value) {
  final uri = Uri.tryParse(value.trim());
  return uri != null &&
      const ['http', 'https'].contains(uri.scheme) &&
      uri.host.isNotEmpty;
}

List<ContentIssue> validateQuestionnaire(Questionnaire questionnaire) {
  final issues = <ContentIssue>[];
  void requiredText(String value, String message, EditorLocation location) {
    if (value.trim().isEmpty) issues.add(ContentIssue(message, location));
  }

  void url(String? value, String label, EditorLocation location) {
    if (value != null && value.trim().isNotEmpty && !isImageUrl(value)) {
      issues.add(
        ContentIssue('Use a full http or https URL for $label.', location),
      );
    }
  }

  requiredText(
    questionnaire.title,
    'Add a questionnaire title.',
    const EditorLocation(ContentKind.setup, field: 'title'),
  );
  url(
    questionnaire.backgroundImageUrl,
    'the questionnaire background',
    const EditorLocation(ContentKind.setup, field: 'image'),
  );
  if (questionnaire.questions.isEmpty) {
    issues.add(
      const ContentIssue(
        'Add at least one question.',
        EditorLocation(ContentKind.question),
      ),
    );
  }
  for (var i = 0; i < questionnaire.questions.length; i++) {
    final question = questionnaire.questions[i];
    final label = 'question ${i + 1}';
    EditorLocation at(ContentKind kind, String field, {String? itemId}) =>
        EditorLocation(
          kind,
          questionId: question.id,
          itemId: itemId,
          field: field,
        );
    requiredText(
      question.title,
      'Add a title for $label.',
      at(ContentKind.question, 'title'),
    );
    url(question.imageUrl, label, at(ContentKind.question, 'image'));
    if (question.type != QuestionType.textInput) {
      if (question.options.isEmpty)
        issues.add(
          ContentIssue(
            'Add answer choices to $label.',
            at(ContentKind.question, 'options'),
          ),
        );
      for (var j = 0; j < question.options.length; j++) {
        final option = question.options[j];
        requiredText(
          option.text,
          'Add text for answer ${j + 1} in $label.',
          at(ContentKind.option, 'title', itemId: option.id),
        );
        if (question.type.supportsAnswerImages) {
          url(
            option.imageUrl,
            'answer ${j + 1} in $label',
            at(ContentKind.option, 'image', itemId: option.id),
          );
        }
      }
    }
  }
  final welcome = questionnaire.preScreen;
  if (welcome != null) {
    requiredText(
      welcome.title,
      'Add a welcome screen title.',
      const EditorLocation(ContentKind.welcome, field: 'title'),
    );
    if (welcome.style == PreScreenStyle.cards) {
      for (var i = 0; i < welcome.cards.length; i++) {
        final card = welcome.cards[i];
        requiredText(
          card.title,
          'Add a title for welcome card ${i + 1}.',
          EditorLocation(ContentKind.welcomeCard, index: i, field: 'title'),
        );
        url(
          card.imageUrl,
          'welcome card ${i + 1}',
          EditorLocation(ContentKind.welcomeCard, index: i, field: 'image'),
        );
        if ((card.buttonTitle ?? '').trim().isNotEmpty &&
            (card.buttonUrl ?? '').trim().isEmpty) {
          issues.add(
            ContentIssue(
              'Add a link for the button on welcome card ${i + 1}.',
              EditorLocation(
                ContentKind.welcomeCard,
                index: i,
                field: 'buttonUrl',
              ),
            ),
          );
        }
        url(
          card.buttonUrl,
          'the button on welcome card ${i + 1}',
          EditorLocation(ContentKind.welcomeCard, index: i, field: 'buttonUrl'),
        );
      }
    } else {
      for (var i = 0; i < welcome.items.length; i++) {
        final item = welcome.items[i];
        requiredText(
          item.title,
          'Add text for welcome item ${i + 1}.',
          EditorLocation(ContentKind.welcomeItem, index: i, field: 'title'),
        );
        url(
          item.iconUrl,
          'welcome item ${i + 1}',
          EditorLocation(ContentKind.welcomeItem, index: i, field: 'image'),
        );
      }
    }
  }
  return issues;
}
