import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_app_new/fcc_theme.dart';

class SuperBlockButton extends StatelessWidget {
  const SuperBlockButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.icon,
    this.svgAsset,
    this.isEnabled = true,
  });

  final String title;
  final VoidCallback onPressed;
  final IconData? icon;
  final String? svgAsset;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isEnabled ? 1 : 0.7,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        constraints: const BoxConstraints(minHeight: 80),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(5),
            backgroundColor: FccColors.gray80,
            side: const BorderSide(width: 2, color: FccColors.gray75),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
          ),
          onPressed: onPressed,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: svgAsset != null
                      ? SvgPicture.asset(
                          svgAsset!,
                          fit: BoxFit.contain,
                          colorFilter: const ColorFilter.mode(
                            FccColors.gray00,
                            BlendMode.srcIn,
                          ),
                        )
                      : Icon(icon, color: FccColors.gray00, size: 36),
                ),
              ),
              Expanded(
                child: Text(title, style: const TextStyle(fontSize: 20)),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
