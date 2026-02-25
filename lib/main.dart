import 'package:flutter/material.dart';
import 'editor/editor_controller.dart';
import 'editor/file_io.dart';
import 'models/questionnaire.dart';
import 'widgets/optional_datetime_field.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Questionnaire Builder',
      theme: ThemeData(useMaterial3: true),
      home: const EditorScreen(),
    );
  }
}

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final controller = EditorController();

  final idCtrl = TextEditingController();
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final bgUrlCtrl = TextEditingController();
  final dateLabelCtrl = TextEditingController();
  final sortOrderCtrl = TextEditingController();

  @override
  void dispose() {
    idCtrl.dispose();
    titleCtrl.dispose();
    descCtrl.dispose();
    bgUrlCtrl.dispose();
    dateLabelCtrl.dispose();
    sortOrderCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Questionnaire>(
      valueListenable: controller.questionnaire,
      builder: (context, qn, _) {
        // keep text fields in sync (simple approach)
        if (idCtrl.text != qn.id) {
          idCtrl.text = qn.id;
        }
        titleCtrl.value = titleCtrl.value.copyWith(text: qn.title);
        descCtrl.value = descCtrl.value.copyWith(text: qn.description);
        bgUrlCtrl.value = bgUrlCtrl.value.copyWith(
          text: qn.backgroundImageUrl ?? '',
        );
        dateLabelCtrl.value = dateLabelCtrl.value.copyWith(
          text: qn.dateLabel ?? '',
        );
        final desired = qn.sortOrder.toString();
        if (sortOrderCtrl.text != desired) {
          sortOrderCtrl.text = desired;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Questionnaire Builder'),
            actions: [
              IconButton(
                tooltip: 'New',
                onPressed: controller.newQuestionnaire,
                icon: const Icon(Icons.note_add),
              ),
              IconButton(
                tooltip: 'Open',
                onPressed: () async {
                  final text = await openTextFile();
                  if (text == null) return;
                  controller.importJson(text);
                },
                icon: const Icon(Icons.folder_open),
              ),
              IconButton(
                tooltip: 'Save',
                onPressed: () async {
                  final json = controller.exportJsonPretty();
                  await saveTextFile(
                    suggestedName: '${qn.id}.json',
                    content: json,
                  );
                },
                icon: const Icon(Icons.save),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Left: questionnaire metadata
                SizedBox(
                  width: 420,
                  child: ListView(
                    children: [
                      Text(
                        'Metadata',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: idCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Questionnaire ID (Firestore doc id)',
                          border: OutlineInputBorder(),
                          hintText: 'e.g. survey_2026_01',
                        ),
                        onChanged: controller.setId,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: titleCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: controller.setTitle,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: descCtrl,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: controller.setDescription,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: TextEditingController(
                          text: qn.backgroundImageUrl ?? '',
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Background image URL (optional)',
                          border: OutlineInputBorder(),
                          hintText: 'https://…',
                        ),
                        onChanged: (v) => controller.setBackgroundImageUrl(v),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: dateLabelCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Date label (optional)',
                          border: OutlineInputBorder(),
                          hintText: 'e.g. Jan 2026',
                        ),
                        onChanged: (v) => controller.setDateLabel(v),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: sortOrderCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Sort order',
                          border: OutlineInputBorder(),
                          hintText: '0',
                        ),
                        onChanged: controller.setSortOrderFromText,
                      ),
                      const SizedBox(height: 12),
                      OptionalDateTimeField(
                        label: 'Active from',
                        value: qn.activeFrom,
                        includeTime: true,
                        onChanged: controller.setActiveFrom,
                      ),
                      const SizedBox(height: 12),
                      OptionalDateTimeField(
                        label: 'Active to',
                        value: qn.activeTo,
                        includeTime: true,
                        onChanged: controller.setActiveTo,
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        title: const Text('isActive'),
                        value: qn.isActive,
                        onChanged: (v) =>
                            controller.questionnaire.value = controller
                                .questionnaire
                                .value
                                .copyWith(isActive: v),
                      ),
                      SwitchListTile(
                        title: const Text('isComingSoon'),
                        value: qn.isComingSoon,
                        onChanged: (v) =>
                            controller.questionnaire.value = controller
                                .questionnaire
                                .value
                                .copyWith(isComingSoon: v),
                      ),
                      const Divider(height: 32),
                      Text(
                        'Add Question',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ElevatedButton(
                            onPressed: () => controller.addQuestion(
                              QuestionType.singleSelect,
                            ),
                            child: const Text('Single select'),
                          ),
                          ElevatedButton(
                            onPressed: () => controller.addQuestion(
                              QuestionType.multiSelect,
                            ),
                            child: const Text('Multi select'),
                          ),
                          ElevatedButton(
                            onPressed: () =>
                                controller.addQuestion(QuestionType.textInput),
                            child: const Text('Text input'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Right: questions list
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Questions',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ReorderableListView.builder(
                          itemCount: qn.questions.length,
                          onReorder: controller.reorderQuestion,
                          itemBuilder: (context, index) {
                            final question = qn.questions[index];
                            return Card(
                              key: ValueKey(question.id),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: QuestionCard(
                                  question: question,
                                  onChanged: (updated) => controller
                                      .updateQuestion(question.id, updated),
                                  onDelete: () =>
                                      controller.removeQuestion(question.id),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class QuestionCard extends StatefulWidget {
  const QuestionCard({
    super.key,
    required this.question,
    required this.onChanged,
    required this.onDelete,
  });

  final Question question;
  final ValueChanged<Question> onChanged;
  final VoidCallback onDelete;

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  late final TextEditingController _titleCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.question.title);
  }

  @override
  void didUpdateWidget(covariant QuestionCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the question changed from outside (e.g. import/load), update the field
    if (oldWidget.question.title != widget.question.title &&
        _titleCtrl.text != widget.question.title) {
      _titleCtrl.value = _titleCtrl.value.copyWith(
        text: widget.question.title,
        selection: TextSelection.collapsed(
          offset: widget.question.title.length,
        ),
        composing: TextRange.empty,
      );
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.question;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '#${question.order}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(width: 12),
            Chip(label: Text(question.type.name)),
            const Spacer(),
            IconButton(
              onPressed: widget.onDelete,
              icon: const Icon(Icons.delete),
            ),
            const Icon(Icons.drag_handle),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _titleCtrl,
          decoration: const InputDecoration(
            labelText: 'Question title',
            border: OutlineInputBorder(),
          ),
          onChanged: (v) => widget.onChanged(question.copyWith(title: v)),
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Skippable'),
          value: question.isSkippable,
          onChanged: (v) => widget.onChanged(question.copyWith(isSkippable: v)),
        ),
        if (question.type != QuestionType.textInput) ...[
          const SizedBox(height: 8),
          OptionEditor(
            options: question.options,
            onChanged: (opts) =>
                widget.onChanged(question.copyWith(options: opts)),
          ),
        ],
      ],
    );
  }
}

class OptionEditor extends StatefulWidget {
  const OptionEditor({
    super.key,
    required this.options,
    required this.onChanged,
  });

  final List<Option> options;
  final ValueChanged<List<Option>> onChanged;

  @override
  State<OptionEditor> createState() => _OptionEditorState();
}

class _OptionEditorState extends State<OptionEditor> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _syncControllers();
  }

  @override
  void didUpdateWidget(covariant OptionEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncControllers();
  }

  void _syncControllers() {
    // Create/update controllers for current options
    for (final opt in widget.options) {
      final c = _controllers.putIfAbsent(opt.id, () => TextEditingController());
      if (c.text != opt.text) {
        // Update without breaking cursor too much
        c.value = c.value.copyWith(
          text: opt.text,
          selection: TextSelection.collapsed(offset: opt.text.length),
          composing: TextRange.empty,
        );
      }
    }

    // Dispose controllers for removed options
    final existingIds = widget.options.map((o) => o.id).toSet();
    final removedIds = _controllers.keys
        .where((id) => !existingIds.contains(id))
        .toList();
    for (final id in removedIds) {
      _controllers[id]?.dispose();
      _controllers.remove(id);
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    _controllers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Options', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),

        for (final opt in widget.options)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: ValueKey(opt.id),
                    controller: _controllers[opt.id],
                    decoration: const InputDecoration(
                      labelText: 'Option text',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) {
                      final updated = widget.options
                          .map((o) => o.id == opt.id ? o.copyWith(text: v) : o)
                          .toList();
                      widget.onChanged(updated);
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final updated = widget.options
                        .where((o) => o.id != opt.id)
                        .toList();
                    final renumbered = [
                      for (int i = 0; i < updated.length; i++)
                        updated[i].copyWith(order: i),
                    ];
                    widget.onChanged(renumbered);
                  },
                  icon: const Icon(Icons.remove_circle_outline),
                ),
              ],
            ),
          ),

        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            onPressed: () {
              // Prefer uuid here if you have it available
              final id = DateTime.now().microsecondsSinceEpoch.toString();
              final newOpt = Option(
                id: id,
                order: widget.options.length,
                text: '',
              );
              widget.onChanged([...widget.options, newOpt]);
            },
            icon: const Icon(Icons.add),
            label: const Text('Add option'),
          ),
        ),
      ],
    );
  }
}
