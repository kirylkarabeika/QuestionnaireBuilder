import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/questionnaire.dart';

class EditorController {
  final _uuid = const Uuid();

  final ValueNotifier<Questionnaire> questionnaire = ValueNotifier(
    _newEmpty(const Uuid().v4()),
  );

  static Questionnaire _newEmpty(String id) =>
      Questionnaire(id: id, title: '', description: '', questions: const []);

  void newQuestionnaire() {
    questionnaire.value = _newEmpty(_uuid.v4());
  }

  void setId(String value) {
    final v = value.trim();

    // enforce a safe Firestore doc id format (letters, numbers, underscore, dash).
    final sanitized = v.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');

    questionnaire.value = questionnaire.value.copyWith(
      id: sanitized.isEmpty ? questionnaire.value.id : sanitized,
    );
  }

  void setTitle(String title) {
    questionnaire.value = questionnaire.value.copyWith(title: title);
  }

  void setDescription(String desc) {
    questionnaire.value = questionnaire.value.copyWith(description: desc);
  }

  void setDateLabel(String? value) {
    final v = value?.trim();
    questionnaire.value = questionnaire.value.copyWith(
      dateLabel: (v == null || v.isEmpty) ? null : v,
    );
  }

  void setBackgroundImageUrl(String? value) {
    final v = value?.trim();
    questionnaire.value = questionnaire.value.copyWith(
      backgroundImageUrl: (v == null || v.isEmpty) ? null : v,
    );
  }

  void setSortOrderFromText(String value) {
    final trimmed = value.trim();
    final parsed = int.tryParse(trimmed);
    if (parsed == null) return;

    questionnaire.value = questionnaire.value.copyWith(sortOrder: parsed);
  }

  void setActiveFrom(DateTime? value) {
    final currentTo = questionnaire.value.activeTo;
    DateTime? newTo = currentTo;
    if (value != null && currentTo != null && value.isAfter(currentTo)) {
      newTo = value;
    }
    questionnaire.value = questionnaire.value.copyWith(
      activeFrom: value,
      activeTo: newTo,
    );
  }

  void setActiveTo(DateTime? value) {
    final currentFrom = questionnaire.value.activeFrom;
    DateTime? newFrom = currentFrom;
    if (value != null && currentFrom != null && value.isBefore(currentFrom)) {
      newFrom = value;
    }
    questionnaire.value = questionnaire.value.copyWith(
      activeFrom: newFrom,
      activeTo: value,
    );
  }

  void addQuestion(QuestionType type) {
    final q = Question(
      id: _uuid.v4(),
      order: questionnaire.value.questions.length,
      title: '',
      type: type,
      options: (type == QuestionType.textInput) ? const [] : [],
    );

    questionnaire.value = questionnaire.value.copyWith(
      questions: [...questionnaire.value.questions, q],
    );
  }

  void updateQuestion(String qId, Question updated) {
    final qs = questionnaire.value.questions
        .map((q) => q.id == qId ? updated : q)
        .toList();
    questionnaire.value = questionnaire.value.copyWith(questions: qs);
  }

  void removeQuestion(String qId) {
    final qs = questionnaire.value.questions.where((q) => q.id != qId).toList();
    questionnaire.value = questionnaire.value.copyWith(
      questions: _reorderQuestions(qs),
    );
  }

  void reorderQuestion(int oldIndex, int newIndex) {
    final qs = [...questionnaire.value.questions];
    if (newIndex > oldIndex) newIndex -= 1;
    final item = qs.removeAt(oldIndex);
    qs.insert(newIndex, item);
    questionnaire.value = questionnaire.value.copyWith(
      questions: _reorderQuestions(qs),
    );
  }

  List<Question> _reorderQuestions(List<Question> qs) {
    return [for (int i = 0; i < qs.length; i++) qs[i].copyWith(order: i)];
  }

  String exportJsonPretty() {
    final map = questionnaire.value.toJson();
    return const JsonEncoder.withIndent('  ').convert(map);
  }

  void importJson(String jsonString) {
    final decoded = json.decode(jsonString) as Map<String, dynamic>;
    questionnaire.value = Questionnaire.fromJson(decoded);
  }
}
