import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/questionnaire.dart';
import '../widgets/editor_fields.dart';
import '../widgets/optional_datetime_field.dart';
import '../widgets/star_rating_editor.dart';
import 'editor_controller.dart';
import 'editor_location.dart';

class FocusedContentEditor extends StatelessWidget {
  const FocusedContentEditor({
    super.key,
    required this.questionnaire,
    required this.controller,
    required this.location,
    required this.onNavigate,
    required this.onAddQuestion,
  });
  final Questionnaire questionnaire;
  final EditorController controller;
  final EditorLocation location;
  final ValueChanged<EditorLocation> onNavigate;
  final VoidCallback onAddQuestion;

  static const _uuid = Uuid();
  bool focus(String field) => location.field == field;
  String? optional(String text) => text.trim().isEmpty ? null : text;
  void setQuestionnaire(Questionnaire value) =>
      controller.questionnaire.value = value;

  Widget page(
    BuildContext context,
    String title,
    List<Widget> children, {
    String? subtitle,
    VoidCallback? back,
    List<Widget> actions = const [],
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (back != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: TextButton.icon(
            onPressed: back,
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text('Back'),
          ),
        ),
      if (subtitle != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            subtitle,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          ...actions,
        ],
      ),
      const SizedBox(height: 24),
      ...children,
      if (back != null)
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: FilledButton.icon(
            onPressed: back,
            icon: const Icon(Icons.check, size: 18),
            label: const Text('Done'),
          ),
        ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    if (location.kind == ContentKind.setup) return setup(context);
    if (location.isSetup) return welcome(context);
    final question = questionnaire.questions
        .where((q) => q.id == location.questionId)
        .firstOrNull;
    if (question == null)
      return page(context, 'Build your questions', [
        const Text(
          'Add a question to get started. You can choose its format and edit one piece of content at a time.',
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: onAddQuestion,
          icon: const Icon(Icons.add),
          label: const Text('Add question'),
        ),
      ]);
    void update(Question value) =>
        controller.updateQuestion(question.id, value);
    void back() => onNavigate(
      EditorLocation(ContentKind.question, questionId: question.id),
    );
    final number = questionnaire.questions.indexOf(question) + 1;
    final contextLabel =
        'Question $number · ${question.title.isEmpty ? 'Untitled question' : question.title}';
    if (location.kind == ContentKind.rating)
      return page(
        context,
        'Edit star rating',
        [
          StarRatingEditor(
            rating:
                question.starRating ??
                const StarRating(title: '', description: ''),
            focusField: location.field,
            onChanged: (rating) =>
                update(question.copyWith(starRating: rating)),
          ),
        ],
        subtitle: '$contextLabel / Rating',
        back: back,
      );
    if (location.kind == ContentKind.carouselItem) {
      final item = question.items
          .where((item) => item.id == location.itemId)
          .firstOrNull;
      if (item == null) return const SizedBox.shrink();
      void updateItem(CarouselItem value) => update(
        question.copyWith(
          items: [
            for (final current in question.items)
              current.id == item.id ? value : current,
          ],
        ),
      );
      return page(
        context,
        'Edit carousel item',
        [
          ContentField(
            label: 'Item title',
            value: item.title,
            autofocus: focus('title'),
            onChanged: (text) => updateItem(item.copyWith(title: text)),
          ),
          ContentField(
            label: 'Item description',
            value: item.description,
            lines: 3,
            autofocus: focus('description'),
            onChanged: (text) => updateItem(item.copyWith(description: text)),
          ),
          ImageField(
            value: item.imageUrl,
            requiredImage: true,
            autofocus: focus('image'),
            onChanged: (url) => updateItem(item.copyWith(imageUrl: url ?? '')),
          ),
        ],
        subtitle: '$contextLabel / Item ${question.items.indexOf(item) + 1}',
        back: back,
        actions: [
          IconButton(
            tooltip: 'Delete carousel item',
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              final remaining = question.items
                  .where((current) => current.id != item.id)
                  .toList();
              update(
                question.copyWith(
                  items: [
                    for (var i = 0; i < remaining.length; i++)
                      remaining[i].copyWith(order: i),
                  ],
                ),
              );
              back();
            },
          ),
        ],
      );
    }
    if (location.kind == ContentKind.option) {
      final option = question.options
          .where((option) => option.id == location.itemId)
          .firstOrNull;
      if (option == null) return const SizedBox.shrink();
      void updateOption(Option value) => update(
        question.copyWith(
          options: [
            for (final current in question.options)
              current.id == option.id ? value : current,
          ],
        ),
      );
      return page(
        context,
        'Edit answer choice',
        [
          ContentField(
            label: 'Answer text',
            value: option.text,
            autofocus: focus('title'),
            onChanged: (text) => updateOption(option.copyWith(text: text)),
          ),
          OptionalDescriptionField(
            value: option.description,
            autofocus: focus('description'),
            onChanged: (text) =>
                updateOption(option.copyWith(description: text)),
          ),
          ImageField(
            value: option.imageUrl,
            autofocus: focus('image'),
            onChanged: (url) => updateOption(option.copyWith(imageUrl: url)),
          ),
        ],
        subtitle:
            '$contextLabel / Answer ${question.options.indexOf(option) + 1}',
        back: back,
        actions: [
          IconButton(
            tooltip: 'Delete answer choice',
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              final remaining = question.options
                  .where((current) => current.id != option.id)
                  .toList();
              update(
                question.copyWith(
                  options: [
                    for (var i = 0; i < remaining.length; i++)
                      remaining[i].copyWith(order: i),
                  ],
                ),
              );
              back();
            },
          ),
        ],
      );
    }
    return page(
      context,
      'Edit question',
      [
        ContentField(
          label: 'Question title',
          value: question.title,
          autofocus: focus('title'),
          onChanged: (text) => update(question.copyWith(title: text)),
        ),
        OptionalDescriptionField(
          value: question.description,
          autofocus: focus('description'),
          onChanged: (text) => update(question.copyWith(description: text)),
        ),
        ImageField(
          value: question.imageUrl,
          autofocus: focus('image'),
          onChanged: (url) => update(question.copyWith(imageUrl: url)),
        ),
        const Divider(height: 36),
        if (question.type == QuestionType.carousel) ...[
          Text(
            'Carousel items',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < question.items.length; i++)
            ContentSummary(
              title: question.items[i].title.isEmpty
                  ? 'Untitled item ${i + 1}'
                  : question.items[i].title,
              description: question.items[i].description,
              imageUrl: question.items[i].imageUrl,
              onTap: () => onNavigate(
                EditorLocation(
                  ContentKind.carouselItem,
                  questionId: question.id,
                  itemId: question.items[i].id,
                ),
              ),
            ),
          OutlinedButton.icon(
            onPressed: () {
              final item = CarouselItem(
                id: _uuid.v4(),
                order: question.items.length,
                title: '',
                imageUrl: '',
              );
              update(question.copyWith(items: [...question.items, item]));
              onNavigate(
                EditorLocation(
                  ContentKind.carouselItem,
                  questionId: question.id,
                  itemId: item.id,
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add carousel item'),
          ),
        ] else if (question.type == QuestionType.starRating) ...[
          Text(
            'Rating details',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ContentSummary(
            title: question.starRating?.title.isNotEmpty ?? false
                ? question.starRating!.title
                : 'Configure star rating',
            description:
                '${question.starRating?.starCount ?? 5} stars · ${question.starRating?.description ?? 'Add a description'}',
            onTap: () => onNavigate(
              EditorLocation(ContentKind.rating, questionId: question.id),
            ),
          ),
        ] else if (question.type != QuestionType.textInput) ...[
          Text(
            'Answer choices',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < question.options.length; i++)
            ContentSummary(
              title: question.options[i].text.isEmpty
                  ? 'Untitled answer ${i + 1}'
                  : question.options[i].text,
              description: question.options[i].description,
              imageUrl: question.options[i].imageUrl,
              onTap: () => onNavigate(
                EditorLocation(
                  ContentKind.option,
                  questionId: question.id,
                  itemId: question.options[i].id,
                ),
              ),
            ),
          OutlinedButton.icon(
            onPressed: () {
              final option = Option(
                id: _uuid.v4(),
                order: question.options.length,
                text: '',
              );
              update(question.copyWith(options: [...question.options, option]));
              onNavigate(
                EditorLocation(
                  ContentKind.option,
                  questionId: question.id,
                  itemId: option.id,
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add answer choice'),
          ),
        ] else
          const Text('Participants can write their answer in a text field.'),
        const SizedBox(height: 24),
        ExpansionTile(
          key: ValueKey('answer-settings-${question.id}'),
          title: const Text('Answer settings'),
          tilePadding: EdgeInsets.zero,
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Allow participants to skip'),
              value: question.isSkippable,
              onChanged: (value) =>
                  update(question.copyWith(isSkippable: value)),
            ),
            if (question.type == QuestionType.carousel)
              DropdownButtonFormField<CarouselSelectionMode>(
                key: ValueKey(question.selectionMode),
                initialValue: question.selectionMode,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Selection mode'),
                items: const [
                  DropdownMenuItem(
                    value: CarouselSelectionMode.singleSelect,
                    child: Text('Single choice'),
                  ),
                  DropdownMenuItem(
                    value: CarouselSelectionMode.multiSelect,
                    child: Text('Multiple choice'),
                  ),
                ],
                onChanged: (mode) {
                  if (mode != null)
                    update(question.copyWith(selectionMode: mode));
                },
              ),
            const SizedBox(height: 12),
          ],
        ),
      ],
      subtitle:
          'QUESTION $number OF ${questionnaire.questions.length} · ${question.type.label}',
      actions: [
        IconButton(
          tooltip: 'Duplicate question',
          icon: const Icon(Icons.copy_outlined),
          onPressed: () => onNavigate(
            EditorLocation(
              ContentKind.question,
              questionId: controller.duplicateQuestion(question.id),
            ),
          ),
        ),
        IconButton(
          tooltip: 'Delete question',
          icon: const Icon(Icons.delete_outline),
          onPressed: () {
            controller.removeQuestion(question.id);
            onNavigate(const EditorLocation(ContentKind.question));
          },
        ),
      ],
    );
  }

  Widget setup(BuildContext context) => page(
    context,
    'Set up your questionnaire',
    [
      ContentField(
        label: 'Questionnaire title',
        value: questionnaire.title,
        autofocus: focus('title'),
        onChanged: controller.setTitle,
      ),
      ContentField(
        label: 'Introduction',
        value: questionnaire.description,
        lines: 3,
        autofocus: focus('description'),
        onChanged: controller.setDescription,
      ),
      ImageField(
        value: questionnaire.backgroundImageUrl,
        label: 'Background image',
        autofocus: focus('image'),
        onChanged: controller.setBackgroundImageUrl,
      ),
      const Divider(height: 36),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('Include a welcome screen'),
        subtitle: const Text(
          'Introduce the questionnaire before the first question.',
        ),
        value: questionnaire.preScreen != null,
        onChanged: controller.enablePreScreen,
      ),
      if (questionnaire.preScreen != null)
        ContentSummary(
          title: questionnaire.preScreen!.title.isEmpty
              ? 'Edit welcome screen'
              : questionnaire.preScreen!.title,
          description: questionnaire.preScreen!.style == PreScreenStyle.cards
              ? '${questionnaire.preScreen!.cards.length} cards'
              : '${questionnaire.preScreen!.items.length} list items',
          onTap: () => onNavigate(const EditorLocation(ContentKind.welcome)),
        ),
      const SizedBox(height: 12),
      ExpansionTile(
        title: const Text('Availability and scheduling'),
        tilePadding: EdgeInsets.zero,
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Visible in the app'),
            value: questionnaire.isActive,
            onChanged: (value) =>
                setQuestionnaire(questionnaire.copyWith(isActive: value)),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Show as coming soon'),
            value: questionnaire.isComingSoon,
            onChanged: (value) =>
                setQuestionnaire(questionnaire.copyWith(isComingSoon: value)),
          ),
          OptionalDateTimeField(
            label: 'Available from',
            value: questionnaire.activeFrom,
            onChanged: controller.setActiveFrom,
          ),
          const SizedBox(height: 16),
          OptionalDateTimeField(
            label: 'Available until',
            value: questionnaire.activeTo,
            onChanged: controller.setActiveTo,
          ),
          const SizedBox(height: 16),
          ContentField(
            label: 'Date label (optional)',
            value: questionnaire.dateLabel ?? '',
            onChanged: controller.setDateLabel,
          ),
        ],
      ),
      ExpansionTile(
        title: const Text('Advanced settings'),
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(top: 16),
        children: [
          ContentField(
            label: 'Questionnaire ID',
            value: questionnaire.id,
            helper:
                'Generated automatically. Change only if needed for an existing questionnaire.',
            onChanged: controller.setId,
          ),
          ContentField(
            label: 'Display order',
            value: questionnaire.sortOrder.toString(),
            keyboardType: TextInputType.number,
            onChanged: controller.setSortOrderFromText,
          ),
          DropdownButtonFormField<String>(
            key: ValueKey(questionnaire.showByCondition),
            initialValue: questionnaire.showByCondition ?? '',
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Show by condition'),
            items: [
              const DropdownMenuItem(value: '', child: Text('No condition')),
              const DropdownMenuItem(
                value: 'try_new_features',
                child: Text('Try new features section'),
              ),
              const DropdownMenuItem(
                value: extendedQuestionnaireCondition,
                child: Text('Extended questionnaire'),
              ),
              if (questionnaire.showByCondition != null &&
                  ![
                    'try_new_features',
                    extendedQuestionnaireCondition,
                  ].contains(questionnaire.showByCondition))
                DropdownMenuItem(
                  value: questionnaire.showByCondition!,
                  child: Text(questionnaire.showByCondition!),
                ),
            ],
            onChanged: questionnaire.requiresExtendedQuestionnaire
                ? null
                : controller.setShowByCondition,
          ),
          if (questionnaire.requiresExtendedQuestionnaire)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'The updated app is required for carousel and star rating questions. Compatibility is set automatically.',
              ),
            ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Mark as new until viewed'),
            value: questionnaire.showNotSeenMarker,
            onChanged: controller.setShowNotSeenMarker,
          ),
        ],
      ),
      const SizedBox(height: 24),
      FilledButton.icon(
        onPressed: () => onNavigate(const EditorLocation(ContentKind.question)),
        icon: const Icon(Icons.arrow_forward),
        label: const Text('Continue to questions'),
      ),
    ],
    subtitle: 'Start with what participants will see.',
  );

  Widget welcome(BuildContext context) {
    final welcome = questionnaire.preScreen;
    if (welcome == null) return setup(context);
    void back() => onNavigate(const EditorLocation(ContentKind.welcome));
    if (location.kind == ContentKind.welcomeCard &&
        location.index! < welcome.cards.length) {
      final index = location.index!;
      final card = welcome.cards[index];
      void update(PreScreenCard value) =>
          controller.updatePreScreenCard(index, value);
      return page(
        context,
        'Edit welcome card',
        [
          ContentField(
            label: 'Card title',
            value: card.title,
            autofocus: focus('title'),
            onChanged: (text) => update(card.copyWith(title: text)),
          ),
          ContentField(
            label: 'Card description',
            value: card.description,
            lines: 3,
            onChanged: (text) => update(card.copyWith(description: text)),
          ),
          ImageField(
            value: card.imageUrl,
            autofocus: focus('image'),
            onChanged: (url) => update(card.copyWith(imageUrl: url)),
          ),
          ExpansionTile(
            initiallyExpanded: card.buttonTitle != null || focus('buttonUrl'),
            title: const Text('Optional link button'),
            tilePadding: EdgeInsets.zero,
            children: [
              ContentField(
                label: 'Button text',
                value: card.buttonTitle ?? '',
                onChanged: (text) =>
                    update(card.copyWith(buttonTitle: optional(text))),
              ),
              ContentField(
                label: 'Button URL',
                value: card.buttonUrl ?? '',
                autofocus: focus('buttonUrl'),
                onChanged: (text) =>
                    update(card.copyWith(buttonUrl: optional(text))),
              ),
            ],
          ),
        ],
        subtitle: 'Welcome screen / Card ${index + 1}',
        back: back,
        actions: [
          IconButton(
            tooltip: 'Delete welcome card',
            onPressed: () {
              controller.removePreScreenCard(index);
              back();
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      );
    }
    if (location.kind == ContentKind.welcomeItem &&
        location.index! < welcome.items.length) {
      final index = location.index!;
      final item = welcome.items[index];
      void update(PreScreenItem value) =>
          controller.updatePreScreenItem(index, value);
      return page(
        context,
        'Edit welcome item',
        [
          ContentField(
            label: 'Item text',
            value: item.title,
            autofocus: focus('title'),
            onChanged: (text) => update(item.copyWith(title: text)),
          ),
          ImageField(
            label: 'Icon',
            value: item.iconUrl,
            requiredImage: true,
            autofocus: focus('image'),
            onChanged: (url) => update(item.copyWith(iconUrl: url ?? '')),
          ),
        ],
        subtitle: 'Welcome screen / Item ${index + 1}',
        back: back,
        actions: [
          IconButton(
            tooltip: 'Delete welcome item',
            onPressed: () {
              controller.removePreScreenItem(index);
              back();
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      );
    }
    return page(
      context,
      'Edit welcome screen',
      [
        ContentField(
          label: 'Welcome title',
          value: welcome.title,
          autofocus: focus('title'),
          onChanged: controller.setPreScreenTitle,
        ),
        ContentField(
          label: 'Welcome description',
          value: welcome.description,
          lines: 3,
          onChanged: controller.setPreScreenDescription,
        ),
        DropdownButtonFormField<PreScreenStyle>(
          key: ValueKey(welcome.style),
          initialValue: welcome.style,
          decoration: const InputDecoration(labelText: 'Welcome layout'),
          items: const [
            DropdownMenuItem(value: PreScreenStyle.cards, child: Text('Cards')),
            DropdownMenuItem(
              value: PreScreenStyle.list,
              child: Text('List with icons'),
            ),
          ],
          onChanged: (style) {
            if (style != null) controller.setPreScreenStyle(style);
          },
        ),
        const SizedBox(height: 24),
        if (welcome.style == PreScreenStyle.cards) ...[
          for (var i = 0; i < welcome.cards.length; i++)
            ContentSummary(
              title: welcome.cards[i].title.isEmpty
                  ? 'Untitled card ${i + 1}'
                  : welcome.cards[i].title,
              description: welcome.cards[i].description,
              imageUrl: welcome.cards[i].imageUrl,
              onTap: () =>
                  onNavigate(EditorLocation(ContentKind.welcomeCard, index: i)),
            ),
          OutlinedButton.icon(
            onPressed: () {
              controller.addPreScreenCard();
              onNavigate(
                EditorLocation(
                  ContentKind.welcomeCard,
                  index: welcome.cards.length,
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add welcome card'),
          ),
        ] else ...[
          for (var i = 0; i < welcome.items.length; i++)
            ContentSummary(
              title: welcome.items[i].title.isEmpty
                  ? 'Untitled item ${i + 1}'
                  : welcome.items[i].title,
              imageUrl: welcome.items[i].iconUrl,
              onTap: () =>
                  onNavigate(EditorLocation(ContentKind.welcomeItem, index: i)),
            ),
          OutlinedButton.icon(
            onPressed: () {
              controller.addPreScreenItem();
              onNavigate(
                EditorLocation(
                  ContentKind.welcomeItem,
                  index: welcome.items.length,
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add welcome item'),
          ),
        ],
      ],
      subtitle: 'Setup / Welcome screen',
      back: () => onNavigate(const EditorLocation(ContentKind.setup)),
    );
  }
}
