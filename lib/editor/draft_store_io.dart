import 'dart:io';

import 'draft_store_base.dart';

DraftStore createDraftStore() => _FileDraftStore();

class _FileDraftStore implements DraftStore {
  File get file {
    final environment = Platform.environment;
    final home =
        environment['HOME'] ??
        environment['USERPROFILE'] ??
        Directory.current.path;
    final base = Platform.isMacOS
        ? '$home/Library/Application Support'
        : Platform.isWindows
        ? environment['APPDATA'] ?? home
        : environment['XDG_STATE_HOME'] ?? '$home/.local/state';
    return File('$base/labs_questionnaire_creator/draft.json');
  }

  @override
  Future<String?> read() async {
    final draft = file;
    return await draft.exists() ? draft.readAsString() : null;
  }

  @override
  Future<void> write(String content) async {
    final draft = file;
    await draft.parent.create(recursive: true);
    final temporary = File('${draft.path}.tmp');
    await temporary.writeAsString(content, flush: true);
    await temporary.rename(draft.path);
  }
}
