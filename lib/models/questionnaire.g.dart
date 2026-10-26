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
      showByCondition: json['showByCondition'] as String?,
      showNotSeenMarker: json['showNotSeenMarker'] as bool? ?? true,
      questions:
          (json['questions'] as List<dynamic>?)
              ?.map((e) => Question.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Question>[],
      preScreen: json['preScreen'] == null
          ? null
          : PreScreen.fromJson(json['preScreen'] as Map<String, dynamic>),
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
      'showByCondition': instance.showByCondition,
      'showNotSeenMarker': instance.showNotSeenMarker,
      'questions': instance.questions,
      'preScreen': instance.preScreen,
    };

_Question _$QuestionFromJson(Map<String, dynamic> json) => _Question(
  id: json['id'] as String,
  order: (json['order'] as num?)?.toInt() ?? 0,
  title: json['title'] as String,
  description: json['description'] as String?,
  imageUrl: json['imageUrl'] as String?,
  type: $enumDecode(_$QuestionTypeEnumMap, json['type']),
  isSkippable: json['isSkippable'] as bool? ?? true,
  options:
      (json['options'] as List<dynamic>?)
          ?.map((e) => Option.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Option>[],
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => CarouselItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <CarouselItem>[],
  starRating: json['starRating'] == null
      ? null
      : StarRating.fromJson(json['starRating'] as Map<String, dynamic>),
);

Map<String, dynamic> _$QuestionToJson(_Question instance) => <String, dynamic>{
  'id': instance.id,
  'order': instance.order,
  'title': instance.title,
  'description': instance.description,
  'imageUrl': instance.imageUrl,
  'type': _$QuestionTypeEnumMap[instance.type]!,
  'isSkippable': instance.isSkippable,
  'options': instance.options,
  'items': instance.items,
  'starRating': instance.starRating,
};

const _$QuestionTypeEnumMap = {
  QuestionType.singleSelect: 'single_select',
  QuestionType.multiSelect: 'multi_select',
  QuestionType.textInput: 'text_input',
  QuestionType.prominentSingleSelect: 'prominent_single_select',
  QuestionType.carouselSingleSelect: 'carousel_single_select',
  QuestionType.carouselMultiSelect: 'carousel_multi_select',
  QuestionType.starRating: 'star_rating',
};

_Option _$OptionFromJson(Map<String, dynamic> json) => _Option(
  id: json['id'] as String,
  order: (json['order'] as num?)?.toInt() ?? 0,
  text: json['text'] as String,
  description: json['description'] as String?,
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$OptionToJson(_Option instance) => <String, dynamic>{
  'id': instance.id,
  'order': instance.order,
  'text': instance.text,
  'description': instance.description,
  'imageUrl': instance.imageUrl,
};

_CarouselItem _$CarouselItemFromJson(Map<String, dynamic> json) =>
    _CarouselItem(
      id: json['id'] as String,
      order: (json['order'] as num?)?.toInt() ?? 0,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$CarouselItemToJson(_CarouselItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order': instance.order,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
    };

_StarRating _$StarRatingFromJson(Map<String, dynamic> json) => _StarRating(
  title: json['title'] as String,
  starCount: json['starCount'] == null
      ? 5
      : _starCountFromJson(json['starCount']),
  description: json['description'] as String,
);

Map<String, dynamic> _$StarRatingToJson(_StarRating instance) =>
    <String, dynamic>{
      'title': instance.title,
      'starCount': instance.starCount,
      'description': instance.description,
    };

_PreScreen _$PreScreenFromJson(Map<String, dynamic> json) => _PreScreen(
  title: json['title'] as String,
  description: json['description'] as String,
  style:
      $enumDecodeNullable(_$PreScreenStyleEnumMap, json['style']) ??
      PreScreenStyle.cards,
  cards:
      (json['cards'] as List<dynamic>?)
          ?.map((e) => PreScreenCard.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <PreScreenCard>[],
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => PreScreenItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <PreScreenItem>[],
);

Map<String, dynamic> _$PreScreenToJson(_PreScreen instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'style': _$PreScreenStyleEnumMap[instance.style]!,
      'cards': instance.cards,
      'items': instance.items,
    };

const _$PreScreenStyleEnumMap = {
  PreScreenStyle.cards: 'cards',
  PreScreenStyle.list: 'list',
};

_PreScreenCard _$PreScreenCardFromJson(Map<String, dynamic> json) =>
    _PreScreenCard(
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String?,
      description: json['description'] as String,
      buttonTitle: json['buttonTitle'] as String?,
      buttonUrl: json['buttonUrl'] as String?,
    );

Map<String, dynamic> _$PreScreenCardToJson(_PreScreenCard instance) =>
    <String, dynamic>{
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'buttonTitle': instance.buttonTitle,
      'buttonUrl': instance.buttonUrl,
    };

_PreScreenItem _$PreScreenItemFromJson(Map<String, dynamic> json) =>
    _PreScreenItem(
      title: json['title'] as String,
      iconUrl: json['iconURL'] as String,
    );

Map<String, dynamic> _$PreScreenItemToJson(_PreScreenItem instance) =>
    <String, dynamic>{'title': instance.title, 'iconURL': instance.iconUrl};
