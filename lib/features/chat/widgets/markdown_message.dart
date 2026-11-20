import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/utils/theme/app_typography.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

/// Renders model output as markdown (bold, lists, code and so on) using the
/// app's typography.
class MarkdownMessage extends StatelessWidget {
  const MarkdownMessage({super.key, required this.data, required this.color});

  final String data;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    final body = AppTypography.getParagraphRegular(isArabic)
        .copyWith(color: color);
    final codeBackground = color.withValues(alpha: 0.15);

    TextStyle heading(TextStyle style) => style.copyWith(color: color);

    final styleSheet = MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
      p: body,
      a: body.copyWith(decoration: TextDecoration.underline),
      strong: body.copyWith(fontWeight: FontWeight.w700),
      em: body.copyWith(fontStyle: FontStyle.italic),
      del: body.copyWith(decoration: TextDecoration.lineThrough),
      h1: heading(AppTypography.getHeading3(isArabic)),
      h2: heading(AppTypography.getHeading4(isArabic)),
      h3: heading(AppTypography.getParagraphLargeBold(isArabic)),
      h4: heading(AppTypography.getParagraphBold(isArabic)),
      h5: heading(AppTypography.getParagraphBold(isArabic)),
      h6: heading(AppTypography.getParagraphBold(isArabic)),
      listBullet: body,
      blockquote: body,
      code: AppTypography.getMono(
        isArabic,
      ).copyWith(color: color, fontSize: 14, backgroundColor: codeBackground),
      codeblockDecoration: BoxDecoration(
        color: codeBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      blockquoteDecoration: BoxDecoration(
        border: BorderDirectional(
          start: BorderSide(color: color.withValues(alpha: 0.5), width: 3),
        ),
      ),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(top: BorderSide(color: color.withValues(alpha: 0.4))),
      ),
    );

    return MarkdownBody(data: data, selectable: true, styleSheet: styleSheet);
  }
}
