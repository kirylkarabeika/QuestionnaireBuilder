import 'package:flutter/material.dart';

class ContentField extends StatefulWidget {
  const ContentField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.lines = 1,
    this.keyboardType,
    this.autofocus = false,
    this.helper,
    this.error,
  });
  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final int lines;
  final TextInputType? keyboardType;
  final bool autofocus;
  final String? helper;
  final String? error;

  @override
  State<ContentField> createState() => _ContentFieldState();
}

class _ContentFieldState extends State<ContentField> {
  late final controller = TextEditingController(text: widget.value);
  final focus = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.autofocus)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        focus.requestFocus();
        Scrollable.ensureVisible(
          context,
          alignment: .25,
          duration: const Duration(milliseconds: 150),
        );
      });
  }

  @override
  void didUpdateWidget(covariant ContentField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (controller.text != widget.value && oldWidget.value != widget.value) {
      controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: TextField(
      controller: controller,
      focusNode: focus,
      maxLines: widget.lines,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.label,
        alignLabelWithHint: widget.lines > 1,
        helperText: widget.helper,
        errorText: widget.error,
      ),
      onChanged: widget.onChanged,
    ),
  );
}

class OptionalDescriptionField extends StatefulWidget {
  const OptionalDescriptionField({
    super.key,
    required this.value,
    required this.onChanged,
    this.autofocus = false,
  });
  final String? value;
  final ValueChanged<String?> onChanged;
  final bool autofocus;
  @override
  State<OptionalDescriptionField> createState() =>
      _OptionalDescriptionFieldState();
}

class _OptionalDescriptionFieldState extends State<OptionalDescriptionField> {
  late bool expanded = widget.value != null || widget.autofocus;
  @override
  Widget build(BuildContext context) =>
      expanded || (widget.value?.isNotEmpty ?? false) || widget.autofocus
      ? ContentField(
          label: 'Description (optional)',
          value: widget.value ?? '',
          lines: 3,
          autofocus: widget.autofocus,
          onChanged: (value) =>
              widget.onChanged(value.trim().isEmpty ? null : value),
        )
      : Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => setState(() => expanded = true),
            icon: const Icon(Icons.notes, size: 18),
            label: const Text('Add description'),
          ),
        );
}

class ContentImage extends StatelessWidget {
  const ContentImage({
    super.key,
    required this.url,
    this.size = 56,
    this.height,
    this.label = 'Image preview',
  });
  final String? url;
  final double size;
  final double? height;
  final String label;
  @override
  Widget build(BuildContext context) {
    final placeholder = ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: height == null ? size : double.infinity,
        height: height ?? size,
        child: (url?.trim().isNotEmpty ?? false)
            ? Image.network(
                url!.trim(),
                semanticLabel: label,
                fit: BoxFit.cover,
                webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
                errorBuilder: (_, _, _) => Tooltip(
                  message:
                      'Image could not be loaded. Check the link and image access.',
                  child: placeholder,
                ),
              )
            : placeholder,
      ),
    );
  }
}

class ImageField extends StatefulWidget {
  const ImageField({
    super.key,
    required this.value,
    required this.onChanged,
    this.requiredImage = false,
    this.autofocus = false,
    this.label = 'Image',
  });
  final String? value;
  final ValueChanged<String?> onChanged;
  final bool requiredImage;
  final bool autofocus;
  final String label;
  @override
  State<ImageField> createState() => _ImageFieldState();
}

class _ImageFieldState extends State<ImageField> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    final hasImage = widget.value?.isNotEmpty ?? false;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasImage)
            Row(
              children: [
                ContentImage(url: widget.value),
                const SizedBox(width: 12),
                Expanded(child: Text(widget.label)),
                IconButton(
                  tooltip: 'Change image',
                  onPressed: () => setState(() => expanded = !expanded),
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  tooltip: 'Remove image',
                  onPressed: () => widget.onChanged(null),
                  icon: const Icon(Icons.close),
                ),
              ],
            )
          else
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => setState(() => expanded = !expanded),
                icon: const Icon(Icons.add_photo_alternate_outlined, size: 18),
                label: Text(
                  'Add ${widget.label.toLowerCase()}${widget.requiredImage ? '' : ' (optional)'}',
                ),
              ),
            ),
          if (expanded || widget.autofocus)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ContentField(
                label: '${widget.label} URL',
                value: widget.value ?? '',
                autofocus: widget.autofocus,
                keyboardType: TextInputType.url,
                helper: 'Paste the full https:// link to your image.',
                onChanged: (value) => widget.onChanged(
                  value.trim().isEmpty ? null : value.trim(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ContentSummary extends StatelessWidget {
  const ContentSummary({
    super.key,
    required this.title,
    required this.onTap,
    this.description,
    this.imageUrl,
    this.icon = Icons.chevron_right,
    this.trailing,
  });
  final String title;
  final String? description;
  final String? imageUrl;
  final IconData icon;
  final VoidCallback onTap;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 10),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: imageUrl == null ? null : ContentImage(url: imageUrl, size: 44),
      title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: description?.isNotEmpty ?? false
          ? Text(description!, maxLines: 2, overflow: TextOverflow.ellipsis)
          : null,
      trailing: trailing ?? Icon(icon),
      onTap: onTap,
    ),
  );
}
