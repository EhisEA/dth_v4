import "package:dth_v4/data/models/model.dart";

abstract class TimelineRepo {
  Future<List<TimelinePost>> fetchTimeline();
  Future<List<TimelineReel>> fetchTimelineReels();
}
