class MockComment {
  const MockComment({
    required this.user,
    required this.time,
    required this.text,
    required this.likes,
    required this.replies,
    required this.shares,
  });

  final String user;
  final String time;
  final String text;
  final int likes;
  final int replies;
  final int shares;
}

final List<MockComment> mockComments = [
  const MockComment(
    user: "Banger Designer",
    time: "2h",
    text: "This is the content we signed up for. Pure fire.",
    likes: 128,
    replies: 4,
    shares: 1,
  ),
  const MockComment(
    user: "StageMom_01",
    time: "3h",
    text: "Voting starts when? Need to rally the group chat.",
    likes: 56,
    replies: 12,
    shares: 0,
  ),
  const MockComment(
    user: "TalentHunt NG",
    time: "5h",
    text: "Production value went up a notch. Respect.",
    likes: 89,
    replies: 2,
    shares: 3,
  ),
];
