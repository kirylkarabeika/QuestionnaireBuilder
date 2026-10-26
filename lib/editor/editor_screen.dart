import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/questionnaire.dart';
import '../widgets/questionnaire_preview.dart';
import 'draft_store.dart';
import 'editor_controller.dart';
import 'editor_location.dart';
import 'editor_session.dart';
import 'file_io.dart';
import 'focused_content_editor.dart';
import 'questionnaire_validation.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key, this.draftStore, this.controller});
  final DraftStore? draftStore;
  final EditorController? controller;
  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late final session = EditorSession(
    store: widget.draftStore ?? createDraftStore(),
    controller: widget.controller,
  );
  EditorController get controller => session.controller;
  EditorSection section = EditorSection.setup;
  EditorLocation location = const EditorLocation(ContentKind.setup);
  int focusRevision = 0;
  bool initialized = false;
  bool testMode = false;
  final scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    session.addListener(_changed);
    controller.questionnaire.addListener(_changed);
    unawaited(session.load());
  }

  void _changed() {
    if (!mounted) return;
    if (!initialized && session.status != DraftStatus.loading) {
      initialized = true;
      if (session.restored &&
          controller.questionnaire.value.questions.isNotEmpty) {
        section = EditorSection.questions;
        location = EditorLocation(
          ContentKind.question,
          questionId: controller.questionnaire.value.questions.first.id,
        );
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    session.removeListener(_changed);
    controller.questionnaire.removeListener(_changed);
    session.dispose();
    scroll.dispose();
    super.dispose();
  }

  void navigate(EditorLocation target) {
    setState(() {
      location = target;
      section = target.isSetup ? EditorSection.setup : EditorSection.questions;
      focusRevision++;
      testMode = false;
    });
    if (scroll.hasClients) scroll.jumpTo(0);
  }

  EditorLocation safeLocation(Questionnaire qn) {
    if (location.isSetup) {
      if (location.kind != ContentKind.setup && qn.preScreen == null)
        return const EditorLocation(ContentKind.setup);
      if (location.kind == ContentKind.welcomeCard &&
          (location.index! >= qn.preScreen!.cards.length ||
              qn.preScreen!.style != PreScreenStyle.cards))
        return const EditorLocation(ContentKind.welcome);
      if (location.kind == ContentKind.welcomeItem &&
          (location.index! >= qn.preScreen!.items.length ||
              qn.preScreen!.style != PreScreenStyle.list))
        return const EditorLocation(ContentKind.welcome);
      return location;
    }
    final question =
        qn.questions.where((q) => q.id == location.questionId).firstOrNull ??
        qn.questions.firstOrNull;
    if (question == null) return const EditorLocation(ContentKind.question);
    if (question.id != location.questionId)
      return EditorLocation(ContentKind.question, questionId: question.id);
    if (location.kind == ContentKind.carouselItem &&
        !question.items.any((item) => item.id == location.itemId))
      return EditorLocation(ContentKind.question, questionId: question.id);
    if (location.kind == ContentKind.option &&
        !question.options.any((option) => option.id == location.itemId))
      return EditorLocation(ContentKind.question, questionId: question.id);
    return location;
  }

  void chooseSection(EditorSection value) {
    setState(() {
      section = value;
      if (value == EditorSection.setup && !location.isSetup)
        location = const EditorLocation(ContentKind.setup);
      if (value == EditorSection.questions && location.isSetup)
        location = EditorLocation(
          ContentKind.question,
          questionId: controller.questionnaire.value.questions.firstOrNull?.id,
        );
      testMode = false;
      focusRevision++;
    });
    if (scroll.hasClients) scroll.jumpTo(0);
  }

  Future<void> addQuestion() async {
    final type = await showDialog<QuestionType>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose a question type'),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final type in QuestionType.values)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                      leading: Icon(typeIcon(type)),
                      title: Text(type.label),
                      subtitle: Text(type.help),
                      onTap: () => Navigator.pop(context, type),
                    ),
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
    if (!mounted || type == null) return;
    controller.addQuestion(type);
    navigate(
      EditorLocation(
        ContentKind.question,
        questionId: controller.questionnaire.value.questions.last.id,
      ),
    );
  }

  IconData typeIcon(QuestionType type) => switch (type) {
    QuestionType.singleSelect => Icons.radio_button_checked,
    QuestionType.multiSelect => Icons.checklist,
    QuestionType.textInput => Icons.notes,
    QuestionType.prominentSingleSelect => Icons.image_outlined,
    QuestionType.carouselSingleSelect ||
    QuestionType.carouselMultiSelect => Icons.view_carousel_outlined,
    QuestionType.starRating => Icons.star_border,
  };

  Future<void> open() async {
    try {
      final content = await openTextFile();
      if (!mounted || content == null) return;
      controller.importJson(content);
      navigate(const EditorLocation(ContentKind.setup));
      message('Questionnaire opened. Changes are saved locally.');
    } catch (_) {
      if (mounted)
        message(
          'Could not open this questionnaire. Your current content has been kept.',
        );
    }
  }

  void message(String value) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(value)));

  Future<void> export({bool draft = false}) async {
    if (!draft &&
        validateQuestionnaire(controller.questionnaire.value).isNotEmpty) {
      chooseSection(EditorSection.review);
      message(
        'Complete the highlighted content before exporting, or download a draft from the file menu.',
      );
      return;
    }
    try {
      await session.flush();
      final qn = controller.questionnaire.value;
      await saveTextFile(
        suggestedName: '${qn.id}${draft ? '.draft' : ''}.json',
        content: controller.exportJsonPretty(),
      );
    } catch (_) {
      if (mounted)
        message(
          'Export failed. Your questionnaire is still available in the editor.',
        );
    }
  }

  Future<void> showPreview() => showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: ValueListenableBuilder<Questionnaire>(
          valueListenable: controller.questionnaire,
          builder: (context, qn, _) => SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: QuestionnairePreview(
              questionnaire: qn,
              location: safeLocation(qn),
              walkthrough: section == EditorSection.review,
              onExit: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final qn = controller.questionnaire.value;
    final current = safeLocation(qn);
    final width = MediaQuery.sizeOf(context).width;
    final issues = validateQuestionnaire(qn);
    final status = switch (session.status) {
      DraftStatus.loading => 'Restoring draft…',
      DraftStatus.saved =>
        session.restored
            ? 'Draft restored · Saved on this device'
            : 'Saved on this device',
      DraftStatus.saving => 'Saving draft…',
      DraftStatus.failed => 'Draft needs attention',
    };
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyZ, control: true):
            controller.undo,
        const SingleActivator(LogicalKeyboardKey.keyZ, meta: true):
            controller.undo,
        const SingleActivator(
          LogicalKeyboardKey.keyZ,
          control: true,
          shift: true,
        ): controller.redo,
        const SingleActivator(LogicalKeyboardKey.keyZ, meta: true, shift: true):
            controller.redo,
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  qn.title.isEmpty ? 'New questionnaire' : qn.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (width > 600)
                  Text(status, style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
            actions: [
              IconButton(
                tooltip: 'Undo',
                onPressed: controller.canUndo ? controller.undo : null,
                icon: const Icon(Icons.undo),
              ),
              IconButton(
                tooltip: 'Redo',
                onPressed: controller.canRedo ? controller.redo : null,
                icon: const Icon(Icons.redo),
              ),
              if (width < 1000)
                IconButton(
                  tooltip: 'Preview',
                  onPressed: showPreview,
                  icon: const Icon(Icons.smartphone_outlined),
                ),
              if (width >= 760)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: FilledButton.icon(
                    onPressed: () => export(),
                    icon: const Icon(Icons.file_download_outlined, size: 18),
                    label: const Text('Export'),
                  ),
                ),
              PopupMenuButton<String>(
                tooltip: 'File menu',
                onSelected: (value) {
                  switch (value) {
                    case 'new':
                      controller.newQuestionnaire();
                      navigate(const EditorLocation(ContentKind.setup));
                    case 'open':
                      unawaited(open());
                    case 'draft':
                      unawaited(export(draft: true));
                    case 'export':
                      unawaited(export());
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'new', child: Text('New questionnaire')),
                  PopupMenuItem(value: 'open', child: Text('Open JSON')),
                  PopupMenuItem(
                    value: 'draft',
                    child: Text('Download draft JSON'),
                  ),
                  PopupMenuItem(
                    value: 'export',
                    child: Text('Export questionnaire'),
                  ),
                ],
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: session.status == DraftStatus.loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width < 600 ? 12 : 24,
                        vertical: 12,
                      ),
                      child: Wrap(
                        runSpacing: 8,
                        children: [
                          for (final value in EditorSection.values)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(
                                  '${value.index + 1} · ${switch (value) {
                                    EditorSection.setup => 'Setup',
                                    EditorSection.questions => 'Questions',
                                    EditorSection.review => 'Review',
                                  }}',
                                ),
                                selected: section == value,
                                onSelected: (_) => chooseSection(value),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (session.error != null)
                      MaterialBanner(
                        content: Text(session.error!),
                        actions: [
                          TextButton(
                            onPressed: () => export(draft: true),
                            child: const Text('Download draft'),
                          ),
                        ],
                      ),
                    const Divider(height: 1),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (section == EditorSection.questions &&
                              width >= 1250)
                            SizedBox(width: 250, child: outline(qn, current)),
                          Expanded(
                            child: SingleChildScrollView(
                              key: const ValueKey('editor-scroll'),
                              controller: scroll,
                              padding: EdgeInsets.all(width < 600 ? 16 : 28),
                              child: Center(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 760,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      if (section == EditorSection.questions &&
                                          width < 1250) ...[
                                        questionPicker(qn, current),
                                        const SizedBox(height: 20),
                                      ],
                                      if (section == EditorSection.review)
                                        review(qn, issues, width)
                                      else
                                        Card(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.surface,
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                              width < 600 ? 18 : 26,
                                            ),
                                            child: FocusedContentEditor(
                                              key: ValueKey(
                                                '${current.key}:$focusRevision',
                                              ),
                                              questionnaire: qn,
                                              controller: controller,
                                              location: current,
                                              onNavigate: navigate,
                                              onAddQuestion: addQuestion,
                                            ),
                                          ),
                                        ),
                                      if (section == EditorSection.questions &&
                                          current.kind == ContentKind.question)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 16,
                                          ),
                                          child: Wrap(
                                            alignment:
                                                WrapAlignment.spaceBetween,
                                            spacing: 16,
                                            runSpacing: 12,
                                            children: [
                                              OutlinedButton.icon(
                                                onPressed: addQuestion,
                                                icon: const Icon(Icons.add),
                                                label: const Text(
                                                  'Add question',
                                                ),
                                              ),
                                              TextButton.icon(
                                                onPressed: () => chooseSection(
                                                  EditorSection.review,
                                                ),
                                                icon: const Icon(
                                                  Icons.arrow_forward,
                                                ),
                                                label: const Text(
                                                  'Review questionnaire',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (width >= 1000)
                            Container(
                              width: width >= 1400 ? 360 : 320,
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outlineVariant,
                                  ),
                                ),
                              ),
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.all(24),
                                child: QuestionnairePreview(
                                  questionnaire: qn,
                                  location: current,
                                  walkthrough: testMode,
                                  onExit: testMode
                                      ? () => setState(() => testMode = false)
                                      : null,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (width <= 600)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                status,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: showPreview,
                              icon: const Icon(
                                Icons.smartphone_outlined,
                                size: 16,
                              ),
                              label: const Text('Preview'),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget questionPicker(Questionnaire qn, EditorLocation current) => Row(
    children: [
      Expanded(
        child: qn.questions.isEmpty
            ? const Text('No questions yet')
            : DropdownButtonFormField<String>(
                key: ValueKey(current.questionId),
                initialValue: current.questionId,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Question'),
                items: [
                  for (var i = 0; i < qn.questions.length; i++)
                    DropdownMenuItem(
                      value: qn.questions[i].id,
                      child: Text(
                        '${i + 1}. ${qn.questions[i].title.isEmpty ? 'Untitled question' : qn.questions[i].title}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: (id) {
                  if (id != null)
                    navigate(
                      EditorLocation(ContentKind.question, questionId: id),
                    );
                },
              ),
      ),
      const SizedBox(width: 8),
      IconButton(
        tooltip: 'Reorder questions',
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          builder: (_) => SizedBox(
            height: 480,
            child: ValueListenableBuilder<Questionnaire>(
              valueListenable: controller.questionnaire,
              builder: (_, qn, _) => outline(qn, safeLocation(qn)),
            ),
          ),
        ),
        icon: const Icon(Icons.reorder),
      ),
    ],
  );

  Widget outline(Questionnaire qn, EditorLocation current) => ColoredBox(
    color: Theme.of(context).colorScheme.surface,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'Questions · ${qn.questions.length}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Expanded(
          child: ReorderableListView.builder(
            buildDefaultDragHandles: false,
            itemCount: qn.questions.length,
            onReorder: controller.reorderQuestion,
            itemBuilder: (context, i) {
              final question = qn.questions[i];
              return ListTile(
                key: ValueKey(question.id),
                selected: question.id == current.questionId,
                selectedTileColor: Theme.of(
                  context,
                ).colorScheme.primaryContainer,
                leading: Text('${i + 1}'),
                title: Text(
                  question.title.isEmpty ? 'Untitled question' : question.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(question.type.label),
                trailing: ReorderableDragStartListener(
                  index: i,
                  child: const MouseRegion(
                    cursor: SystemMouseCursors.grab,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Icon(Icons.drag_indicator, size: 20),
                    ),
                  ),
                ),
                onTap: () => navigate(
                  EditorLocation(ContentKind.question, questionId: question.id),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: OutlinedButton.icon(
            onPressed: addQuestion,
            icon: const Icon(Icons.add),
            label: const Text('Add question'),
          ),
        ),
      ],
    ),
  );

  Widget review(
    Questionnaire qn,
    List<ContentIssue> issues,
    double width,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        'Review your questionnaire',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      const SizedBox(height: 8),
      const Text(
        'Check the content and try the participant experience before exporting.',
      ),
      const SizedBox(height: 24),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    issues.isEmpty
                        ? Icons.check_circle_outline
                        : Icons.fact_check_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      issues.isEmpty
                          ? 'Ready to export'
                          : '${issues.length} things to complete',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              if (issues.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text('All required content is complete.'),
                ),
              for (final issue in issues)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(issue.message),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => navigate(issue.location),
                ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),
      for (var i = 0; i < qn.questions.length; i++)
        Card(
          child: ListTile(
            leading: Text('${i + 1}'),
            title: Text(
              qn.questions[i].title.isEmpty
                  ? 'Untitled question'
                  : qn.questions[i].title,
            ),
            subtitle: Text(
              '${qn.questions[i].type.label} · ${qn.questions[i].isSkippable ? 'Can skip' : 'Answer required'}',
            ),
            trailing: const Icon(Icons.edit_outlined),
            onTap: () => navigate(
              EditorLocation(
                ContentKind.question,
                questionId: qn.questions[i].id,
              ),
            ),
          ),
        ),
      if (qn.requiresExtendedQuestionnaire)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 18),
          child: Text(
            'App compatibility: requires the updated app for carousel and star rating questions.',
          ),
        ),
      const SizedBox(height: 16),
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          OutlinedButton.icon(
            onPressed: qn.questions.isEmpty
                ? null
                : () {
                    if (width < 1000) {
                      unawaited(showPreview());
                    } else {
                      setState(() => testMode = true);
                    }
                  },
            icon: const Icon(Icons.play_arrow_outlined),
            label: const Text('Try questionnaire'),
          ),
          FilledButton.icon(
            onPressed: issues.isEmpty ? () => export() : null,
            icon: const Icon(Icons.file_download_outlined),
            label: const Text('Export questionnaire'),
          ),
        ],
      ),
    ],
  );
}
