import 'package:flutter/material.dart';

import '../editor/editor_location.dart';
import '../models/questionnaire.dart';
import 'editor_fields.dart';

class QuestionnairePreview extends StatefulWidget {
  const QuestionnairePreview({
    super.key,
    required this.questionnaire,
    required this.location,
    this.walkthrough = false,
    this.onExit,
  });
  final Questionnaire questionnaire;
  final EditorLocation location;
  final bool walkthrough;
  final VoidCallback? onExit;

  @override
  State<QuestionnairePreview> createState() => _QuestionnairePreviewState();
}

class _QuestionnairePreviewState extends State<QuestionnairePreview> {
  int step = 0;
  bool complete = false;
  final answers = <String, Set<String>>{};
  final written = <String, String>{};
  final ratings = <String, Map<String, int>>{};
  static const ratingStars = 5;
  bool get hasWelcome => widget.questionnaire.preScreen != null;

  @override
  void didUpdateWidget(covariant QuestionnairePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.walkthrough != widget.walkthrough ||
        oldWidget.questionnaire.id != widget.questionnaire.id) {
      step = 0;
      complete = false;
      answers.clear();
      written.clear();
      ratings.clear();
    }
    if (oldWidget.questionnaire.questions != widget.questionnaire.questions) {
      final ids = widget.questionnaire.questions.map((q) => q.id).toSet();
      answers.removeWhere((key, _) => !ids.contains(key));
      written.removeWhere((key, _) => !ids.contains(key));
      ratings.removeWhere((key, _) => !ids.contains(key));
      for (final q in widget.questionnaire.questions) {
        final valid = q.options.map((o) => o.id).toSet();
        answers[q.id]?.removeWhere((id) => !valid.contains(id));
        final multiple = q.type.allowsMultipleAnswers;
        if (!multiple && (answers[q.id]?.length ?? 0) > 1) {
          answers[q.id] = {answers[q.id]!.first};
        }
        ratings[q.id]?.removeWhere((id, _) => !valid.contains(id));
      }
      if (step > widget.questionnaire.questions.length) step = 0;
    }
  }

  void select(Question question, String id) => setState(() {
    final selection = answers.putIfAbsent(question.id, () => {});
    if (selection.contains(id)) {
      selection.remove(id);
    } else {
      if (!question.type.allowsMultipleAnswers) selection.clear();
      selection.add(id);
    }
  });

  bool answered(Question q) => switch (q.type) {
    QuestionType.textInput => written[q.id]?.trim().isNotEmpty ?? false,
    QuestionType.starRating =>
      q.options.isNotEmpty &&
          q.options.every((option) => (ratings[q.id]?[option.id] ?? 0) > 0),
    _ => answers[q.id]?.isNotEmpty ?? false,
  };

  void next() => setState(() {
    final count = widget.questionnaire.questions.length + (hasWelcome ? 1 : 0);
    if (step + 1 >= count)
      complete = true;
    else
      step++;
  });

  @override
  Widget build(BuildContext context) {
    final qn = widget.questionnaire;
    final welcomeVisible = widget.walkthrough
        ? hasWelcome && step == 0
        : widget.location.isSetup && widget.location.kind != ContentKind.setup;
    final overview =
        !widget.walkthrough && widget.location.kind == ContentKind.setup;
    final index = widget.walkthrough
        ? step - (hasWelcome ? 1 : 0)
        : qn.questions.indexWhere((q) => q.id == widget.location.questionId);
    final question = index >= 0 && index < qn.questions.length
        ? qn.questions[index]
        : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.walkthrough ? 'Try questionnaire' : 'Live preview',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            if (widget.onExit != null)
              IconButton(
                tooltip: 'Exit test mode',
                onPressed: widget.onExit,
                icon: const Icon(Icons.close, size: 18),
              )
            else
              const Icon(Icons.smartphone_outlined, size: 18),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          key: const ValueKey('phone-preview'),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              width: 5,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 510),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('9:41', style: TextStyle(fontSize: 12)),
                    Container(
                      width: 52,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const Icon(Icons.battery_full, size: 16),
                  ],
                ),
                const SizedBox(height: 28),
                if (complete && widget.walkthrough) ...[
                  const Icon(Icons.check_circle_outline, size: 48),
                  const SizedBox(height: 20),
                  Text(
                    'Thank you for your feedback',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: () => setState(() {
                      step = 0;
                      complete = false;
                      answers.clear();
                      written.clear();
                      ratings.clear();
                    }),
                    child: const Text('Start again'),
                  ),
                ] else if (overview) ...[
                  if (qn.backgroundImageUrl?.isNotEmpty ?? false)
                    ContentImage(url: qn.backgroundImageUrl, height: 150),
                  const SizedBox(height: 16),
                  Text(
                    qn.title.isEmpty ? 'Questionnaire title' : qn.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    qn.description.isEmpty
                        ? 'Your introduction appears here.'
                        : qn.description,
                  ),
                  if (qn.dateLabel != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        qn.dateLabel!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                ] else if (welcomeVisible && qn.preScreen != null) ...[
                  ...welcomeContent(context, qn.preScreen!),
                  if (widget.walkthrough)
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: FilledButton(
                        onPressed: next,
                        child: const Text('Start questionnaire'),
                      ),
                    ),
                ] else if (question != null) ...[
                  Text(
                    'QUESTION ${index + 1} OF ${qn.questions.length}',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 16),
                  if (question.imageUrl?.isNotEmpty ?? false) ...[
                    ContentImage(url: question.imageUrl, height: 130),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    question.title.isEmpty ? 'Question title' : question.title,
                    key: const ValueKey('preview-question-title'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  if (question.description?.isNotEmpty ?? false)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(question.description!),
                    ),
                  const SizedBox(height: 20),
                  if (question.type.isCarousel)
                    CarouselPreview(
                      key: ValueKey(question.id),
                      question: question,
                      focusedItemId: widget.location.itemId,
                      selected: answers[question.id] ?? {},
                      onSelect: (id) => select(question, id),
                    ),
                  if (question.type == QuestionType.starRating) ...[
                    for (final option in question.options)
                      Padding(
                        key: ValueKey('preview-rating-${option.id}'),
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              option.text.isEmpty ? 'Rating text' : option.text,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            if (option.description?.isNotEmpty ?? false)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(option.description!),
                              ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 48,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemExtent: 40,
                                itemCount: ratingStars,
                                itemBuilder: (context, i) => IconButton(
                                  tooltip: 'Rate ${i + 1} stars',
                                  padding: EdgeInsets.zero,
                                  onPressed: () => setState(() {
                                    ratings.putIfAbsent(
                                      question.id,
                                      () => {},
                                    )[option.id] = i + 1;
                                  }),
                                  icon: Icon(
                                    (ratings[question.id]?[option.id] ?? 0) > i
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                            if (ratings[question.id]?[option.id] != null)
                              Text(
                                '${ratings[question.id]![option.id]} of $ratingStars stars',
                              ),
                          ],
                        ),
                      ),
                    if (question.options.isEmpty)
                      const Text('Rating questions will appear here.'),
                  ],
                  if (question.type == QuestionType.textInput)
                    TextFormField(
                      key: ValueKey('preview-answer-${question.id}'),
                      initialValue: written[question.id],
                      minLines: 3,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Your answer',
                      ),
                      onChanged: (value) =>
                          setState(() => written[question.id] = value),
                    ),
                  if ([
                    QuestionType.singleSelect,
                    QuestionType.multiSelect,
                    QuestionType.prominentSingleSelect,
                  ].contains(question.type)) ...[
                    for (final option in question.options)
                      Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => select(question, option.id),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (question.type.supportsAnswerImages &&
                                    (option.imageUrl?.isNotEmpty ?? false)) ...[
                                  ContentImage(
                                    url: option.imageUrl,
                                    height: 100,
                                  ),
                                  const SizedBox(height: 10),
                                ],
                                Row(
                                  children: [
                                    Icon(
                                      answers[question.id]?.contains(
                                                option.id,
                                              ) ??
                                              false
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked,
                                      size: 20,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        option.text.isEmpty
                                            ? 'Answer choice'
                                            : option.text,
                                      ),
                                    ),
                                  ],
                                ),
                                if (question.type.supportsAnswerDescriptions &&
                                    (option.description?.isNotEmpty ?? false))
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(option.description!),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (question.options.isEmpty)
                      const Text('Answer choices will appear here.'),
                  ],
                  if (widget.walkthrough) ...[
                    const SizedBox(height: 28),
                    FilledButton(
                      onPressed: answered(question) ? next : null,
                      child: Text(
                        index == qn.questions.length - 1
                            ? 'Finish'
                            : 'Continue',
                      ),
                    ),
                    if (question.isSkippable)
                      TextButton(onPressed: next, child: const Text('Skip')),
                    if (step > 0)
                      TextButton(
                        onPressed: () => setState(() => step--),
                        child: const Text('Previous question'),
                      ),
                  ],
                ] else
                  const Text('Add or select a question to preview it.'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          widget.walkthrough
              ? 'Test answers stay in this preview.'
              : 'Updates as you type. This is an illustrative app preview.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  List<Widget> welcomeContent(BuildContext context, PreScreen welcome) => [
    Text(
      welcome.title.isEmpty ? 'Welcome title' : welcome.title,
      style: Theme.of(context).textTheme.titleLarge,
    ),
    const SizedBox(height: 12),
    Text(welcome.description),
    const SizedBox(height: 20),
    if (welcome.style == PreScreenStyle.list)
      for (final item in welcome.items)
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.iconUrl?.trim().isNotEmpty ?? false) ...[
                ContentImage(url: item.iconUrl, size: 32),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(item.title.isEmpty ? 'Item text' : item.title),
              ),
            ],
          ),
        )
    else
      for (final card in welcome.cards)
        Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (card.imageUrl?.isNotEmpty ?? false) ...[
                  ContentImage(url: card.imageUrl, height: 100),
                  const SizedBox(height: 12),
                ],
                Text(
                  card.title.isEmpty ? 'Card title' : card.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(card.description),
                if (card.buttonTitle?.isNotEmpty ?? false)
                  TextButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Links are not opened in the preview.'),
                      ),
                    ),
                    child: Text(card.buttonTitle!),
                  ),
              ],
            ),
          ),
        ),
  ];
}

class CarouselPreview extends StatefulWidget {
  const CarouselPreview({
    super.key,
    required this.question,
    required this.focusedItemId,
    required this.selected,
    required this.onSelect,
  });
  final Question question;
  final String? focusedItemId;
  final Set<String> selected;
  final ValueChanged<String> onSelect;
  @override
  State<CarouselPreview> createState() => _CarouselPreviewState();
}

class _CarouselPreviewState extends State<CarouselPreview> {
  late final PageController pages;
  int index = 0;
  @override
  void initState() {
    super.initState();
    final focused = widget.question.options.indexWhere(
      (item) => item.id == widget.focusedItemId,
    );
    index = focused < 0 ? 0 : focused;
    pages = PageController(initialPage: index);
  }

  @override
  void didUpdateWidget(covariant CarouselPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    final focused = widget.question.options.indexWhere(
      (item) => item.id == widget.focusedItemId,
    );
    final target = focused >= 0
        ? focused
        : index.clamp(
            0,
            (widget.question.options.length - 1).clamp(0, 1 << 30),
          );
    if (target != index || oldWidget.focusedItemId != widget.focusedItemId) {
      index = target;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && pages.hasClients) pages.jumpToPage(index);
      });
    }
  }

  @override
  void dispose() {
    pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.question.options;
    if (items.isEmpty) return const Text('Carousel items will appear here.');
    return Column(
      children: [
        Text(
          widget.question.type.allowsMultipleAnswers
              ? 'Select all that apply'
              : 'Select one answer',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 320,
          child: PageView.builder(
            controller: pages,
            itemCount: items.length,
            onPageChanged: (value) => setState(() => index = value),
            itemBuilder: (context, i) {
              final item = items[i];
              final selected = widget.selected.contains(item.id);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Card(
                  color: selected
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
                  child: InkWell(
                    onTap: () => widget.onSelect(item.id),
                    borderRadius: BorderRadius.circular(12),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (item.imageUrl?.isNotEmpty ?? false) ...[
                              ContentImage(url: item.imageUrl, height: 140),
                              const SizedBox(height: 12),
                            ],
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.text.isEmpty
                                        ? 'Answer text'
                                        : item.text,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                ),
                                Icon(
                                  selected
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  size: 20,
                                ),
                              ],
                            ),
                            if (item.description?.isNotEmpty ?? false) ...[
                              const SizedBox(height: 8),
                              Text(item.description!),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              tooltip: 'Previous carousel item',
              onPressed: index > 0
                  ? () => pages.previousPage(
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.easeOut,
                    )
                  : null,
              icon: const Icon(Icons.chevron_left),
            ),
            Text('${index + 1} / ${items.length}'),
            IconButton(
              tooltip: 'Next carousel item',
              onPressed: index < items.length - 1
                  ? () => pages.nextPage(
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.easeOut,
                    )
                  : null,
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
      ],
    );
  }
}
