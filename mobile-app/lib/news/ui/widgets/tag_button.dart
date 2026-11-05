import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/routing/news.dart';

enum TagButtonVariant { listEyebrow, articleEyebrow, link }

class TagButton extends StatelessWidget {
  const TagButton({
    super.key,
    required this.tagName,
    required this.tagSlug,
    this.variant = TagButtonVariant.link,
  });

  final String tagName;
  final String tagSlug;
  final TagButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final link = variant == TagButtonVariant.link;
    final listEyebrow = variant == TagButtonVariant.listEyebrow;
    final button = Padding(
      padding: EdgeInsets.only(right: 6, bottom: link ? 8 : 0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * (link ? .7 : .5),
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            minimumSize: link ? const Size(48, 44) : const Size(48, 0),
            tapTargetSize: !link
                ? MaterialTapTargetSize.shrinkWrap
                : MaterialTapTargetSize.padded,
            padding: EdgeInsets.zero,
            alignment: AlignmentDirectional.centerStart,
            textStyle: TextStyle(
              fontFamily: listEyebrow ? 'JetBrains Mono' : 'Lato',
              fontSize: listEyebrow
                  ? 12
                  : link
                  ? 15
                  : 14,
              fontWeight: listEyebrow ? FontWeight.w400 : FontWeight.w700,
              letterSpacing: 0,
              decoration: link ? TextDecoration.underline : TextDecoration.none,
            ),
          ).copyWith(shape: FccTheme.focusShape(context, radius: 10)),
          onPressed: () =>
              NewsTagFeedRoute(tagSlug: tagSlug, $extra: tagName).push(context),
          child: Text(
            '#$tagName',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
    return link ? button : _EyebrowTapTarget(child: button);
  }
}

// Keep the compact eyebrow stack while exposing a full-sized touch target.
class _EyebrowTapTarget extends SingleChildRenderObjectWidget {
  const _EyebrowTapTarget({required super.child});

  @override
  RenderProxyBox createRenderObject(BuildContext context) =>
      _EyebrowTargetBox();
}

class _EyebrowTargetBox extends RenderProxyBox {
  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config
      ..isSemanticBoundary = true
      ..isMergingSemanticsOfDescendants = true;
  }

  @override
  Rect get semanticBounds => Rect.fromLTWH(
    0,
    0,
    size.width < 48 ? 48 : size.width,
    size.height < 48 ? 48 : size.height,
  );

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (!semanticBounds.contains(position) || size.isEmpty) return false;
    return super.hitTest(
      result,
      position: Offset(
        position.dx.clamp(0, size.width - .001),
        position.dy.clamp(0, size.height - .001),
      ),
    );
  }
}

class TagButtonColumn extends Column {
  const TagButtonColumn({super.key, required super.children})
    : super(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
      );

  @override
  RenderFlex createRenderObject(BuildContext context) =>
      _TagFirstColumn(textDirection: Directionality.of(context));
}

class _TagFirstColumn extends RenderFlex {
  _TagFirstColumn({required super.textDirection})
    : super(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
      );

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final first = firstChild;
    if (first != null) {
      final data = first.parentData! as FlexParentData;
      // The 48px eyebrow target takes precedence over the non-interactive title.
      if (result.addWithPaintOffset(
        offset: data.offset,
        position: position,
        hitTest: (result, position) =>
            first.hitTest(result, position: position),
      )) {
        return true;
      }
    }
    return super.hitTestChildren(result, position: position);
  }
}
