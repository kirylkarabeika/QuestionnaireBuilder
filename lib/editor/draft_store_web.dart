import 'package:web/web.dart' as web;

import 'draft_store_base.dart';

DraftStore createDraftStore() => _BrowserDraftStore();

class _BrowserDraftStore implements DraftStore {
  static const _key = 'questionnaire_builder_draft_v1';

  @override
  Future<String?> read() async => web.window.localStorage.getItem(_key);

  @override
  Future<void> write(String content) async =>
      web.window.localStorage.setItem(_key, content);
}
