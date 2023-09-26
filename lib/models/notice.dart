
class Notice {
  final String writer;
  final String title;
  final String content;
  late final String timestamp;

  Notice(this.writer, this.title, this.content, createOn) {
    timestamp = createOn.replaceAll("T", " ");
  }
}