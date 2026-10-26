import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:labs_questionnaire_creator/editor/draft_store.dart';
import 'package:labs_questionnaire_creator/editor/editor_controller.dart';
import 'package:labs_questionnaire_creator/editor/editor_session.dart';
import 'package:labs_questionnaire_creator/models/questionnaire.dart';

class _Store extends MemoryDraftStore {
  _Store([super.content]);
  bool fail = false;
  Completer<void>? gate;
  final writes = <String>[];
  @override
  Future<void> write(String content) async {
    writes.add(content);
    if (gate != null && writes.length == 1) await gate!.future;
    if (fail) throw StateError('Storage unavailable');
    await super.write(content);
  }
}

void main() {
  test('restores a draft and starts with a clean undo history', () async {
    final original = EditorController()
      ..setTitle('Recovered survey')
      ..addQuestion(QuestionType.carouselSingleSelect);
    final store = MemoryDraftStore(original.exportJsonPretty());
    original.dispose();
    final session = EditorSession(store: store);
    addTearDown(session.dispose);
    await session.load();
    expect(session.restored, isTrue);
    expect(session.status, DraftStatus.saved);
    expect(session.controller.questionnaire.value.title, 'Recovered survey');
    expect(
      session.controller.questionnaire.value.showByCondition,
      extendedQuestionnaireCondition,
    );
    expect(session.controller.canUndo, isFalse);
    session.controller.setTitle('Edited survey');
    await session.flush();
    expect(jsonDecode(store.content!)['title'], 'Edited survey');
    session.controller.undo();
    await session.flush();
    expect(jsonDecode(store.content!)['title'], 'Recovered survey');
  });
  test(
    'serializes writes so an older draft cannot overwrite a newer edit',
    () async {
      final store = _Store()..gate = Completer<void>();
      final session = EditorSession(store: store);
      addTearDown(session.dispose);
      await session.load();
      session.controller.setTitle('Older edit');
      final first = session.flush();
      await Future<void>.delayed(Duration.zero);
      session.controller.setTitle('Latest edit');
      final second = session.flush();
      expect(session.status, DraftStatus.saving);
      store.gate!.complete();
      await Future.wait([first, second]);
      expect(store.writes.map((content) => jsonDecode(content)['title']), [
        'Older edit',
        'Latest edit',
      ]);
      expect(jsonDecode(store.content!)['title'], 'Latest edit');
      expect(session.status, DraftStatus.saved);
    },
  );
  test(
    'reports write failures and recovers on a later successful save',
    () async {
      final store = _Store()..fail = true;
      final session = EditorSession(store: store);
      addTearDown(session.dispose);
      await session.load();
      session.controller.setTitle('Keep this edit');
      await session.flush();
      expect(session.status, DraftStatus.failed);
      expect(session.error, contains('Export'));
      store.fail = false;
      session.controller.setDescription('Retry with next edit');
      await session.flush();
      expect(session.status, DraftStatus.saved);
      expect(session.error, isNull);
      expect(jsonDecode(store.content!)['title'], 'Keep this edit');
    },
  );
  test(
    'a corrupt draft does not replace the current questionnaire or get overwritten on load',
    () async {
      final store = _Store('{broken');
      final controller = EditorController()..setTitle('Current content');
      final session = EditorSession(store: store, controller: controller);
      addTearDown(session.dispose);
      await session.load();
      expect(controller.questionnaire.value.title, 'Current content');
      expect(session.status, DraftStatus.failed);
      expect(store.writes, isEmpty);
    },
  );
  test(
    'undo and redo restore nested edits, deletion, and ordering; new edits clear redo',
    () {
      final controller = EditorController();
      addTearDown(controller.dispose);
      controller.addQuestion(QuestionType.carouselSingleSelect);
      final question = controller.questionnaire.value.questions.single;
      controller.updateQuestion(
        question.id,
        question.copyWith(
          title: 'Original',
          items: const [
            CarouselItem(
              id: 'a',
              title: 'Item',
              description: 'Details',
              imageUrl: 'https://example.com/a.png',
            ),
          ],
        ),
      );
      final original = controller.questionnaire.value;
      final copyId = controller.duplicateQuestion(question.id);
      final duplicated = controller.questionnaire.value;
      expect(duplicated.questions.map((q) => q.order), [0, 1]);
      expect(duplicated.questions.last.items.single.id, isNot('a'));
      controller.removeQuestion(question.id);
      controller.undo();
      expect(controller.questionnaire.value, duplicated);
      controller.undo();
      expect(controller.questionnaire.value, original);
      controller.redo();
      expect(controller.questionnaire.value.questions.last.id, copyId);
      controller.undo();
      controller.setDescription('New branch');
      expect(controller.canRedo, isFalse);
    },
  );
}
