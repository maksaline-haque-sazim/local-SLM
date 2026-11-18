import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/utils/constants/app_assets.dart';

class AppLogoTile extends StatelessWidget {
  const AppLogoTile({
    super.key,
    this.size = 120,
    this.alignment = Alignment.center,
    this.onTap,
  });

  final double size;
  final Alignment alignment;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Align(
        alignment: alignment,
        child: Image.asset(
          AppAssets.logo,
          width: size,
          height: size,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}
