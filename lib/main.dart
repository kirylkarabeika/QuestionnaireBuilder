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
  final preScreenTitleCtrl = TextEditingController();
  final preScreenDescCtrl = TextEditingController();

  @override
  void dispose() {
    idCtrl.dispose();
    titleCtrl.dispose();
    descCtrl.dispose();
    bgUrlCtrl.dispose();
    dateLabelCtrl.dispose();
    sortOrderCtrl.dispose();
    preScreenTitleCtrl.dispose();
    preScreenDescCtrl.dispose();
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
        final psTitle = qn.preScreen?.title ?? '';
        if (preScreenTitleCtrl.text != psTitle) {
          preScreenTitleCtrl.value = preScreenTitleCtrl.value.copyWith(
            text: psTitle,
          );
        }
        final psDesc = qn.preScreen?.description ?? '';
        if (preScreenDescCtrl.text != psDesc) {
          preScreenDescCtrl.value = preScreenDescCtrl.value.copyWith(
            text: psDesc,
          );
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
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Row(
              children: [
                // Left: questionnaire metadata
                SizedBox(
                  width: 420,
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 24),
                    children: [
                      Text(
                        'Metadata',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: idCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Questionnaire ID (Firestore doc id)',
                          border: OutlineInputBorder(),
                          hintText: 'e.g. survey_2026_01',
                        ),
                        onChanged: controller.setId,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: titleCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: controller.setTitle,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: descCtrl,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: controller.setDescription,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: bgUrlCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Background image URL (optional)',
                          border: OutlineInputBorder(),
                          hintText: 'https://…',
                        ),
                        onChanged: (v) => controller.setBackgroundImageUrl(v),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: dateLabelCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Date label (optional)',
                          border: OutlineInputBorder(),
                          hintText: 'e.g. Jan 2026',
                        ),
                        onChanged: (v) => controller.setDateLabel(v),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String?>(
                        initialValue: qn.showByCondition,
                        decoration: const InputDecoration(
                          labelText: 'Show by condition',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: null, child: Text('None')),
                          DropdownMenuItem(
                            value: 'try_new_features',
                            child: Text('Try new features section'),
                          ),
                        ],
                        onChanged: (v) => controller.setShowByCondition(v),
                      ),
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 16),
                      OptionalDateTimeField(
                        label: 'Active from',
                        value: qn.activeFrom,
                        includeTime: true,
                        onChanged: controller.setActiveFrom,
                      ),
                      const SizedBox(height: 16),
                      OptionalDateTimeField(
                        label: 'Active to',
                        value: qn.activeTo,
                        includeTime: true,
                        onChanged: controller.setActiveTo,
                      ),
                      const SizedBox(height: 16),
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
                      SwitchListTile(
                        title: const Text('Show not seen marker'),
                        value: qn.showNotSeenMarker,
                        onChanged: controller.setShowNotSeenMarker,
                      ),
                      const Divider(height: 40),
                      // ── Pre-screen ────────────────────────────
                      SwitchListTile(
                        title: const Text('Has pre-screen'),
                        value: qn.preScreen != null,
                        onChanged: controller.enablePreScreen,
                      ),
                      if (qn.preScreen != null) ..._buildPreScreenFields(qn),
                      const Divider(height: 40),
                      Text(
                        'Add Question',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
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
                          ElevatedButton(
                            onPressed: () => controller.addQuestion(
                              QuestionType.prominentSingleSelect,
                            ),
                            child: const Text('Prominent single select'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                // Right: questions list
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Questions',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ReorderableListView.builder(
                          buildDefaultDragHandles: false,
                          itemCount: qn.questions.length,
                          onReorder: controller.reorderQuestion,
                          itemBuilder: (context, index) {
                            final question = qn.questions[index];
                            return Card(
                              key: ValueKey(question.id),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.outlineVariant,
                                ),
                              ),
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: QuestionCard(
                                  index: index,
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

  List<Widget> _buildPreScreenFields(Questionnaire qn) {
    final ps = qn.preScreen!;
    return [
      const SizedBox(height: 16),
      TextField(
        decoration: const InputDecoration(
          labelText: 'Pre-screen title',
          border: OutlineInputBorder(),
        ),
        controller: preScreenTitleCtrl,
        onChanged: controller.setPreScreenTitle,
      ),
      const SizedBox(height: 16),
      TextField(
        decoration: const InputDecoration(
          labelText: 'Pre-screen description',
          border: OutlineInputBorder(),
        ),
        maxLines: 3,
        controller: preScreenDescCtrl,
        onChanged: controller.setPreScreenDescription,
      ),
      const SizedBox(height: 16),
      Text('Cards', style: Theme.of(context).textTheme.titleSmall),
      for (int i = 0; i < ps.cards.length; i++)
        PreScreenCardEditor(
          key: ValueKey('ps_card_$i'),
          card: ps.cards[i],
          index: i,
          onChanged: (c) => controller.updatePreScreenCard(i, c),
          onDelete: () => controller.removePreScreenCard(i),
        ),
      const SizedBox(height: 8),
      Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton.icon(
          onPressed: controller.addPreScreenCard,
          icon: const Icon(Icons.add),
          label: const Text('Add card'),
        ),
      ),
    ];
  }
}

class QuestionCard extends StatefulWidget {
  const QuestionCard({
    super.key,
    required this.index,
    required this.question,
    required this.onChanged,
    required this.onDelete,
  });

  final int index;
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
            ReorderableDragStartListener(
              index: widget.index,
              child: const MouseRegion(
                cursor: SystemMouseCursors.grab,
                child: Icon(Icons.drag_handle),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _titleCtrl,
          decoration: const InputDecoration(
            labelText: 'Question title',
            border: OutlineInputBorder(),
          ),
          onChanged: (v) => widget.onChanged(question.copyWith(title: v)),
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Skippable'),
          value: question.isSkippable,
          onChanged: (v) => widget.onChanged(question.copyWith(isSkippable: v)),
        ),
        if (question.type == QuestionType.prominentSingleSelect) ...[
          const SizedBox(height: 12),
          ProminentOptionEditor(
            options: question.options,
            onChanged: (opts) =>
                widget.onChanged(question.copyWith(options: opts)),
          ),
        ] else if (question.type != QuestionType.textInput) ...[
          const SizedBox(height: 12),
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

// ── Prominent option editor (title + description + imageUrl per option) ──

class ProminentOptionEditor extends StatefulWidget {
  const ProminentOptionEditor({
    super.key,
    required this.options,
    required this.onChanged,
  });

  final List<Option> options;
  final ValueChanged<List<Option>> onChanged;

  @override
  State<ProminentOptionEditor> createState() => _ProminentOptionEditorState();
}

class _ProminentOptionEditorState extends State<ProminentOptionEditor> {
  final Map<String, TextEditingController> _textCtrls = {};
  final Map<String, TextEditingController> _descCtrls = {};
  final Map<String, TextEditingController> _imgCtrls = {};

  @override
  void initState() {
    super.initState();
    _syncControllers();
  }

  @override
  void didUpdateWidget(covariant ProminentOptionEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncControllers();
  }

  void _syncCtrl(
    Map<String, TextEditingController> map,
    String id,
    String value,
  ) {
    final c = map.putIfAbsent(id, () => TextEditingController());
    if (c.text != value) {
      c.value = c.value.copyWith(
        text: value,
        selection: TextSelection.collapsed(offset: value.length),
        composing: TextRange.empty,
      );
    }
  }

  void _syncControllers() {
    for (final opt in widget.options) {
      _syncCtrl(_textCtrls, opt.id, opt.text);
      _syncCtrl(_descCtrls, opt.id, opt.description ?? '');
      _syncCtrl(_imgCtrls, opt.id, opt.imageUrl ?? '');
    }
    final ids = widget.options.map((o) => o.id).toSet();
    for (final map in [_textCtrls, _descCtrls, _imgCtrls]) {
      final removed = map.keys.where((id) => !ids.contains(id)).toList();
      for (final id in removed) {
        map[id]?.dispose();
        map.remove(id);
      }
    }
  }

  @override
  void dispose() {
    for (final map in [_textCtrls, _descCtrls, _imgCtrls]) {
      for (final c in map.values) {
        c.dispose();
      }
      map.clear();
    }
    super.dispose();
  }

  Option _updateOpt(
    String id, {
    String? text,
    String? description,
    String? imageUrl,
  }) {
    final opt = widget.options.firstWhere((o) => o.id == id);
    String? optStr(String? v) => (v != null && v.trim().isEmpty) ? null : v;
    return opt.copyWith(
      text: text ?? opt.text,
      description: optStr(description ?? opt.description),
      imageUrl: optStr(imageUrl ?? opt.imageUrl),
    );
  }

  void _emitUpdate(
    String id, {
    String? text,
    String? description,
    String? imageUrl,
  }) {
    final updated = widget.options
        .map(
          (o) => o.id == id
              ? _updateOpt(
                  id,
                  text: text,
                  description: description,
                  imageUrl: imageUrl,
                )
              : o,
        )
        .toList();
    widget.onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Options', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        for (final opt in widget.options)
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          key: ValueKey('${opt.id}_text'),
                          controller: _textCtrls[opt.id],
                          decoration: const InputDecoration(
                            labelText: 'Title',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (v) => _emitUpdate(opt.id, text: v),
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
                  const SizedBox(height: 12),
                  TextField(
                    key: ValueKey('${opt.id}_desc'),
                    controller: _descCtrls[opt.id],
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => _emitUpdate(opt.id, description: v),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    key: ValueKey('${opt.id}_img'),
                    controller: _imgCtrls[opt.id],
                    decoration: const InputDecoration(
                      labelText: 'Image URL',
                      border: OutlineInputBorder(),
                      hintText: 'https://…',
                    ),
                    onChanged: (v) => _emitUpdate(opt.id, imageUrl: v),
                  ),
                ],
              ),
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            onPressed: () {
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
        const SizedBox(height: 12),

        for (final opt in widget.options)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
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

class PreScreenCardEditor extends StatefulWidget {
  const PreScreenCardEditor({
    super.key,
    required this.card,
    required this.index,
    required this.onChanged,
    required this.onDelete,
  });

  final PreScreenCard card;
  final int index;
  final ValueChanged<PreScreenCard> onChanged;
  final VoidCallback onDelete;

  @override
  State<PreScreenCardEditor> createState() => _PreScreenCardEditorState();
}

class _PreScreenCardEditorState extends State<PreScreenCardEditor> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _imageUrlCtrl;
  late final TextEditingController _btnTitleCtrl;
  late final TextEditingController _btnUrlCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.card.title);
    _descCtrl = TextEditingController(text: widget.card.description);
    _imageUrlCtrl = TextEditingController(text: widget.card.imageUrl ?? '');
    _btnTitleCtrl = TextEditingController(text: widget.card.buttonTitle ?? '');
    _btnUrlCtrl = TextEditingController(text: widget.card.buttonUrl ?? '');
  }

  @override
  void didUpdateWidget(covariant PreScreenCardEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncIfNeeded(_titleCtrl, widget.card.title);
    _syncIfNeeded(_descCtrl, widget.card.description);
    _syncIfNeeded(_imageUrlCtrl, widget.card.imageUrl ?? '');
    _syncIfNeeded(_btnTitleCtrl, widget.card.buttonTitle ?? '');
    _syncIfNeeded(_btnUrlCtrl, widget.card.buttonUrl ?? '');
  }

  void _syncIfNeeded(TextEditingController ctrl, String desired) {
    if (ctrl.text != desired) {
      ctrl.value = ctrl.value.copyWith(
        text: desired,
        selection: TextSelection.collapsed(offset: desired.length),
        composing: TextRange.empty,
      );
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _imageUrlCtrl.dispose();
    _btnTitleCtrl.dispose();
    _btnUrlCtrl.dispose();
    super.dispose();
  }

  PreScreenCard _updated({
    String? title,
    String? description,
    String? imageUrl,
    String? buttonTitle,
    String? buttonUrl,
  }) {
    String? opt(String? v) => (v == null || v.trim().isEmpty) ? null : v;
    return widget.card.copyWith(
      title: title ?? widget.card.title,
      description: description ?? widget.card.description,
      imageUrl: opt(imageUrl ?? widget.card.imageUrl),
      buttonTitle: opt(buttonTitle ?? widget.card.buttonTitle),
      buttonUrl: opt(buttonUrl ?? widget.card.buttonUrl),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Card ${widget.index + 1}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Spacer(),
                IconButton(
                  onPressed: widget.onDelete,
                  icon: const Icon(Icons.delete, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => widget.onChanged(_updated(title: v)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => widget.onChanged(_updated(description: v)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _imageUrlCtrl,
              decoration: const InputDecoration(
                labelText: 'Image URL (optional)',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => widget.onChanged(_updated(imageUrl: v)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _btnTitleCtrl,
              decoration: const InputDecoration(
                labelText: 'Button title (optional)',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => widget.onChanged(_updated(buttonTitle: v)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _btnUrlCtrl,
              decoration: const InputDecoration(
                labelText: 'Button URL (optional)',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => widget.onChanged(_updated(buttonUrl: v)),
            ),
          ],
        ),
      ),
    );
  }
}
