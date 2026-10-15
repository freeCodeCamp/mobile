import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html;
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/example_editor.dart';

/// A review's topic index and complete content, sharing the lesson's scroll view.
class ReviewContent extends StatefulWidget {
  const ReviewContent({super.key, required this.nodules});

  final List<Nodule> nodules;

  @override
  State<ReviewContent> createState() => _ReviewContentState();
}

class _ReviewContentState extends State<ReviewContent> {
  late List<_ReviewSection> _sections = _group(widget.nodules);
  int _selected = 0;

  @override
  void didUpdateWidget(ReviewContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.nodules, widget.nodules)) {
      _sections = _group(widget.nodules);
      _selected = 0;
    }
  }

  Future<void> _select(int index, _ReviewSection section) async {
    setState(() => _selected = index);
    final target = section.anchor.currentContext;
    if (target == null) return;
    await Scrollable.ensureVisible(
      target,
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final topics = _sections.where((s) => s.title != null).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (topics.isNotEmpty) ...[
          Semantics(
            label: 'Review topics',
            container: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final (index, section) in topics.indexed)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(section.title!),
                        selected: index == _selected,
                        showCheckmark: false,
                        labelStyle: TextStyle(
                          color: index == _selected
                              ? colors.onPrimary
                              : colors.onSurface,
                        ),
                        tooltip:
                            'Jump to topic ${index + 1} of ${topics.length}',
                        onSelected: (_) => _select(index, section),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        for (final section in _sections)
          Column(
            key: section.anchor,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [ExampleEditor(nodules: section.nodules)],
          ),
      ],
    );
  }
}

class _ReviewSection {
  _ReviewSection({this.title});

  final String? title;
  final anchor = GlobalKey();
  final nodules = <Nodule>[];
}

List<_ReviewSection> _group(List<Nodule> nodules) {
  final sections = <_ReviewSection>[];
  var current = _ReviewSection();
  sections.add(current);
  for (final nodule in nodules) {
    if (nodule is! ParagraphNodule) {
      current.nodules.add(nodule);
      continue;
    }
    final fragment = html.parseFragment(nodule.contents);
    if (!fragment.children.any((element) => element.localName == 'h2')) {
      current.nodules.add(nodule);
      continue;
    }

    // A paragraph nodule can contain both a heading and surrounding content.
    // Split only at real headings, preserving the original markup and order.
    var buffer = dom.DocumentFragment();
    void flush() {
      if (buffer.nodes.isNotEmpty) {
        current.nodules.add(Nodule.paragraph(contents: buffer.outerHtml));
        buffer = dom.DocumentFragment();
      }
    }

    for (final node in fragment.nodes) {
      if (node is dom.Element && node.localName == 'h2') {
        final title = node.text.trim().replaceAll(RegExp(r'\s+'), ' ');
        if (title.isNotEmpty) {
          flush();
          current = _ReviewSection(title: title);
          sections.add(current);
        }
      }
      buffer.append(node.clone(true));
    }
    flush();
  }
  return sections.where((section) => section.nodules.isNotEmpty).toList();
}
