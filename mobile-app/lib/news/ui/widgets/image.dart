import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NewsImage extends StatelessWidget {
  const NewsImage({
    super.key,
    this.url,
    this.isAvatar = false,
    this.width,
    this.height,
    this.radius = 12,
  });

  final String? url;
  final bool isAvatar;
  final double? width;
  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final fallback = Image.asset(
      isAvatar
          ? 'assets/images/placeholder-profile-img.png'
          : 'assets/images/freecodecamp-banner.png',
      fit: BoxFit.cover,
    );

    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(isAvatar ? 100 : radius),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => url == null || url!.isEmpty
            ? fallback
            : CachedNetworkImage(
                imageUrl: url!,
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                fit: BoxFit.cover,
                placeholder: (_, _) =>
                    ColoredBox(color: colors.surfaceContainer),
                errorWidget: (_, _, _) => fallback,
              ),
      ),
    );
  }
}
