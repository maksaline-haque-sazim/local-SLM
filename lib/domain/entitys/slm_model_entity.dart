/// A downloadable small language model in GGUF format.
class SlmModelEntity {
  const SlmModelEntity({
    required this.id,
    required this.name,
    required this.family,
    required this.parameters,
    required this.fileName,
    required this.url,
    required this.sizeBytes,
  });

  /// Stable identifier, also used to pass the model to the chat page.
  final String id;
  final String name;
  final String family;

  /// Human readable parameter count, e.g. `1.7B`.
  final String parameters;

  /// Name of the file the download is stored under.
  final String fileName;
  final String url;

  /// Exact size of the file; used for progress and to verify the download.
  final int sizeBytes;

  String get sizeLabel {
    const megabyte = 1024 * 1024;
    const gigabyte = 1024 * megabyte;
    if (sizeBytes >= gigabyte) {
      return '${(sizeBytes / gigabyte).toStringAsFixed(2)} GB';
    }
    return '${(sizeBytes / megabyte).round()} MB';
  }
}
