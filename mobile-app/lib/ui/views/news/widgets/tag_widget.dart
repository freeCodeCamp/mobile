import 'dart:math';

import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class TagButton extends StatefulWidget {
  const TagButton({
    super.key,
    required this.tagName,
    required this.tagSlug,
    this.compact = false,
  });

  final String tagName;
  final String tagSlug;
  final bool compact;

  static Color randomColor() {
    var randomNum = Random();

    List colors = [
      const Color.fromRGBO(0xdb, 0xb8, 0xff, 1),
      const Color.fromRGBO(0xf1, 0xbe, 0x32, 1),
      const Color.fromRGBO(0x99, 0xc9, 0xff, 1),
      const Color.fromRGBO(0xac, 0xd1, 0x57, 1)
    ];

    return colors[randomNum.nextInt(4)];
  }

  @override
  State<TagButton> createState() => _TagButtonState();
}

class _TagButtonState extends State<TagButton>
    with AutomaticKeepAliveClientMixin {
  final _navigationService = locator<NavigationService>();
  final _tagColor = TagButton.randomColor();
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    final isCompact = widget.compact;

    return Padding(
      padding: EdgeInsets.fromLTRB(0, isCompact ? 0 : 8, isCompact ? 6 : 8, 0),
      child: InkWell(
        onTap: () {
          _navigationService.navigateTo(
            Routes.newsFeedView,
            arguments: NewsFeedViewArguments(
              tagSlug: widget.tagSlug,
              fromTag: true,
              subject: widget.tagName,
            ),
          );
        },
        child: Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * (isCompact ? 0.35 : 0.45)),
          decoration: ShapeDecoration(
            color: _tagColor,
            shape: const StadiumBorder(),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: isCompact ? 2 : 4,
              horizontal: isCompact ? 6 : 8,
            ),
            child: Tooltip(
              message: '#${widget.tagName}',
              child: Text(
                '#${widget.tagName}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isCompact ? 11 : 16,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
