import "package:dth_v4/core/core.dart";
import "package:dth_v4/widgets/text/app_text.dart";
import "package:dth_v4/widgets/text/textstyles.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:flutter_utils/flutter_utils.dart";

class AppDropdownOption<T> {
  const AppDropdownOption({required this.value, required this.label});

  final T value;
  final String label;
}

List<AppDropdownOption<T>> _filterDropdownOptions<T>(
  List<AppDropdownOption<T>> options,
  String query,
) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return options;
  return options
      .where(
        (o) =>
            o.label.toLowerCase().contains(q) ||
            o.value.toString().toLowerCase().contains(q),
      )
      .toList();
}

/// Select field that matches [AppTextField] chrome; opens a bottom sheet picker.
///
/// Set [search] to `true` to show a search field and filter options; `false` uses a simple list.
class AppDropdownFormField<T> extends StatefulWidget {
  const AppDropdownFormField({
    super.key,
    required this.title,
    required this.hint,
    required this.options,
    this.initialValue,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.enabled = true,
    this.onDisabledTap,
    this.search = false,
    this.interactionError,
  });

  final String title;
  final String hint;
  final List<AppDropdownOption<T>> options;
  final T? initialValue;
  final FormFieldValidator<T>? validator;
  final FormFieldSetter<T>? onSaved;
  final ValueChanged<T?>? onChanged;
  final AutovalidateMode autovalidateMode;
  final bool enabled;

  /// Called when the field is disabled but the user still taps it.
  final VoidCallback? onDisabledTap;

  /// When `true`, the sheet includes search and filters by label / value string.
  final bool search;

  /// Shown like validation error (red border + caption). Use for prerequisite hints
  /// when the field is disabled; clear when the user fixes the dependency.
  final String? interactionError;

  @override
  State<AppDropdownFormField<T>> createState() =>
      _AppDropdownFormFieldState<T>();
}

class _AppDropdownFormFieldState<T> extends State<AppDropdownFormField<T>> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  String _labelFor(T? value, FormFieldState<T> field) {
    if (value == null) return "";
    for (final o in widget.options) {
      if (o.value == value) return o.label;
    }
    return value.toString();
  }

  Future<void> _openSheet(FormFieldState<T> field) async {
    if (!widget.enabled) return;
    FocusScope.of(context).requestFocus(_focusNode);
    final T? selected = widget.search
        ? await _openSearchableSheet()
        : await _openSimpleSheet();
    if (!mounted || selected == null) return;
    field.didChange(selected);
    widget.onChanged?.call(selected);
    field.validate();
  }

  Future<T?> _openSimpleSheet() {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(ctx).height * 0.55,
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: AppText.medium(
                    widget.title,
                    fontSize: 16,
                    color: AppColors.black,
                  ),
                ),
                for (final o in widget.options)
                  ListTile(
                    title: AppText.regular(
                      o.label,
                      fontSize: 15,
                      color: AppColors.black,
                    ),
                    onTap: () => Navigator.of(ctx).pop(o.value),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<T?> _openSearchableSheet() {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) => _SearchableDropdownSheet<T>(
        title: widget.title,
        options: widget.options,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      initialValue: widget.initialValue,
      onSaved: widget.onSaved,
      autovalidateMode: widget.autovalidateMode,
      validator:
          widget.validator ??
          (v) {
            if (v == null) return "This field is required";
            if (v is String && v.isEmpty) return "This field is required";
            return null;
          },
      builder: (field) {
        final interaction = widget.interactionError?.trim();
        final String? displayError =
            (interaction != null && interaction.isNotEmpty)
            ? interaction
            : field.errorText;
        final hasError = displayError != null;
        final display = _labelFor(field.value, field);
        final borderColor = hasError
            ? Colors.red
            : (_focusNode.hasFocus
                  ? AppColors.primary
                  : const Color(0xffEDEDED));

        final surface = Focus(
          focusNode: _focusNode,
          canRequestFocus: widget.enabled,
          skipTraversal: !widget.enabled,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.white,
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.regular(
                  widget.title,
                  fontSize: 10,
                  letterSpacing: -0.2,
                  color: AppColors.black,
                ),
                Gap.h8,
                Row(
                  children: [
                    Expanded(
                      child: AppText.regular(
                        display.isEmpty ? widget.hint : display,
                        fontSize: 14,
                        letterSpacing: -0.2,
                        color: display.isEmpty
                            ? const Color(0xffB5B5B5)
                            : AppColors.black,
                      ),
                    ),
                    SvgPicture.asset(
                      SvgAssets.downArrow,
                      height: 18,
                      width: 18,
                      colorFilter: ColorFilter.mode(
                        AppColors.tint15,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!widget.enabled)
              Listener(
                behavior: HitTestBehavior.translucent,
                onPointerDown: (_) => widget.onDisabledTap?.call(),
                child: surface,
              )
            else
              GestureDetector(
                onTap: () => _openSheet(field),
                behavior: HitTestBehavior.opaque,
                child: surface,
              ),
            if (displayError != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap.w6,
                    Expanded(
                      child: AppText.regular(
                        displayError.isEmpty
                            ? displayError
                            : displayError.capitalizeFirstLetter(),
                        fontSize: 12,
                        color: Colors.red,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SearchableDropdownSheet<T> extends StatefulWidget {
  const _SearchableDropdownSheet({
    required this.title,
    required this.options,
  });

  final String title;
  final List<AppDropdownOption<T>> options;

  @override
  State<_SearchableDropdownSheet<T>> createState() =>
      _SearchableDropdownSheetState<T>();
}

class _SearchableDropdownSheetState<T> extends State<_SearchableDropdownSheet<T>> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.55,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              final filtered = _filterDropdownOptions<T>(
                widget.options,
                _searchController.text,
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: AppText.medium(
                      widget.title,
                      fontSize: 16,
                      color: AppColors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: TextField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      style: AppTextStyle.regular.copyWith(
                        color: AppColors.black,
                        fontSize: 14,
                        letterSpacing: -0.2,
                      ),
                      onChanged: (_) => setModalState(() {}),
                      decoration: InputDecoration(
                        hintText: "Search list",
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 40,
                          minHeight: 20,
                          maxHeight: 20,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: SvgPicture.asset(
                            SvgAssets.search,
                            height: 12,
                            width: 12,
                            colorFilter: ColorFilter.mode(
                              Color(0xffB5B5B5),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        isDense: true,
                        filled: true,
                        hintStyle: AppTextStyle.regular.copyWith(
                          color: const Color(0xffB5B5B5),
                          fontSize: 14,
                          letterSpacing: -0.2,
                        ),
                        fillColor: const Color(0xffF8F8F8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xffEDEDED),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xffEDEDED),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.primary,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: AppText.regular(
                              "No matches",
                              fontSize: 14,
                              color: AppColors.blackTint20,
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(bottom: 8),
                            itemCount: filtered.length,
                            itemBuilder: (context, i) {
                              final o = filtered[i];
                              return ListTile(
                                title: AppText.regular(
                                  o.label,
                                  fontSize: 15,
                                  color: AppColors.black,
                                ),
                                onTap: () =>
                                    Navigator.of(context).pop(o.value),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
