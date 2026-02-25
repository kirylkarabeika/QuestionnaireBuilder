// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questionnaire.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Questionnaire _$QuestionnaireFromJson(Map<String, dynamic> json) =>
    _Questionnaire(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dateLabel: json['dateLabel'] as String?,
      backgroundImageUrl: json['backgroundImageUrl'] as String?,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      isComingSoon: json['isComingSoon'] as bool? ?? false,
      activeFrom: _dateFromJson(json['activeFrom']),
      activeTo: _dateFromJson(json['activeTo']),
      questions:
          (json['questions'] as List<dynamic>?)
              ?.map((e) => Question.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Question>[],
    );

Map<String, dynamic> _$QuestionnaireToJson(_Questionnaire instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'dateLabel': instance.dateLabel,
      'backgroundImageUrl': instance.backgroundImageUrl,
      'sortOrder': instance.sortOrder,
      'isActive': instance.isActive,
      'isComingSoon': instance.isComingSoon,
      'activeFrom': _dateToJson(instance.activeFrom),
      'activeTo': _dateToJson(instance.activeTo),
      'questions': instance.questions,
    };

_Question _$QuestionFromJson(Map<String, dynamic> json) => _Question(
  id: json['id'] as String,
  order: (json['order'] as num?)?.toInt() ?? 0,
  title: json['title'] as String,
  type: $enumDecode(_$QuestionTypeEnumMap, json['type']),
  isSkippable: json['isSkippable'] as bool? ?? true,
  options:
      (json['options'] as List<dynamic>?)
          ?.map((e) => Option.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Option>[],
);

Map<String, dynamic> _$QuestionToJson(_Question instance) => <String, dynamic>{
  'id': instance.id,
  'order': instance.order,
  'title': instance.title,
  'type': _$QuestionTypeEnumMap[instance.type]!,
  'isSkippable': instance.isSkippable,
  'options': instance.options,
};

const _$QuestionTypeEnumMap = {
  QuestionType.singleSelect: 'single_select',
  QuestionType.multiSelect: 'multi_select',
  QuestionType.textInput: 'text_input',
};

_Option _$OptionFromJson(Map<String, dynamic> json) => _Option(
  id: json['id'] as String,
  order: (json['order'] as num?)?.toInt() ?? 0,
  text: json['text'] as String,
);

Map<String, dynamic> _$OptionToJson(_Option instance) => <String, dynamic>{
  'id': instance.id,
  'order': instance.order,
  'text': instance.text,
};
