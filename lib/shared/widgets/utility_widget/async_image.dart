import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/utils/theme/theme.dart';
import 'package:flutter_getx_starter_template/utils/theme/theme_extensions.dart';

class AsyncImage extends StatelessWidget {
  const AsyncImage({
    super.key,
    this.imageFuture,
    this.directUrl,
    this.borderRadius,
    this.fit = BoxFit.cover,
  });

  final Future<String>? imageFuture;
  final String? directUrl;
  final BorderRadius? borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final custom = AppCustomColors.of(context);
    final soft = custom.surfaceSoft ?? colors.secondary;

    final placeholder = Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: soft, borderRadius: borderRadius),
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: colors.primary),
      ),
    );

    final errorWidget = Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: soft, borderRadius: borderRadius),
      child: Icon(Icons.broken_image_outlined, color: colors.onSurfaceVariant),
    );

    final border = borderRadius ?? BorderRadius.zero;
    final trimmedDirect = directUrl?.trim();
    if (trimmedDirect != null && trimmedDirect.isNotEmpty) {
      return ClipRRect(
        borderRadius: border,
        child: CachedNetworkImage(
          imageUrl: trimmedDirect,
          fit: fit,
          placeholder: (_, __) => placeholder,
          errorWidget: (_, __, ___) => errorWidget,
        ),
      );
    }

    final future = imageFuture;
    if (future == null) {
      return ClipRRect(borderRadius: border, child: errorWidget);
    }

    return ClipRRect(
      borderRadius: border,
      child: FutureBuilder<String>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return errorWidget;
          }

          final imageUrl = snapshot.data;

          if (snapshot.connectionState != ConnectionState.done) {
            return placeholder;
          }

          if (imageUrl == null || imageUrl.isEmpty) {
            return errorWidget;
          }

          return CachedNetworkImage(
            imageUrl: imageUrl,
            fit: fit,
            placeholder: (_, __) => placeholder,
            errorWidget: (_, __, ___) => errorWidget,
          );
        },
      ),
    );
  }
}
