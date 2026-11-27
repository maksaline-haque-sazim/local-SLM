/// Speed figures for one finished reply.
class GenerationStatsEntity {
  const GenerationStatsEntity({
    required this.completionTokens,
    required this.duration,
  });

  final int completionTokens;
  final Duration duration;

  /// Generated tokens per minute, or 0 when the duration is unknown.
  double get tokensPerMinute {
    final seconds = duration.inMicroseconds / Duration.microsecondsPerSecond;
    return seconds <= 0 ? 0 : completionTokens / seconds * 60;
  }

  /// Duration as `3.4 s`, or `1 m 05 s` for long replies.
  String get durationLabel {
    final seconds = duration.inMicroseconds / Duration.microsecondsPerSecond;
    if (seconds < 60) {
      return '${seconds.toStringAsFixed(1)} s';
    }
    final minutes = seconds ~/ 60;
    final rest = (seconds - minutes * 60).round().toString().padLeft(2, '0');
    return '$minutes m $rest s';
  }
}
