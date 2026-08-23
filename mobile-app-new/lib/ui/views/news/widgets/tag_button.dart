import 'package:flutter/material.dart';
import 'package:mobile_app_new/fcc_theme.dart';

class TagButton extends StatelessWidget {
  const TagButton({
    super.key,
    required this.tagName,
    required this.tagSlug,
    this.compact = false,
  });

  final String tagName;
  final String tagSlug;
  final bool compact;

  static const _colors = [
    FccColors.purple10,
    FccColors.yellow50,
    FccColors.blue30,
    FccColors.green40,
  ];

  Color get _tagColor => _colors[tagSlug.hashCode.abs() % _colors.length];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, compact ? 0 : 8, compact ? 6 : 8, 0),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to tag-filtered feed
        },
        child: Container(
          constraints: BoxConstraints(
            maxWidth:
                MediaQuery.of(context).size.width * (compact ? 0.35 : 0.45),
          ),
          decoration: ShapeDecoration(
            color: _tagColor,
            shape: const StadiumBorder(),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: compact ? 2 : 4,
              horizontal: compact ? 6 : 8,
            ),
            child: Tooltip(
              message: '#$tagName',
              child: Text(
                '#$tagName',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: compact ? 11 : 16,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
