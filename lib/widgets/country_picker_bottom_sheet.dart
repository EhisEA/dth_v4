import "package:dth_v4/core/core.dart";
import "package:dth_v4/data/data.dart";
import "package:dth_v4/widgets/app_button.dart";
import "package:dth_v4/widgets/app_text_field.dart";
import "package:dth_v4/widgets/country_flag_thumbnail.dart";
import "package:dth_v4/widgets/text/app_text.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_utils/flutter_utils.dart";

Future<void> showCountryPickerBottomSheet(
  BuildContext context, {
  required DthCountry? initialCountry,
  required void Function(DthCountry country) onSelected,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return _CountryPickerBody(
        initialCountry: initialCountry,
        onSelected: onSelected,
      );
    },
  );
}

class _CountryPickerBody extends ConsumerStatefulWidget {
  const _CountryPickerBody({
    required this.initialCountry,
    required this.onSelected,
  });

  final DthCountry? initialCountry;
  final void Function(DthCountry country) onSelected;

  @override
  ConsumerState<_CountryPickerBody> createState() => _CountryPickerBodyState();
}

class _CountryPickerBodyState extends ConsumerState<_CountryPickerBody> {
  final TextEditingController _query = TextEditingController();
  late final FocusNode _searchFocus = FocusNode();

  @override
  void dispose() {
    _query.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  List<DthCountry> _filter(List<DthCountry> all, String q) {
    final s = q.trim().toLowerCase();
    if (s.isEmpty) return all;
    return all.where((c) {
      return c.isoCode.toLowerCase().contains(s) ||
          c.dialCode.toLowerCase().contains(s);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(countriesListProvider);
    final maxH = MediaQuery.sizeOf(context).height * 0.62;

    return SafeArea(
      child: SizedBox(
        height: maxH,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.tint5,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              Gap.h12,
              AppText.medium(
                "Select country",
                fontSize: 18,
                color: AppColors.black,
              ),
              Gap.h12,
              AppTextField(
                title: "Search",
                hint: "ISO or dial code",
                controller: _query,
                focusNode: _searchFocus,
                onChanged: (_) => setState(() {}),
                textInputAction: TextInputAction.search,
              ),
              Gap.h8,
              Expanded(
                child: async.when(
                  data: (list) {
                    if (list.isEmpty) {
                      return Center(
                        child: AppText.regular(
                          "No countries available",
                          color: AppColors.blackTint20,
                        ),
                      );
                    }
                    final filtered = _filter(list, _query.text);
                    return ListView.separated(
                      itemCount: filtered.length,
                      padding: EdgeInsets.zero,
                      separatorBuilder: (_, __) =>
                          Container(height: 1, color: AppColors.greyTint35),
                      itemBuilder: (context, i) {
                        final c = filtered[i];
                        final selected =
                            widget.initialCountry?.isoCode == c.isoCode;
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CountryFlagThumbnail(
                            flagDataUri: c.flagDataUri,
                            size: 20,
                          ),
                          title: AppText.regular(
                            c.isoCode,
                            fontSize: 14,
                            color: AppColors.black,
                          ),
                          subtitle: AppText.regular(
                            c.dialCode,
                            fontSize: 12,
                            color: AppColors.blackTint20,
                          ),
                          trailing: selected
                              ? Icon(Icons.check, color: AppColors.primary)
                              : null,
                          onTap: () {
                            widget.onSelected(c);
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText.regular(
                          e is ApiFailure
                              ? e.message
                              : "Could not load countries",
                          color: AppColors.redTint35,
                        ),
                        Gap.h12,
                        AppButton.primary(
                          text: "Retry",
                          press: () => ref.invalidate(countriesListProvider),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
