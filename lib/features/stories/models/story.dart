import "package:flutter/foundation.dart";

@immutable
class Story {
  const Story({required this.imageUrl, required this.label});
  final String imageUrl;
  final String label;
}
