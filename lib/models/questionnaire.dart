import 'package:freezed_annotation/freezed_annotation.dart';

part 'questionnaire.freezed.dart';
part 'questionnaire.g.dart';

DateTime? _dateFromJson(Object? json) =>
    json == null ? null : DateTime.parse(json as String);

String? _dateToJson(DateTime? date) => date?.toUtc().toIso8601String();

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
    @Default(<Question>[]) List<Question> questions,
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
}
