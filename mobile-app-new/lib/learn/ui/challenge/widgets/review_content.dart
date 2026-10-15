import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html;
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/example_editor.dart';

/// Keeps the persistent topic strip and app bar in sync with the article.
class ReviewController extends ChangeNotifier {
  ReviewController(List<Nodule> nodules) : _sections = _group(nodules);
  final List<_ReviewSection> _sections;
  List<_ReviewSection> get _topics =>
      _sections.where((s) => s.title != null).toList();
  int _selected = 0;
  bool _jumping = false;
  int get selected => _selected;
  int get topicCount => _topics.length;

  void _setSelected(int index) {
    if (_selected == index) return;
    _selected = index;
    notifyListeners();
  }

  Future<void> select(int index) async {
    _setSelected(index);
    final target = _topics[index].anchor.currentContext;
    if (target == null) return;
    _jumping = true;
    await Scrollable.ensureVisible(
      target,
      duration: MediaQuery.disableAnimationsOf(target)
          ? Duration.zero
          : const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: 0,
    );
    _jumping = false;
  }

  void sync(ScrollPosition position) {
    if (_jumping || _topics.isEmpty) return;
    final viewport = position.context.notificationContext?.findRenderObject();
    if (viewport is! RenderBox || !viewport.hasSize) return;
    final top = viewport.localToGlobal(Offset.zero).dy + 24;
    var current = 0;
    for (final (index, section) in _topics.indexed) {
      final box = section.anchor.currentContext?.findRenderObject();
      if (box is RenderBox &&
          box.hasSize &&
          box.localToGlobal(Offset.zero).dy <= top) {
        current = index;
      }
    }
    if (position.pixels > 0 && position.extentAfter < 1) {
      current = topicCount - 1;
    }
    _setSelected(current);
  }
}

class ReviewTopics extends StatefulWidget {
  const ReviewTopics({super.key, required this.controller});
  final ReviewController controller;

  @override
  State<ReviewTopics> createState() => _ReviewTopicsState();
}

class _ReviewTopicsState extends State<ReviewTopics> {
  late final _keys = List.generate(
    widget.controller.topicCount,
    (_) => GlobalKey(),
  );
  ReviewController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    controller.addListener(_revealSelection);
  }

  void _revealSelection() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final target = _keys[controller.selected].currentContext;
      final object = target?.findRenderObject();
      if (target == null || object == null) return;
      Scrollable.of(target).position.ensureVisible(
        object,
        alignment: .5,
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : const Duration(milliseconds: 150),
      );
    });
  }

  @override
  void dispose() {
    controller.removeListener(_revealSelection);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) {
      final colors = Theme.of(context).colorScheme;
      return Semantics(
        label: 'Review topics',
        container: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              for (final (index, section) in controller._topics.indexed)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    key: _keys[index],
                    label: Text(section.title!),
                    selected: index == controller.selected,
                    showCheckmark: false,
                    labelStyle: TextStyle(
                      color: index == controller.selected
                          ? colors.onPrimary
                          : colors.onSurface,
                    ),
                    tooltip:
                        'Jump to topic ${index + 1} of ${controller.topicCount}',
                    onSelected: (_) => controller.select(index),
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}

class ReviewContent extends StatefulWidget {
  const ReviewContent({super.key, required this.nodules, this.controller});
  final List<Nodule> nodules;
  final ReviewController? controller;
  @override
  State<ReviewContent> createState() => _ReviewContentState();
}

class _ReviewContentState extends State<ReviewContent> {
  late final _controller =
      widget.controller ?? ReviewController(widget.nodules);
  ScrollPosition? _position;
  bool _syncScheduled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final next = Scrollable.maybeOf(context)?.position;
    if (next != _position) {
      _position?.removeListener(_sync);
      _position = next;
      _position?.addListener(_sync);
    }
  }

  void _sync() {
    if (_syncScheduled) return;
    _syncScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncScheduled = false;
      if (mounted && _position != null) {
        _controller.sync(_position!);
      }
    });
  }

  @override
  void dispose() {
    _position?.removeListener(_sync);
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      if (widget.controller == null && _controller.topicCount > 0)
        ReviewTopics(controller: _controller),
      for (final section in _controller._sections)
        Column(
          key: section.anchor,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [ExampleEditor(nodules: section.nodules)],
        ),
    ],
  );
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
