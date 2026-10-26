abstract class DraftStore {
  Future<String?> read();
  Future<void> write(String content);
}

class MemoryDraftStore implements DraftStore {
  MemoryDraftStore([this.content]);
  String? content;

  @override
  Future<String?> read() async => content;

  @override
  Future<void> write(String content) async => this.content = content;
}
