import 'package:flutter/material.dart';

typedef DownloadItemBuilder =
    Widget Function(
      BuildContext context,
      int index,
      bool managing,
      bool selected,
      VoidCallback? onSelect,
    );

class DownloadManagementList extends StatefulWidget {
  const DownloadManagementList({
    super.key,
    this.header,
    this.footer,
    required this.items,
    required this.itemBuilder,
    required this.onRemove,
    required this.emptyState,
  });

  final Widget? header;
  final Widget? footer;
  final List<String> items;
  final DownloadItemBuilder itemBuilder;
  final Future<void> Function(List<String>) onRemove;
  final Widget emptyState;

  @override
  State<DownloadManagementList> createState() => _DownloadManagementListState();
}

class _DownloadManagementListState extends State<DownloadManagementList> {
  final _selected = <String>{};
  bool _managing = false;
  bool _removing = false;

  @override
  void didUpdateWidget(covariant DownloadManagementList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _selected.retainWhere(widget.items.contains);
    if (widget.items.isEmpty) _managing = false;
  }

  Future<void> _remove() async {
    setState(() => _removing = true);
    try {
      await widget.onRemove(_selected.toList());
      if (!mounted) return;
      setState(() {
        _selected.clear();
        _managing = false;
      });
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to remove some downloads. Please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _removing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ListView(
      padding: EdgeInsets.fromLTRB(
        18,
        widget.header == null ? 0 : 16,
        18,
        24 + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        if (widget.header != null) widget.header!,
        if (widget.items.isEmpty)
          widget.emptyState
        else ...[
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
              onPressed: _removing
                  ? null
                  : () => setState(() {
                      _managing = !_managing;
                      _selected.clear();
                    }),
              child: Text(_managing ? 'Done' : 'Manage'),
            ),
          ),
          if (_managing)
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 12,
              children: [
                TextButton(
                  onPressed: _removing
                      ? null
                      : () => setState(() {
                          if (_selected.length == widget.items.length) {
                            _selected.clear();
                          } else {
                            _selected.addAll(widget.items);
                          }
                        }),
                  child: Text(
                    _selected.length == widget.items.length
                        ? 'Deselect all'
                        : 'Select all',
                  ),
                ),
                TextButton.icon(
                  onPressed: _selected.isEmpty || _removing ? null : _remove,
                  icon: _removing
                      ? const SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.delete_outline_rounded, size: 18),
                  label: Text('Remove (${_selected.length})'),
                ),
              ],
            ),
          const SizedBox(height: 8),
          Material(
            color: colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: colors.outlineVariant),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (var i = 0; i < widget.items.length; i++) ...[
                  if (i > 0) Divider(height: 1, color: colors.outlineVariant),
                  widget.itemBuilder(
                    context,
                    i,
                    _managing,
                    _selected.contains(widget.items[i]),
                    _removing
                        ? null
                        : () => setState(() {
                            final id = widget.items[i];
                            if (!_selected.add(id)) _selected.remove(id);
                          }),
                  ),
                ],
              ],
            ),
          ),
          if (widget.footer != null) ...[
            const SizedBox(height: 12),
            widget.footer!,
          ],
        ],
      ],
    );
  }
}
