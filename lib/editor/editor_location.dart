import '../models/questionnaire.dart';

enum EditorSection { setup, questions, review }

enum ContentKind {
  setup,
  welcome,
  question,
  carouselItem,
  option,
  rating,
  welcomeCard,
  welcomeItem,
}

class EditorLocation {
  const EditorLocation(
    this.kind, {
    this.questionId,
    this.itemId,
    this.index,
    this.field,
  });
  final ContentKind kind;
  final String? questionId;
  final String? itemId;
  final int? index;
  final String? field;

  bool get isSetup => const [
    ContentKind.setup,
    ContentKind.welcome,
    ContentKind.welcomeCard,
    ContentKind.welcomeItem,
  ].contains(kind);
  String get key => '${kind.name}:$questionId:$itemId:$index';
}

extension QuestionTypePresentation on QuestionType {
  String get label => switch (this) {
    QuestionType.singleSelect => 'Single choice',
    QuestionType.multiSelect => 'Multiple choice',
    QuestionType.textInput => 'Written answer',
    QuestionType.prominentSingleSelect => 'Image choice',
    QuestionType.carouselSingleSelect => 'Carousel (single choice)',
    QuestionType.carouselMultiSelect => 'Carousel (multiple choice)',
    QuestionType.starRating => 'Star rating',
  };
  String get help => switch (this) {
    QuestionType.singleSelect => 'Choose one answer from a list.',
    QuestionType.multiSelect => 'Choose several answers from a list.',
    QuestionType.textInput => 'Write a free-text answer.',
    QuestionType.prominentSingleSelect =>
      'Choose one answer with an image and description.',
    QuestionType.carouselSingleSelect => 'Browse image cards and choose one.',
    QuestionType.carouselMultiSelect =>
      'Browse image cards and choose several.',
    QuestionType.starRating => 'Rate an experience with stars.',
  };
}
