import 'package:flutter/material.dart';

import '../models/questionnaire.dart';

class StarRatingEditor extends StatefulWidget {
  const StarRatingEditor({
    super.key,
    required this.rating,
    required this.onChanged,
    this.focusField,
  });

  final StarRating rating;
  final ValueChanged<StarRating> onChanged;
  final String? focusField;

  @override
  State<StarRatingEditor> createState() => _StarRatingEditorState();
}

class _StarRatingEditorState extends State<StarRatingEditor> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _countCtrl;
  late final TextEditingController _descriptionCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.rating.title);
    _countCtrl = TextEditingController(
      text: widget.rating.starCount.toString(),
    );
    _descriptionCtrl = TextEditingController(text: widget.rating.description);
  }

  @override
  void didUpdateWidget(covariant StarRatingEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync(_titleCtrl, widget.rating.title);
    _sync(_descriptionCtrl, widget.rating.description);
    if (oldWidget.rating.starCount != widget.rating.starCount) {
      _sync(_countCtrl, widget.rating.starCount.toString());
    }
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
    _countCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = int.tryParse(_countCtrl.text.trim());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Star rating', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        TextField(
          controller: _titleCtrl,
          autofocus: widget.focusField == 'title',
          decoration: const InputDecoration(
            labelText: 'Rating title',
            border: OutlineInputBorder(),
          ),
          onChanged: (title) =>
              widget.onChanged(widget.rating.copyWith(title: title)),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _countCtrl,
          autofocus: widget.focusField == 'count',
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Number of stars',
            border: const OutlineInputBorder(),
            errorText: count == null || count < 1
                ? 'Enter a positive whole number'
                : null,
          ),
          onChanged: (value) {
            setState(() {});
            final stars = int.tryParse(value.trim());
            if (stars != null && stars > 0) {
              widget.onChanged(widget.rating.copyWith(starCount: stars));
            }
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _descriptionCtrl,
          autofocus: widget.focusField == 'description',
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Rating description',
            border: OutlineInputBorder(),
          ),
          onChanged: (description) => widget.onChanged(
            widget.rating.copyWith(description: description),
          ),
        ),
      ],
    );
  }
}
