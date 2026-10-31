import 'package:flutter/material.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/routing/auth.dart';
import 'package:freecodecamp/widgets/app_bottom_navigation.dart';
import 'package:go_router/go_router.dart';

Future<bool> confirmProfileDiscard(BuildContext context) async =>
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
        contentTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        title: const Text('Discard changes?'),
        content: const Text(
          "You've made changes to your profile that aren't saved yet.",
        ),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  textStyle: const TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Keep editing'),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                style: FccTheme.dangerOutlineStyle(context).copyWith(
                  minimumSize: const WidgetStatePropertyAll(
                    Size.fromHeight(50),
                  ),
                  textStyle: const WidgetStatePropertyAll(
                    TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Discard'),
              ),
            ],
          ),
        ],
      ),
    ) ??
    false;

class ProfileFormScaffold extends StatefulWidget {
  const ProfileFormScaffold({
    super.key,
    required this.title,
    required this.child,
    required this.isDirty,
    required this.onSave,
    this.saving = false,
    this.onCancel,
    this.navigationDirty = false,
  });

  final String title;
  final Widget child;
  final bool isDirty;
  final VoidCallback? onSave;
  final bool saving;
  final Future<bool> Function()? onCancel;
  final bool navigationDirty;

  @override
  State<ProfileFormScaffold> createState() => ProfileFormScaffoldState();
}

class ProfileFormScaffoldState extends State<ProfileFormScaffold> {
  bool _allowPop = false;
  bool _confirming = false;

  Future<bool> _canLeave({required bool navigation}) async {
    if (widget.saving || _confirming) return false;
    _confirming = true;
    try {
      if (!navigation && widget.onCancel != null) {
        return await widget.onCancel!();
      }
      final dirty = widget.isDirty || (navigation && widget.navigationDirty);
      return !dirty || await confirmProfileDiscard(context);
    } finally {
      _confirming = false;
    }
  }

  Future<void> _cancel() async {
    if (await _canLeave(navigation: false) && mounted) await close();
  }

  Future<void> close() async {
    if (!mounted) return;
    setState(() => _allowPop = true);
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;
    if (context.canPop()) {
      context.pop();
    } else {
      const ProfileRoute().go(context);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop:
        _allowPop ||
        (!widget.isDirty && !widget.saving && widget.onCancel == null),
    onPopInvokedWithResult: (didPop, _) {
      if (!didPop) _cancel();
    },
    child: Scaffold(
      appBar: AppBar(
        leadingWidth: 84,
        leading: TextButton(
          onPressed: widget.saving ? null : _cancel,
          child: const Text('Cancel'),
        ),
        title: Text(widget.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                minimumSize: const Size(64, 44),
              ).copyWith(shape: FccTheme.focusShape(context, radius: 10)),
              onPressed: widget.saving ? null : widget.onSave,
              child: Text(widget.saving ? 'Saving…' : 'Save'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppNavigationFooter(
        selected: AppDestination.account,
        beforeNavigate: () => _canLeave(navigation: true),
      ),
      body: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: widget.child,
          ),
        ),
      ),
    ),
  );
}

class ProfileFormField extends StatelessWidget {
  const ProfileFormField({
    super.key,
    required this.label,
    required this.controller,
    this.onChanged,
    this.errorText,
    this.helperText,
    this.hintText,
    this.maxLength,
    this.maxLines = 1,
    this.keyboardType,
    this.style,
    this.enabled = true,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final String? helperText;
  final String? hintText;
  final int? maxLength;
  final int maxLines;
  final TextInputType? keyboardType;
  final TextStyle? style;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final edge = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colors.outline),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            enabled: enabled,
            onChanged: onChanged,
            maxLength: maxLength,
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: theme.textTheme.bodyLarge
                ?.copyWith(height: 1.5, letterSpacing: 0)
                .merge(style),
            buildCounter: maxLength == null
                ? null
                : (
                    context, {
                    required currentLength,
                    required isFocused,
                    maxLength,
                  }) => Text(
                    '$currentLength / $maxLength characters',
                    textAlign: TextAlign.right,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 13,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
            autocorrect: keyboardType != TextInputType.url,
            textInputAction: maxLines > 1
                ? TextInputAction.newline
                : TextInputAction.next,
            decoration: InputDecoration(
              hintText: hintText,
              error: errorText == null
                  ? null
                  : ProfileFieldError(message: errorText!),
              helperText: helperText,
              helperMaxLines: 3,
              filled: true,
              fillColor: colors.surface,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: maxLines > 1 ? 18 : 12,
              ),
              border: edge,
              enabledBorder: edge,
              focusedBorder: edge.copyWith(
                borderSide: BorderSide(color: colors.primary, width: 2),
              ),
              errorBorder: edge.copyWith(
                borderSide: BorderSide(color: colors.error, width: 2),
              ),
              focusedErrorBorder: edge.copyWith(
                borderSide: BorderSide(color: colors.error, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileFieldError extends StatelessWidget {
  const ProfileFieldError({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      liveRegion: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: ExcludeSemantics(
              child: Icon(
                Icons.error_outline,
                color: theme.colorScheme.error,
                size: 14,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              message,
              maxLines: 3,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileFormError extends StatelessWidget {
  const ProfileFormError({
    super.key,
    required this.message,
    this.onDismiss,
    this.margin = const EdgeInsets.only(bottom: 18),
    this.floating = false,
  });
  final String message;
  final VoidCallback? onDismiss;
  final EdgeInsets margin;
  final bool floating;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      liveRegion: true,
      child: Container(
        margin: margin,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Color.alphaBlend(
            colors.error.withValues(alpha: 0.1),
            colors.surface,
          ),
          border: Border.all(color: colors.error),
          borderRadius: BorderRadius.circular(14),
          boxShadow: floating
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.error_outline, color: colors.error, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
            if (onDismiss != null)
              IconButton(
                tooltip: 'Dismiss error',
                onPressed: onDismiss,
                icon: Icon(Icons.close, color: colors.error, size: 20),
              ),
          ],
        ),
      ),
    );
  }
}

class ProfileDashedBorder extends StatelessWidget {
  const ProfileDashedBorder({
    super.key,
    required this.child,
    required this.color,
  });
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(foregroundPainter: _DashedBorderPainter(color), child: child);
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final outline = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          (Offset.zero & size).deflate(0.5),
          const Radius.circular(12),
        ),
      );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (final metric in outline.computeMetrics()) {
      for (var start = 0.0; start < metric.length; start += 5) {
        final end = start + 3 < metric.length ? start + 3 : metric.length;
        canvas.drawPath(metric.extractPath(start, end), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color;
}

class ProfileFormSectionTitle extends StatelessWidget {
  const ProfileFormSectionTitle(this.title, {super.key});
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 12),
    child: Text(
      title,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    ),
  );
}
