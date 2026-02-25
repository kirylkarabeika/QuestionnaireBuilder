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

 String get id; String get title; String get description; String? get dateLabel; String? get backgroundImageUrl; int get sortOrder; bool get isActive; bool get isComingSoon;@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime? get activeFrom;@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime? get activeTo; List<Question> get questions;
/// Create a copy of Questionnaire
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionnaireCopyWith<Questionnaire> get copyWith => _$QuestionnaireCopyWithImpl<Questionnaire>(this as Questionnaire, _$identity);

  /// Serializes this Questionnaire to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Questionnaire&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.dateLabel, dateLabel) || other.dateLabel == dateLabel)&&(identical(other.backgroundImageUrl, backgroundImageUrl) || other.backgroundImageUrl == backgroundImageUrl)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isComingSoon, isComingSoon) || other.isComingSoon == isComingSoon)&&(identical(other.activeFrom, activeFrom) || other.activeFrom == activeFrom)&&(identical(other.activeTo, activeTo) || other.activeTo == activeTo)&&const DeepCollectionEquality().equals(other.questions, questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,dateLabel,backgroundImageUrl,sortOrder,isActive,isComingSoon,activeFrom,activeTo,const DeepCollectionEquality().hash(questions));

@override
String toString() {
  return 'Questionnaire(id: $id, title: $title, description: $description, dateLabel: $dateLabel, backgroundImageUrl: $backgroundImageUrl, sortOrder: $sortOrder, isActive: $isActive, isComingSoon: $isComingSoon, activeFrom: $activeFrom, activeTo: $activeTo, questions: $questions)';
}


}

/// @nodoc
abstract mixin class $QuestionnaireCopyWith<$Res>  {
  factory $QuestionnaireCopyWith(Questionnaire value, $Res Function(Questionnaire) _then) = _$QuestionnaireCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, String? dateLabel, String? backgroundImageUrl, int sortOrder, bool isActive, bool isComingSoon,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime? activeFrom,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime? activeTo, List<Question> questions
});




}
/// @nodoc
class _$QuestionnaireCopyWithImpl<$Res>
    implements $QuestionnaireCopyWith<$Res> {
  _$QuestionnaireCopyWithImpl(this._self, this._then);

  final Questionnaire _self;
  final $Res Function(Questionnaire) _then;

/// Create a copy of Questionnaire
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? dateLabel = freezed,Object? backgroundImageUrl = freezed,Object? sortOrder = null,Object? isActive = null,Object? isComingSoon = null,Object? activeFrom = freezed,Object? activeTo = freezed,Object? questions = null,}) {
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
as DateTime?,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<Question>,
  ));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String? dateLabel,  String? backgroundImageUrl,  int sortOrder,  bool isActive,  bool isComingSoon, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime? activeFrom, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime? activeTo,  List<Question> questions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Questionnaire() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.dateLabel,_that.backgroundImageUrl,_that.sortOrder,_that.isActive,_that.isComingSoon,_that.activeFrom,_that.activeTo,_that.questions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String? dateLabel,  String? backgroundImageUrl,  int sortOrder,  bool isActive,  bool isComingSoon, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime? activeFrom, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime? activeTo,  List<Question> questions)  $default,) {final _that = this;
switch (_that) {
case _Questionnaire():
return $default(_that.id,_that.title,_that.description,_that.dateLabel,_that.backgroundImageUrl,_that.sortOrder,_that.isActive,_that.isComingSoon,_that.activeFrom,_that.activeTo,_that.questions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  String? dateLabel,  String? backgroundImageUrl,  int sortOrder,  bool isActive,  bool isComingSoon, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime? activeFrom, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime? activeTo,  List<Question> questions)?  $default,) {final _that = this;
switch (_that) {
case _Questionnaire() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.dateLabel,_that.backgroundImageUrl,_that.sortOrder,_that.isActive,_that.isComingSoon,_that.activeFrom,_that.activeTo,_that.questions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Questionnaire implements Questionnaire {
  const _Questionnaire({required this.id, required this.title, required this.description, this.dateLabel, this.backgroundImageUrl, this.sortOrder = 0, this.isActive = true, this.isComingSoon = false, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) this.activeFrom, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) this.activeTo, final  List<Question> questions = const <Question>[]}): _questions = questions;
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
 final  List<Question> _questions;
@override@JsonKey() List<Question> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}


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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Questionnaire&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.dateLabel, dateLabel) || other.dateLabel == dateLabel)&&(identical(other.backgroundImageUrl, backgroundImageUrl) || other.backgroundImageUrl == backgroundImageUrl)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isComingSoon, isComingSoon) || other.isComingSoon == isComingSoon)&&(identical(other.activeFrom, activeFrom) || other.activeFrom == activeFrom)&&(identical(other.activeTo, activeTo) || other.activeTo == activeTo)&&const DeepCollectionEquality().equals(other._questions, _questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,dateLabel,backgroundImageUrl,sortOrder,isActive,isComingSoon,activeFrom,activeTo,const DeepCollectionEquality().hash(_questions));

@override
String toString() {
  return 'Questionnaire(id: $id, title: $title, description: $description, dateLabel: $dateLabel, backgroundImageUrl: $backgroundImageUrl, sortOrder: $sortOrder, isActive: $isActive, isComingSoon: $isComingSoon, activeFrom: $activeFrom, activeTo: $activeTo, questions: $questions)';
}


}

/// @nodoc
abstract mixin class _$QuestionnaireCopyWith<$Res> implements $QuestionnaireCopyWith<$Res> {
  factory _$QuestionnaireCopyWith(_Questionnaire value, $Res Function(_Questionnaire) _then) = __$QuestionnaireCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, String? dateLabel, String? backgroundImageUrl, int sortOrder, bool isActive, bool isComingSoon,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime? activeFrom,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime? activeTo, List<Question> questions
});




}
/// @nodoc
class __$QuestionnaireCopyWithImpl<$Res>
    implements _$QuestionnaireCopyWith<$Res> {
  __$QuestionnaireCopyWithImpl(this._self, this._then);

  final _Questionnaire _self;
  final $Res Function(_Questionnaire) _then;

/// Create a copy of Questionnaire
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? dateLabel = freezed,Object? backgroundImageUrl = freezed,Object? sortOrder = null,Object? isActive = null,Object? isComingSoon = null,Object? activeFrom = freezed,Object? activeTo = freezed,Object? questions = null,}) {
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
as DateTime?,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<Question>,
  ));
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

 String get id; int get order; String get text;
/// Create a copy of Option
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OptionCopyWith<Option> get copyWith => _$OptionCopyWithImpl<Option>(this as Option, _$identity);

  /// Serializes this Option to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Option&&(identical(other.id, id) || other.id == id)&&(identical(other.order, order) || other.order == order)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,order,text);

@override
String toString() {
  return 'Option(id: $id, order: $order, text: $text)';
}


}

/// @nodoc
abstract mixin class $OptionCopyWith<$Res>  {
  factory $OptionCopyWith(Option value, $Res Function(Option) _then) = _$OptionCopyWithImpl;
@useResult
$Res call({
 String id, int order, String text
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? order = null,Object? text = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int order,  String text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Option() when $default != null:
return $default(_that.id,_that.order,_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int order,  String text)  $default,) {final _that = this;
switch (_that) {
case _Option():
return $default(_that.id,_that.order,_that.text);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int order,  String text)?  $default,) {final _that = this;
switch (_that) {
case _Option() when $default != null:
return $default(_that.id,_that.order,_that.text);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Option implements Option {
  const _Option({required this.id, this.order = 0, required this.text});
  factory _Option.fromJson(Map<String, dynamic> json) => _$OptionFromJson(json);

@override final  String id;
@override@JsonKey() final  int order;
@override final  String text;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Option&&(identical(other.id, id) || other.id == id)&&(identical(other.order, order) || other.order == order)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,order,text);

@override
String toString() {
  return 'Option(id: $id, order: $order, text: $text)';
}


}

/// @nodoc
abstract mixin class _$OptionCopyWith<$Res> implements $OptionCopyWith<$Res> {
  factory _$OptionCopyWith(_Option value, $Res Function(_Option) _then) = __$OptionCopyWithImpl;
@override @useResult
$Res call({
 String id, int order, String text
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? order = null,Object? text = null,}) {
  return _then(_Option(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
