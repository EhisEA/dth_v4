import "dart:convert";
import "dart:typed_data";

import "package:dth_v4/core/core.dart";
import "package:flutter/material.dart";

Uint8List? decodeDataImageFlag(String? dataUri) {
  if (dataUri == null || dataUri.isEmpty) return null;
  if (!dataUri.startsWith("data:")) return null;
  final comma = dataUri.indexOf(",");
  if (comma < 0 || comma + 1 >= dataUri.length) return null;
  final payload = dataUri.substring(comma + 1);
  try {
    return base64Decode(payload);
  } on Object {
    return null;
  }
}

class CountryFlagThumbnail extends StatelessWidget {
  const CountryFlagThumbnail({
    super.key,
    required this.flagDataUri,
    this.size = 16,
  });

  final String flagDataUri;
  final double size;

  @override
  Widget build(BuildContext context) {
    final bytes = decodeDataImageFlag(flagDataUri);

    return SizedBox(
      height: size,
      width: size,
      child: ClipOval(
        child: bytes != null
            ? Image.memory(
                bytes,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              )
            : ColoredBox(color: AppColors.greyTint30),
      ),
    );
  }
}
