import 'dart:async';

import 'package:flutter/foundation.dart';

import 'draft_store.dart';
import 'editor_controller.dart';

enum DraftStatus { loading, saved, saving, failed }

class EditorSession extends ChangeNotifier {
  EditorSession({required this.store, EditorController? controller})
    : controller = controller ?? EditorController();

  final DraftStore store;
  final EditorController controller;
  DraftStatus status = DraftStatus.loading;
  String? error;
  bool restored = false;
  bool _disposed = false;
  bool _pending = false;
  int _revision = 0;
  Timer? _timer;
  Future<void> _writes = Future.value();

  Future<void> load() async {
    try {
      final content = await store.read();
      if (_disposed) return;
      if (content != null) {
        controller.importJson(content);
        controller.resetHistory();
        restored = true;
      }
      status = DraftStatus.saved;
    } catch (_) {
      if (_disposed) return;
      status = DraftStatus.failed;
      error =
          'Could not restore the local draft. You can open a JSON file or start a new questionnaire.';
    }
    if (_disposed) return;
    controller.questionnaire.addListener(_changed);
    notifyListeners();
  }

  void _changed() {
    _revision++;
    _pending = true;
    status = DraftStatus.saving;
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 450), _enqueue);
    notifyListeners();
  }

  void _enqueue() {
    if (!_pending) return;
    _pending = false;
    final content = controller.exportJsonPretty();
    final revision = _revision;
    _writes = _writes.then((_) async {
      try {
        await store.write(content);
        if (!_disposed && revision == _revision) {
          status = DraftStatus.saved;
          error = null;
          notifyListeners();
        }
      } catch (_) {
        if (!_disposed && revision == _revision) {
          status = DraftStatus.failed;
          error =
              'The local draft could not be saved. Export a JSON copy to keep your changes.';
          notifyListeners();
        }
      }
    });
  }

  Future<void> flush() async {
    _timer?.cancel();
    _enqueue();
    await _writes;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _enqueue();
    _disposed = true;
    controller.questionnaire.removeListener(_changed);
    controller.dispose();
    super.dispose();
  }
}
