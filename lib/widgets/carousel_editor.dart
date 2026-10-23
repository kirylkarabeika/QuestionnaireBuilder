import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/questionnaire.dart';

class CarouselEditor extends StatelessWidget {
  const CarouselEditor({
    super.key,
    required this.selectionMode,
    required this.items,
    required this.onSelectionModeChanged,
    required this.onItemsChanged,
  });

  final CarouselSelectionMode selectionMode;
  final List<CarouselItem> items;
  final ValueChanged<CarouselSelectionMode> onSelectionModeChanged;
  final ValueChanged<List<CarouselItem>> onItemsChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<CarouselSelectionMode>(
          key: ValueKey(selectionMode),
          initialValue: selectionMode,
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'Selection mode',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(
              value: CarouselSelectionMode.singleSelect,
              child: Text('Single select'),
            ),
            DropdownMenuItem(
              value: CarouselSelectionMode.multiSelect,
              child: Text('Multi select'),
            ),
          ],
          onChanged: (mode) {
            if (mode != null) onSelectionModeChanged(mode);
          },
        ),
        const SizedBox(height: 16),
        Text('Items', style: Theme.of(context).textTheme.titleMedium),
        for (int i = 0; i < items.length; i++)
          _CarouselItemEditor(
            key: ValueKey(items[i].id),
            item: items[i],
            index: i,
            onChanged: (item) => onItemsChanged([
              for (final current in items)
                current.id == item.id ? item : current,
            ]),
            onDelete: () {
              final remaining = [...items]..removeAt(i);
              onItemsChanged([
                for (int j = 0; j < remaining.length; j++)
                  remaining[j].copyWith(order: j),
              ]);
            },
          ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => onItemsChanged([
            ...items,
            CarouselItem(
              id: const Uuid().v4(),
              order: items.length,
              title: '',
              imageUrl: '',
            ),
          ]),
          icon: const Icon(Icons.add),
          label: const Text('Add carousel item'),
        ),
      ],
    );
  }
}

class _CarouselItemEditor extends StatefulWidget {
  const _CarouselItemEditor({
    super.key,
    required this.item,
    required this.index,
    required this.onChanged,
    required this.onDelete,
  });

  final CarouselItem item;
  final int index;
  final ValueChanged<CarouselItem> onChanged;
  final VoidCallback onDelete;

  @override
  State<_CarouselItemEditor> createState() => _CarouselItemEditorState();
}

class _CarouselItemEditorState extends State<_CarouselItemEditor> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _imageUrlCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.item.title);
    _descriptionCtrl = TextEditingController(text: widget.item.description);
    _imageUrlCtrl = TextEditingController(text: widget.item.imageUrl);
  }

  @override
  void didUpdateWidget(covariant _CarouselItemEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync(_titleCtrl, widget.item.title);
    _sync(_descriptionCtrl, widget.item.description);
    _sync(_imageUrlCtrl, widget.item.imageUrl);
  }

  void _sync(TextEditingController controller, String text) {
    if (controller.text != text) {
      controller.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    _imageUrlCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Item ${widget.index + 1}'),
                const Spacer(),
                IconButton(
                  tooltip: 'Delete carousel item',
                  onPressed: widget.onDelete,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Item title',
                border: OutlineInputBorder(),
              ),
              onChanged: (title) =>
                  widget.onChanged(widget.item.copyWith(title: title)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Item description',
                border: OutlineInputBorder(),
              ),
              onChanged: (description) => widget.onChanged(
                widget.item.copyWith(description: description),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _imageUrlCtrl,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'Item image URL',
                hintText: 'https://…',
                border: OutlineInputBorder(),
              ),
              onChanged: (url) =>
                  widget.onChanged(widget.item.copyWith(imageUrl: url.trim())),
            ),
          ],
        ),
      ),
    );
  }
}
