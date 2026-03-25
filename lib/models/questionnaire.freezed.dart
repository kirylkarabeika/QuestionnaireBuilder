// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'questionnaire.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Questionnaire {

 String get id; String get title; String get description; String? get dateLabel; String? get backgroundImageUrl; int get sortOrder; bool get isActive; bool get isComingSoon;@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime? get activeFrom;@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime? get activeTo; String? get showByCondition; List<Question> get questions; PreScreen? get preScreen;
/// Create a copy of Questionnaire
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionnaireCopyWith<Questionnaire> get copyWith => _$QuestionnaireCopyWithImpl<Questionnaire>(this as Questionnaire, _$identity);

  /// Serializes this Questionnaire to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Questionnaire&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.dateLabel, dateLabel) || other.dateLabel == dateLabel)&&(identical(other.backgroundImageUrl, backgroundImageUrl) || other.backgroundImageUrl == backgroundImageUrl)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isComingSoon, isComingSoon) || other.isComingSoon == isComingSoon)&&(identical(other.activeFrom, activeFrom) || other.activeFrom == activeFrom)&&(identical(other.activeTo, activeTo) || other.activeTo == activeTo)&&(identical(other.showByCondition, showByCondition) || other.showByCondition == showByCondition)&&const DeepCollectionEquality().equals(other.questions, questions)&&(identical(other.preScreen, preScreen) || other.preScreen == preScreen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,dateLabel,backgroundImageUrl,sortOrder,isActive,isComingSoon,activeFrom,activeTo,showByCondition,const DeepCollectionEquality().hash(questions),preScreen);

@override
String toString() {
  return 'Questionnaire(id: $id, title: $title, description: $description, dateLabel: $dateLabel, backgroundImageUrl: $backgroundImageUrl, sortOrder: $sortOrder, isActive: $isActive, isComingSoon: $isComingSoon, activeFrom: $activeFrom, activeTo: $activeTo, showByCondition: $showByCondition, questions: $questions, preScreen: $preScreen)';
}


}

/// @nodoc
abstract mixin class $QuestionnaireCopyWith<$Res>  {
  factory $QuestionnaireCopyWith(Questionnaire value, $Res Function(Questionnaire) _then) = _$QuestionnaireCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, String? dateLabel, String? backgroundImageUrl, int sortOrder, bool isActive, bool isComingSoon,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime? activeFrom,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime? activeTo, String? showByCondition, List<Question> questions, PreScreen? preScreen
});


$PreScreenCopyWith<$Res>? get preScreen;

}
/// @nodoc
class _$QuestionnaireCopyWithImpl<$Res>
    implements $QuestionnaireCopyWith<$Res> {
  _$QuestionnaireCopyWithImpl(this._self, this._then);

  final Questionnaire _self;
  final $Res Function(Questionnaire) _then;

/// Create a copy of Questionnaire
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? dateLabel = freezed,Object? backgroundImageUrl = freezed,Object? sortOrder = null,Object? isActive = null,Object? isComingSoon = null,Object? activeFrom = freezed,Object? activeTo = freezed,Object? showByCondition = freezed,Object? questions = null,Object? preScreen = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,dateLabel: freezed == dateLabel ? _self.dateLabel : dateLabel // ignore: cast_nullable_to_non_nullable
as String?,backgroundImageUrl: freezed == backgroundImageUrl ? _self.backgroundImageUrl : backgroundImageUrl // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isComingSoon: null == isComingSoon ? _self.isComingSoon : isComingSoon // ignore: cast_nullable_to_non_nullable
as bool,activeFrom: freezed == activeFrom ? _self.activeFrom : activeFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,activeTo: freezed == activeTo ? _self.activeTo : activeTo // ignore: cast_nullable_to_non_nullable
as DateTime?,showByCondition: freezed == showByCondition ? _self.showByCondition : showByCondition // ignore: cast_nullable_to_non_nullable
as String?,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<Question>,preScreen: freezed == preScreen ? _self.preScreen : preScreen // ignore: cast_nullable_to_non_nullable
as PreScreen?,
  ));
}
/// Create a copy of Questionnaire
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PreScreenCopyWith<$Res>? get preScreen {
    if (_self.preScreen == null) {
    return null;
  }

  return $PreScreenCopyWith<$Res>(_self.preScreen!, (value) {
    return _then(_self.copyWith(preScreen: value));
  });
}
}


/// Adds pattern-matching-related methods to [Questionnaire].
extension QuestionnairePatterns on Questionnaire {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Questionnaire value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Questionnaire() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Questionnaire value)  $default,){
final _that = this;
switch (_that) {
case _Questionnaire():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Questionnaire value)?  $default,){
final _that = this;
switch (_that) {
case _Questionnaire() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String? dateLabel,  String? backgroundImageUrl,  int sortOrder,  bool isActive,  bool isComingSoon, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime? activeFrom, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime? activeTo,  String? showByCondition,  List<Question> questions,  PreScreen? preScreen)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Questionnaire() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.dateLabel,_that.backgroundImageUrl,_that.sortOrder,_that.isActive,_that.isComingSoon,_that.activeFrom,_that.activeTo,_that.showByCondition,_that.questions,_that.preScreen);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String? dateLabel,  String? backgroundImageUrl,  int sortOrder,  bool isActive,  bool isComingSoon, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime? activeFrom, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime? activeTo,  String? showByCondition,  List<Question> questions,  PreScreen? preScreen)  $default,) {final _that = this;
switch (_that) {
case _Questionnaire():
return $default(_that.id,_that.title,_that.description,_that.dateLabel,_that.backgroundImageUrl,_that.sortOrder,_that.isActive,_that.isComingSoon,_that.activeFrom,_that.activeTo,_that.showByCondition,_that.questions,_that.preScreen);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  String? dateLabel,  String? backgroundImageUrl,  int sortOrder,  bool isActive,  bool isComingSoon, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime? activeFrom, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime? activeTo,  String? showByCondition,  List<Question> questions,  PreScreen? preScreen)?  $default,) {final _that = this;
switch (_that) {
case _Questionnaire() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.dateLabel,_that.backgroundImageUrl,_that.sortOrder,_that.isActive,_that.isComingSoon,_that.activeFrom,_that.activeTo,_that.showByCondition,_that.questions,_that.preScreen);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Questionnaire implements Questionnaire {
  const _Questionnaire({required this.id, required this.title, required this.description, this.dateLabel, this.backgroundImageUrl, this.sortOrder = 0, this.isActive = true, this.isComingSoon = false, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) this.activeFrom, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) this.activeTo, this.showByCondition, final  List<Question> questions = const <Question>[], this.preScreen}): _questions = questions;
  factory _Questionnaire.fromJson(Map<String, dynamic> json) => _$QuestionnaireFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
@override final  String? dateLabel;
@override final  String? backgroundImageUrl;
@override@JsonKey() final  int sortOrder;
@override@JsonKey() final  bool isActive;
@override@JsonKey() final  bool isComingSoon;
@override@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) final  DateTime? activeFrom;
@override@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) final  DateTime? activeTo;
@override final  String? showByCondition;
 final  List<Question> _questions;
@override@JsonKey() List<Question> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}

@override final  PreScreen? preScreen;

/// Create a copy of Questionnaire
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionnaireCopyWith<_Questionnaire> get copyWith => __$QuestionnaireCopyWithImpl<_Questionnaire>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionnaireToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Questionnaire&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.dateLabel, dateLabel) || other.dateLabel == dateLabel)&&(identical(other.backgroundImageUrl, backgroundImageUrl) || other.backgroundImageUrl == backgroundImageUrl)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isComingSoon, isComingSoon) || other.isComingSoon == isComingSoon)&&(identical(other.activeFrom, activeFrom) || other.activeFrom == activeFrom)&&(identical(other.activeTo, activeTo) || other.activeTo == activeTo)&&(identical(other.showByCondition, showByCondition) || other.showByCondition == showByCondition)&&const DeepCollectionEquality().equals(other._questions, _questions)&&(identical(other.preScreen, preScreen) || other.preScreen == preScreen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,dateLabel,backgroundImageUrl,sortOrder,isActive,isComingSoon,activeFrom,activeTo,showByCondition,const DeepCollectionEquality().hash(_questions),preScreen);

@override
String toString() {
  return 'Questionnaire(id: $id, title: $title, description: $description, dateLabel: $dateLabel, backgroundImageUrl: $backgroundImageUrl, sortOrder: $sortOrder, isActive: $isActive, isComingSoon: $isComingSoon, activeFrom: $activeFrom, activeTo: $activeTo, showByCondition: $showByCondition, questions: $questions, preScreen: $preScreen)';
}


}

/// @nodoc
abstract mixin class _$QuestionnaireCopyWith<$Res> implements $QuestionnaireCopyWith<$Res> {
  factory _$QuestionnaireCopyWith(_Questionnaire value, $Res Function(_Questionnaire) _then) = __$QuestionnaireCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, String? dateLabel, String? backgroundImageUrl, int sortOrder, bool isActive, bool isComingSoon,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime? activeFrom,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime? activeTo, String? showByCondition, List<Question> questions, PreScreen? preScreen
});


@override $PreScreenCopyWith<$Res>? get preScreen;

}
/// @nodoc
class __$QuestionnaireCopyWithImpl<$Res>
    implements _$QuestionnaireCopyWith<$Res> {
  __$QuestionnaireCopyWithImpl(this._self, this._then);

  final _Questionnaire _self;
  final $Res Function(_Questionnaire) _then;

/// Create a copy of Questionnaire
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? dateLabel = freezed,Object? backgroundImageUrl = freezed,Object? sortOrder = null,Object? isActive = null,Object? isComingSoon = null,Object? activeFrom = freezed,Object? activeTo = freezed,Object? showByCondition = freezed,Object? questions = null,Object? preScreen = freezed,}) {
  return _then(_Questionnaire(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,dateLabel: freezed == dateLabel ? _self.dateLabel : dateLabel // ignore: cast_nullable_to_non_nullable
as String?,backgroundImageUrl: freezed == backgroundImageUrl ? _self.backgroundImageUrl : backgroundImageUrl // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isComingSoon: null == isComingSoon ? _self.isComingSoon : isComingSoon // ignore: cast_nullable_to_non_nullable
as bool,activeFrom: freezed == activeFrom ? _self.activeFrom : activeFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,activeTo: freezed == activeTo ? _self.activeTo : activeTo // ignore: cast_nullable_to_non_nullable
as DateTime?,showByCondition: freezed == showByCondition ? _self.showByCondition : showByCondition // ignore: cast_nullable_to_non_nullable
as String?,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<Question>,preScreen: freezed == preScreen ? _self.preScreen : preScreen // ignore: cast_nullable_to_non_nullable
as PreScreen?,
  ));
}

/// Create a copy of Questionnaire
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PreScreenCopyWith<$Res>? get preScreen {
    if (_self.preScreen == null) {
    return null;
  }

  return $PreScreenCopyWith<$Res>(_self.preScreen!, (value) {
    return _then(_self.copyWith(preScreen: value));
  });
}
}


/// @nodoc
mixin _$Question {

 String get id; int get order; String get title; QuestionType get type; bool get isSkippable; List<Option> get options;
/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionCopyWith<Question> get copyWith => _$QuestionCopyWithImpl<Question>(this as Question, _$identity);

  /// Serializes this Question to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Question&&(identical(other.id, id) || other.id == id)&&(identical(other.order, order) || other.order == order)&&(identical(other.title, title) || other.title == title)&&(identical(other.type, type) || other.type == type)&&(identical(other.isSkippable, isSkippable) || other.isSkippable == isSkippable)&&const DeepCollectionEquality().equals(other.options, options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,order,title,type,isSkippable,const DeepCollectionEquality().hash(options));

@override
String toString() {
  return 'Question(id: $id, order: $order, title: $title, type: $type, isSkippable: $isSkippable, options: $options)';
}


}

/// @nodoc
abstract mixin class $QuestionCopyWith<$Res>  {
  factory $QuestionCopyWith(Question value, $Res Function(Question) _then) = _$QuestionCopyWithImpl;
@useResult
$Res call({
 String id, int order, String title, QuestionType type, bool isSkippable, List<Option> options
});




}
/// @nodoc
class _$QuestionCopyWithImpl<$Res>
    implements $QuestionCopyWith<$Res> {
  _$QuestionCopyWithImpl(this._self, this._then);

  final Question _self;
  final $Res Function(Question) _then;

/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? order = null,Object? title = null,Object? type = null,Object? isSkippable = null,Object? options = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as QuestionType,isSkippable: null == isSkippable ? _self.isSkippable : isSkippable // ignore: cast_nullable_to_non_nullable
as bool,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<Option>,
  ));
}

}


/// Adds pattern-matching-related methods to [Question].
extension QuestionPatterns on Question {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Question value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Question() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Question value)  $default,){
final _that = this;
switch (_that) {
case _Question():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Question value)?  $default,){
final _that = this;
switch (_that) {
case _Question() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int order,  String title,  QuestionType type,  bool isSkippable,  List<Option> options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Question() when $default != null:
return $default(_that.id,_that.order,_that.title,_that.type,_that.isSkippable,_that.options);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int order,  String title,  QuestionType type,  bool isSkippable,  List<Option> options)  $default,) {final _that = this;
switch (_that) {
case _Question():
return $default(_that.id,_that.order,_that.title,_that.type,_that.isSkippable,_that.options);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int order,  String title,  QuestionType type,  bool isSkippable,  List<Option> options)?  $default,) {final _that = this;
switch (_that) {
case _Question() when $default != null:
return $default(_that.id,_that.order,_that.title,_that.type,_that.isSkippable,_that.options);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Question implements Question {
  const _Question({required this.id, this.order = 0, required this.title, required this.type, this.isSkippable = true, final  List<Option> options = const <Option>[]}): _options = options;
  factory _Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);

@override final  String id;
@override@JsonKey() final  int order;
@override final  String title;
@override final  QuestionType type;
@override@JsonKey() final  bool isSkippable;
 final  List<Option> _options;
@override@JsonKey() List<Option> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}


/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionCopyWith<_Question> get copyWith => __$QuestionCopyWithImpl<_Question>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Question&&(identical(other.id, id) || other.id == id)&&(identical(other.order, order) || other.order == order)&&(identical(other.title, title) || other.title == title)&&(identical(other.type, type) || other.type == type)&&(identical(other.isSkippable, isSkippable) || other.isSkippable == isSkippable)&&const DeepCollectionEquality().equals(other._options, _options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,order,title,type,isSkippable,const DeepCollectionEquality().hash(_options));

@override
String toString() {
  return 'Question(id: $id, order: $order, title: $title, type: $type, isSkippable: $isSkippable, options: $options)';
}


}

/// @nodoc
abstract mixin class _$QuestionCopyWith<$Res> implements $QuestionCopyWith<$Res> {
  factory _$QuestionCopyWith(_Question value, $Res Function(_Question) _then) = __$QuestionCopyWithImpl;
@override @useResult
$Res call({
 String id, int order, String title, QuestionType type, bool isSkippable, List<Option> options
});




}
/// @nodoc
class __$QuestionCopyWithImpl<$Res>
    implements _$QuestionCopyWith<$Res> {
  __$QuestionCopyWithImpl(this._self, this._then);

  final _Question _self;
  final $Res Function(_Question) _then;

/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? order = null,Object? title = null,Object? type = null,Object? isSkippable = null,Object? options = null,}) {
  return _then(_Question(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as QuestionType,isSkippable: null == isSkippable ? _self.isSkippable : isSkippable // ignore: cast_nullable_to_non_nullable
as bool,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<Option>,
  ));
}


}


/// @nodoc
mixin _$Option {

 String get id; int get order; String get text; String? get description; String? get imageUrl;
/// Create a copy of Option
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OptionCopyWith<Option> get copyWith => _$OptionCopyWithImpl<Option>(this as Option, _$identity);

  /// Serializes this Option to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Option&&(identical(other.id, id) || other.id == id)&&(identical(other.order, order) || other.order == order)&&(identical(other.text, text) || other.text == text)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,order,text,description,imageUrl);

@override
String toString() {
  return 'Option(id: $id, order: $order, text: $text, description: $description, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $OptionCopyWith<$Res>  {
  factory $OptionCopyWith(Option value, $Res Function(Option) _then) = _$OptionCopyWithImpl;
@useResult
$Res call({
 String id, int order, String text, String? description, String? imageUrl
});




}
/// @nodoc
class _$OptionCopyWithImpl<$Res>
    implements $OptionCopyWith<$Res> {
  _$OptionCopyWithImpl(this._self, this._then);

  final Option _self;
  final $Res Function(Option) _then;

/// Create a copy of Option
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? order = null,Object? text = null,Object? description = freezed,Object? imageUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Option].
extension OptionPatterns on Option {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Option value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Option() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Option value)  $default,){
final _that = this;
switch (_that) {
case _Option():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Option value)?  $default,){
final _that = this;
switch (_that) {
case _Option() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int order,  String text,  String? description,  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Option() when $default != null:
return $default(_that.id,_that.order,_that.text,_that.description,_that.imageUrl);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int order,  String text,  String? description,  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _Option():
return $default(_that.id,_that.order,_that.text,_that.description,_that.imageUrl);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int order,  String text,  String? description,  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _Option() when $default != null:
return $default(_that.id,_that.order,_that.text,_that.description,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Option implements Option {
  const _Option({required this.id, this.order = 0, required this.text, this.description, this.imageUrl});
  factory _Option.fromJson(Map<String, dynamic> json) => _$OptionFromJson(json);

@override final  String id;
@override@JsonKey() final  int order;
@override final  String text;
@override final  String? description;
@override final  String? imageUrl;

/// Create a copy of Option
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OptionCopyWith<_Option> get copyWith => __$OptionCopyWithImpl<_Option>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Option&&(identical(other.id, id) || other.id == id)&&(identical(other.order, order) || other.order == order)&&(identical(other.text, text) || other.text == text)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,order,text,description,imageUrl);

@override
String toString() {
  return 'Option(id: $id, order: $order, text: $text, description: $description, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$OptionCopyWith<$Res> implements $OptionCopyWith<$Res> {
  factory _$OptionCopyWith(_Option value, $Res Function(_Option) _then) = __$OptionCopyWithImpl;
@override @useResult
$Res call({
 String id, int order, String text, String? description, String? imageUrl
});




}
/// @nodoc
class __$OptionCopyWithImpl<$Res>
    implements _$OptionCopyWith<$Res> {
  __$OptionCopyWithImpl(this._self, this._then);

  final _Option _self;
  final $Res Function(_Option) _then;

/// Create a copy of Option
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? order = null,Object? text = null,Object? description = freezed,Object? imageUrl = freezed,}) {
  return _then(_Option(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PreScreen {

 String get title; String get description; List<PreScreenCard> get cards;
/// Create a copy of PreScreen
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PreScreenCopyWith<PreScreen> get copyWith => _$PreScreenCopyWithImpl<PreScreen>(this as PreScreen, _$identity);

  /// Serializes this PreScreen to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PreScreen&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.cards, cards));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,const DeepCollectionEquality().hash(cards));

@override
String toString() {
  return 'PreScreen(title: $title, description: $description, cards: $cards)';
}


}

/// @nodoc
abstract mixin class $PreScreenCopyWith<$Res>  {
  factory $PreScreenCopyWith(PreScreen value, $Res Function(PreScreen) _then) = _$PreScreenCopyWithImpl;
@useResult
$Res call({
 String title, String description, List<PreScreenCard> cards
});




}
/// @nodoc
class _$PreScreenCopyWithImpl<$Res>
    implements $PreScreenCopyWith<$Res> {
  _$PreScreenCopyWithImpl(this._self, this._then);

  final PreScreen _self;
  final $Res Function(PreScreen) _then;

/// Create a copy of PreScreen
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? description = null,Object? cards = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,cards: null == cards ? _self.cards : cards // ignore: cast_nullable_to_non_nullable
as List<PreScreenCard>,
  ));
}

}


/// Adds pattern-matching-related methods to [PreScreen].
extension PreScreenPatterns on PreScreen {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PreScreen value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PreScreen() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PreScreen value)  $default,){
final _that = this;
switch (_that) {
case _PreScreen():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PreScreen value)?  $default,){
final _that = this;
switch (_that) {
case _PreScreen() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String description,  List<PreScreenCard> cards)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PreScreen() when $default != null:
return $default(_that.title,_that.description,_that.cards);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String description,  List<PreScreenCard> cards)  $default,) {final _that = this;
switch (_that) {
case _PreScreen():
return $default(_that.title,_that.description,_that.cards);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String description,  List<PreScreenCard> cards)?  $default,) {final _that = this;
switch (_that) {
case _PreScreen() when $default != null:
return $default(_that.title,_that.description,_that.cards);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PreScreen implements PreScreen {
  const _PreScreen({required this.title, required this.description, final  List<PreScreenCard> cards = const <PreScreenCard>[]}): _cards = cards;
  factory _PreScreen.fromJson(Map<String, dynamic> json) => _$PreScreenFromJson(json);

@override final  String title;
@override final  String description;
 final  List<PreScreenCard> _cards;
@override@JsonKey() List<PreScreenCard> get cards {
  if (_cards is EqualUnmodifiableListView) return _cards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cards);
}


/// Create a copy of PreScreen
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PreScreenCopyWith<_PreScreen> get copyWith => __$PreScreenCopyWithImpl<_PreScreen>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PreScreenToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PreScreen&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._cards, _cards));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,const DeepCollectionEquality().hash(_cards));

@override
String toString() {
  return 'PreScreen(title: $title, description: $description, cards: $cards)';
}


}

/// @nodoc
abstract mixin class _$PreScreenCopyWith<$Res> implements $PreScreenCopyWith<$Res> {
  factory _$PreScreenCopyWith(_PreScreen value, $Res Function(_PreScreen) _then) = __$PreScreenCopyWithImpl;
@override @useResult
$Res call({
 String title, String description, List<PreScreenCard> cards
});




}
/// @nodoc
class __$PreScreenCopyWithImpl<$Res>
    implements _$PreScreenCopyWith<$Res> {
  __$PreScreenCopyWithImpl(this._self, this._then);

  final _PreScreen _self;
  final $Res Function(_PreScreen) _then;

/// Create a copy of PreScreen
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = null,Object? cards = null,}) {
  return _then(_PreScreen(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,cards: null == cards ? _self._cards : cards // ignore: cast_nullable_to_non_nullable
as List<PreScreenCard>,
  ));
}


}


/// @nodoc
mixin _$PreScreenCard {

 String get title; String? get imageUrl; String get description; String? get buttonTitle; String? get buttonUrl;
/// Create a copy of PreScreenCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PreScreenCardCopyWith<PreScreenCard> get copyWith => _$PreScreenCardCopyWithImpl<PreScreenCard>(this as PreScreenCard, _$identity);

  /// Serializes this PreScreenCard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PreScreenCard&&(identical(other.title, title) || other.title == title)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.buttonTitle, buttonTitle) || other.buttonTitle == buttonTitle)&&(identical(other.buttonUrl, buttonUrl) || other.buttonUrl == buttonUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,imageUrl,description,buttonTitle,buttonUrl);

@override
String toString() {
  return 'PreScreenCard(title: $title, imageUrl: $imageUrl, description: $description, buttonTitle: $buttonTitle, buttonUrl: $buttonUrl)';
}


}

/// @nodoc
abstract mixin class $PreScreenCardCopyWith<$Res>  {
  factory $PreScreenCardCopyWith(PreScreenCard value, $Res Function(PreScreenCard) _then) = _$PreScreenCardCopyWithImpl;
@useResult
$Res call({
 String title, String? imageUrl, String description, String? buttonTitle, String? buttonUrl
});




}
/// @nodoc
class _$PreScreenCardCopyWithImpl<$Res>
    implements $PreScreenCardCopyWith<$Res> {
  _$PreScreenCardCopyWithImpl(this._self, this._then);

  final PreScreenCard _self;
  final $Res Function(PreScreenCard) _then;

/// Create a copy of PreScreenCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? imageUrl = freezed,Object? description = null,Object? buttonTitle = freezed,Object? buttonUrl = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,buttonTitle: freezed == buttonTitle ? _self.buttonTitle : buttonTitle // ignore: cast_nullable_to_non_nullable
as String?,buttonUrl: freezed == buttonUrl ? _self.buttonUrl : buttonUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PreScreenCard].
extension PreScreenCardPatterns on PreScreenCard {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PreScreenCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PreScreenCard() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PreScreenCard value)  $default,){
final _that = this;
switch (_that) {
case _PreScreenCard():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PreScreenCard value)?  $default,){
final _that = this;
switch (_that) {
case _PreScreenCard() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String? imageUrl,  String description,  String? buttonTitle,  String? buttonUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PreScreenCard() when $default != null:
return $default(_that.title,_that.imageUrl,_that.description,_that.buttonTitle,_that.buttonUrl);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String? imageUrl,  String description,  String? buttonTitle,  String? buttonUrl)  $default,) {final _that = this;
switch (_that) {
case _PreScreenCard():
return $default(_that.title,_that.imageUrl,_that.description,_that.buttonTitle,_that.buttonUrl);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String? imageUrl,  String description,  String? buttonTitle,  String? buttonUrl)?  $default,) {final _that = this;
switch (_that) {
case _PreScreenCard() when $default != null:
return $default(_that.title,_that.imageUrl,_that.description,_that.buttonTitle,_that.buttonUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PreScreenCard implements PreScreenCard {
  const _PreScreenCard({required this.title, this.imageUrl, required this.description, this.buttonTitle, this.buttonUrl});
  factory _PreScreenCard.fromJson(Map<String, dynamic> json) => _$PreScreenCardFromJson(json);

@override final  String title;
@override final  String? imageUrl;
@override final  String description;
@override final  String? buttonTitle;
@override final  String? buttonUrl;

/// Create a copy of PreScreenCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PreScreenCardCopyWith<_PreScreenCard> get copyWith => __$PreScreenCardCopyWithImpl<_PreScreenCard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PreScreenCardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PreScreenCard&&(identical(other.title, title) || other.title == title)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.buttonTitle, buttonTitle) || other.buttonTitle == buttonTitle)&&(identical(other.buttonUrl, buttonUrl) || other.buttonUrl == buttonUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,imageUrl,description,buttonTitle,buttonUrl);

@override
String toString() {
  return 'PreScreenCard(title: $title, imageUrl: $imageUrl, description: $description, buttonTitle: $buttonTitle, buttonUrl: $buttonUrl)';
}


}

/// @nodoc
abstract mixin class _$PreScreenCardCopyWith<$Res> implements $PreScreenCardCopyWith<$Res> {
  factory _$PreScreenCardCopyWith(_PreScreenCard value, $Res Function(_PreScreenCard) _then) = __$PreScreenCardCopyWithImpl;
@override @useResult
$Res call({
 String title, String? imageUrl, String description, String? buttonTitle, String? buttonUrl
});




}
/// @nodoc
class __$PreScreenCardCopyWithImpl<$Res>
    implements _$PreScreenCardCopyWith<$Res> {
  __$PreScreenCardCopyWithImpl(this._self, this._then);

  final _PreScreenCard _self;
  final $Res Function(_PreScreenCard) _then;

/// Create a copy of PreScreenCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? imageUrl = freezed,Object? description = null,Object? buttonTitle = freezed,Object? buttonUrl = freezed,}) {
  return _then(_PreScreenCard(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,buttonTitle: freezed == buttonTitle ? _self.buttonTitle : buttonTitle // ignore: cast_nullable_to_non_nullable
as String?,buttonUrl: freezed == buttonUrl ? _self.buttonUrl : buttonUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
