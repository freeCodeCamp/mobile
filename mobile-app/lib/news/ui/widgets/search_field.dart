import 'package:flutter/material.dart';

class NewsSearchField extends StatelessWidget {
  const NewsSearchField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: focusNode,
    builder: (context, _) {
      final theme = Theme.of(context);
      final colors = theme.colorScheme;
      final hasQuery = controller.text.isNotEmpty;
      final onDismiss = hasQuery
          ? onClear
          : focusNode.hasFocus
          ? focusNode.unfocus
          : null;
      final border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.outlineVariant, width: 1.5),
      );

      final field = TextField(
        controller: controller,
        focusNode: focusNode,
        onTapOutside: (_) => focusNode.unfocus(),
        onSubmitted: (_) => focusNode.unfocus(),
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        style: const TextStyle(fontSize: 16, height: 1.5),
        decoration: InputDecoration(
          hintText: 'Search articles',
          hintStyle: TextStyle(
            fontSize: 16,
            height: 1.5,
            color: theme.hintColor,
          ),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 16, right: 12),
            child: Icon(Icons.search_rounded, size: 24),
          ),
          prefixIconColor: colors.onSurface,
          prefixIconConstraints: const BoxConstraints(minHeight: 48),
          suffixIcon: onDismiss != null
              ? IconButton(
                  tooltip: hasQuery ? 'Clear search' : 'Dismiss keyboard',
                  icon: const Icon(Icons.close_rounded),
                  onPressed: onDismiss,
                )
              : null,
          fillColor: colors.surface,
          filled: true,
          border: border,
          enabledBorder: border,
          focusedBorder: border.copyWith(
            borderSide: BorderSide(color: colors.primary, width: 1.5),
          ),
        ),
      );

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: field,
      );
    },
  );
}
