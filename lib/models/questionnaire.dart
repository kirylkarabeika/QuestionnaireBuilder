import 'package:freezed_annotation/freezed_annotation.dart';

part 'questionnaire.freezed.dart';
part 'questionnaire.g.dart';

DateTime? _dateFromJson(Object? json) =>
    json == null ? null : DateTime.parse(json as String).toLocal();

String? _dateToJson(DateTime? date) => date?.toUtc().toIso8601String();

const extendedQuestionnaireCondition = 'extended_questionnaire';

@freezed
abstract class Questionnaire with _$Questionnaire {
  const factory Questionnaire({
    required String id,
    required String title,
    required String description,
    String? dateLabel,
    String? backgroundImageUrl,
    @Default(0) int sortOrder,
    @Default(true) bool isActive,
    @Default(false) bool isComingSoon,
    @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime? activeFrom,
    @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime? activeTo,
    String? showByCondition,
    @Default(true) bool showNotSeenMarker,
    @Default(<Question>[]) List<Question> questions,
    PreScreen? preScreen,
  }) = _Questionnaire;

  factory Questionnaire.fromJson(Map<String, dynamic> json) =>
      _$QuestionnaireFromJson(json);
}

@freezed
abstract class Question with _$Question {
  const factory Question({
    required String id,
    @Default(0) int order,
    required String title,
    String? description,
    String? imageUrl,
    required QuestionType type,
    @Default(true) bool isSkippable,
    @Default(<Option>[]) List<Option> options,
  }) = _Question;

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
}

@freezed
abstract class Option with _$Option {
  const factory Option({
    required String id,
    @Default(0) int order,
    required String text,
    String? description,
    String? imageUrl,
  }) = _Option;

  factory Option.fromJson(Map<String, dynamic> json) => _$OptionFromJson(json);
}

enum QuestionType {
  @JsonValue('single_select')
  singleSelect,
  @JsonValue('multi_select')
  multiSelect,
  @JsonValue('text_input')
  textInput,
  @JsonValue('prominent_single_select')
  prominentSingleSelect,
  @JsonValue('carousel_single_select')
  carouselSingleSelect,
  @JsonValue('carousel_multi_select')
  carouselMultiSelect,
  @JsonValue('star_rating')
  starRating;

  bool get isCarousel =>
      this == carouselSingleSelect || this == carouselMultiSelect;

  bool get allowsMultipleAnswers =>
      this == multiSelect || this == carouselMultiSelect;

  bool get requiresExtendedQuestionnaire => isCarousel || this == starRating;

  bool get supportsAnswerImages => this == prominentSingleSelect || isCarousel;

  bool get supportsAnswerDescriptions =>
      this == prominentSingleSelect || isCarousel || this == starRating;
}

extension QuestionnaireCompatibility on Questionnaire {
  bool get requiresExtendedQuestionnaire =>
      questions.any((question) => question.type.requiresExtendedQuestionnaire);
}

enum PreScreenStyle { cards, list }

@freezed
abstract class PreScreen with _$PreScreen {
  const factory PreScreen({
    required String title,
    required String description,
    @Default(PreScreenStyle.cards) PreScreenStyle style,
    @Default(<PreScreenCard>[]) List<PreScreenCard> cards,
    @Default(<PreScreenItem>[]) List<PreScreenItem> items,
  }) = _PreScreen;

  factory PreScreen.fromJson(Map<String, dynamic> json) =>
      _$PreScreenFromJson(json);
}

@freezed
abstract class PreScreenCard with _$PreScreenCard {
  const factory PreScreenCard({
    required String title,
    String? imageUrl,
    required String description,
    String? buttonTitle,
    String? buttonUrl,
  }) = _PreScreenCard;

  factory PreScreenCard.fromJson(Map<String, dynamic> json) =>
      _$PreScreenCardFromJson(json);
}

@freezed
abstract class PreScreenItem with _$PreScreenItem {
  const factory PreScreenItem({
    required String title,
    @JsonKey(name: 'iconURL') required String iconUrl,
  }) = _PreScreenItem;

  factory PreScreenItem.fromJson(Map<String, dynamic> json) =>
      _$PreScreenItemFromJson(json);
}
