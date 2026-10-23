import 'package:flutter/material.dart';

import '../models/questionnaire.dart';

class PreScreenItemEditor extends StatefulWidget {
  const PreScreenItemEditor({
    super.key,
    required this.item,
    required this.index,
    required this.onChanged,
    required this.onDelete,
  });

  final PreScreenItem item;
  final int index;
  final ValueChanged<PreScreenItem> onChanged;
  final VoidCallback onDelete;

  @override
  State<PreScreenItemEditor> createState() => _PreScreenItemEditorState();
}

class _PreScreenItemEditorState extends State<PreScreenItemEditor> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _iconUrlCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.item.title);
    _iconUrlCtrl = TextEditingController(text: widget.item.iconUrl);
  }

  @override
  void didUpdateWidget(covariant PreScreenItemEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncIfNeeded(_titleCtrl, widget.item.title);
    _syncIfNeeded(_iconUrlCtrl, widget.item.iconUrl);
  }

  void _syncIfNeeded(TextEditingController controller, String text) {
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
    _iconUrlCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const placeholder = Icon(Icons.image_outlined, size: 24);
    final iconUrl = widget.item.iconUrl.trim();
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Item ${widget.index + 1}',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SizedBox.square(
                dimension: 32,
                child: iconUrl.isEmpty
                    ? placeholder
                    : Image.network(
                        iconUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) => placeholder,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (title) =>
                      widget.onChanged(widget.item.copyWith(title: title)),
                ),
              ),
              IconButton(
                tooltip: 'Delete item',
                onPressed: widget.onDelete,
                icon: const Icon(Icons.delete, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _iconUrlCtrl,
            keyboardType: TextInputType.url,
            decoration: const InputDecoration(
              labelText: 'Icon URL',
              hintText: 'https://…',
              border: OutlineInputBorder(),
            ),
            onChanged: (url) =>
                widget.onChanged(widget.item.copyWith(iconUrl: url.trim())),
          ),
          const Divider(height: 24),
        ],
      ),
    );
  }
}
