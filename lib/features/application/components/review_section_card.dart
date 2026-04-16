import 'package:dth_v4/core/core.dart';
import 'package:dth_v4/widgets/text/textstyles.dart';
import 'package:dth_v4/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_utils/flutter_utils.dart';

/// One field in a [ReviewSectionCard].
/// [forceFullWidth] skips measurement and always uses a full line (e.g. video URLs).
typedef ReviewSectionField = ({
  String label,
  String value,
  bool forceFullWidth,
});

bool _valueNeedsOwnRow(BuildContext context, String value, double halfWidth) {
  if (value.isEmpty) return false;
  final style = AppTextStyle.regular.copyWith(fontSize: 14);
  final scaler = MediaQuery.textScalerOf(context);

  final wrapped = TextPainter(
    text: TextSpan(text: value, style: style),
    textDirection: Directionality.of(context),
    textScaler: scaler,
  )..layout(maxWidth: halfWidth);
  if (wrapped.computeLineMetrics().length > 1) return true;

  final singleLine = TextPainter(
    text: TextSpan(text: value, style: style),
    textDirection: Directionality.of(context),
    textScaler: scaler,
    maxLines: 1,
  )..layout(maxWidth: halfWidth);
  return singleLine.didExceedMaxLines;
}

bool _fieldUsesFullRow(
  BuildContext context,
  ReviewSectionField field,
  double halfWidth,
) {
  if (field.forceFullWidth) return true;
  return _valueNeedsOwnRow(context, field.value, halfWidth);
}

/// Groups fields into runs of one (full or half) or two half-width cells.
List<List<ReviewSectionField>> _chunkFieldsForWrap(
  BuildContext context,
  List<ReviewSectionField> rows,
  double halfWidth,
) {
  final chunks = <List<ReviewSectionField>>[];
  var i = 0;
  while (i < rows.length) {
    final r = rows[i];
    if (_fieldUsesFullRow(context, r, halfWidth)) {
      chunks.add([r]);
      i++;
      continue;
    }
    if (i + 1 < rows.length &&
        !_fieldUsesFullRow(context, rows[i + 1], halfWidth)) {
      chunks.add([rows[i], rows[i + 1]]);
      i += 2;
    } else {
      chunks.add([rows[i]]);
      i++;
    }
  }
  return chunks;
}

Widget _buildSingleFieldChunk(
  BuildContext context,
  ReviewSectionField field,
  double maxW,
  double halfCell,
) {
  final usesFull = _fieldUsesFullRow(context, field, halfCell);
  return SizedBox(
    width: usesFull ? maxW : halfCell,
    child: _ReviewFieldCell(field: field, wide: usesFull),
  );
}

class ReviewSectionCard extends StatelessWidget {
  const ReviewSectionCard({
    super.key,
    required this.title,
    required this.wizardPageIndex,
    required this.rows,
  });

  final String title;
  final int wizardPageIndex;
  final List<ReviewSectionField> rows;

  static const double _spacing = 12;
  static const double _runSpacing = 12;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffEDEDED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AppText.medium(
                  title,
                  fontSize: 14,
                  color: AppColors.tertiary60,
                ),
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  Navigator.of(context).pop(wizardPageIndex);
                },
                child: SvgPicture.asset(SvgAssets.edit),
              ),
            ],
          ),
          Gap.h12,
          LayoutBuilder(
            builder: (context, constraints) {
              final maxW = constraints.maxWidth;
              final halfCell = (maxW - _spacing) / 2;
              final chunks = _chunkFieldsForWrap(context, rows, halfCell);

              return Wrap(
                spacing: _spacing,
                runSpacing: _runSpacing,
                children: [
                  for (final chunk in chunks)
                    if (chunk.length == 1)
                      _buildSingleFieldChunk(context, chunk[0], maxW, halfCell)
                    else ...[
                      SizedBox(
                        width: halfCell,
                        child: _ReviewFieldCell(field: chunk[0], wide: false),
                      ),
                      SizedBox(
                        width: halfCell,
                        child: _ReviewFieldCell(field: chunk[1], wide: false),
                      ),
                    ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ReviewFieldCell extends StatelessWidget {
  const _ReviewFieldCell({required this.field, required this.wide});

  final ReviewSectionField field;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.regular(
          field.label,
          fontSize: 10,
          color: AppColors.tint15,
          maxLines: 2,
        ),
        Gap.h4,
        AppText.regular(
          field.value.isEmpty ? '—' : field.value,
          fontSize: 12,
          color: AppColors.black,
          maxLines: wide ? 12 : 6,
        ),
      ],
    );
  }
}
