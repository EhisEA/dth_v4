class PollOptionData {
  const PollOptionData({
    required this.uid,
    required this.title,
    required this.percentage,
    required this.progress,
    this.showResults = true,
    this.selected = false,
  });

  final String uid;
  final String title;
  final int percentage;
  final double progress;
  final bool showResults;
  final bool selected;
}
