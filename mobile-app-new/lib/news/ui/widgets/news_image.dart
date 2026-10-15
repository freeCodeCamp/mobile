import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Shared image treatment for article covers and author portraits.
class NewsImage extends StatelessWidget {
  const NewsImage({
    super.key,
    this.url,
    this.isAvatar = false,
    this.width,
    this.height,
  });

  final String? url;
  final bool isAvatar;
  final double? width;
  final double? height;

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
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(isAvatar ? 100 : 12),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: url == null || url!.isEmpty
          ? fallback
          : CachedNetworkImage(
              imageUrl: url!,
              fit: BoxFit.cover,
              placeholder: (_, _) =>
                  ColoredBox(color: colors.surfaceContainerLow),
              errorWidget: (_, _, _) => fallback,
            ),
    );
  }
}
