import "package:dth_v4/features/stories/models/mock_comment.dart";

const storyTitle = "An Electrifying Performance by Publicity";
const storyAuthor = "DE9JASPIRIT";
const storyWith = "Contestant Publicity";
const storyTime = "4 Hours ago";
const storyCaption =
    "The energy on stage was unreal tonight. Shout out to everyone who pulled this together — you already know we are taking this all the way...";
const storyLikes = 16000;
const storyDislikes = 23;
const storyShares = 24;
const storyCommentCount = 315;

final List<MockComment> storyMockComments = mockComments;

String formatStoryCount(int n) {
  if (n >= 1000000) return "${(n / 1000000).toStringAsFixed(1)}M";
  if (n >= 1000) return "${(n / 1000).toStringAsFixed(0)}K";
  return "$n";
}


String storyCaptionPreview({int maxChars = 96}) {
  if (storyCaption.length <= maxChars) return storyCaption;
  return "${storyCaption.substring(0, maxChars).trimRight()}...";
}
