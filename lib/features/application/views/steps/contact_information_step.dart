import "package:dth_v4/core/core.dart";
import "package:dth_v4/data/models/application_process_models.dart";
import "package:dth_v4/data/models/application_wizard_inputs.dart";
import "package:dth_v4/features/application/view_model/application_view_model.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_utils/flutter_utils.dart";

class ContactInformationStep extends ConsumerStatefulWidget {
  const ContactInformationStep({
    super.key,
    required this.formKey,
    required this.onRegisterPersist,
    required this.applicationProcess,
  });

  final GlobalKey<FormState> formKey;
  final void Function(void Function() persist) onRegisterPersist;
  final ApplicationProcess applicationProcess;

  @override
  ConsumerState<ContactInformationStep> createState() =>
      _ContactInformationStepState();
}

class _ContactInformationStepState extends ConsumerState<ContactInformationStep>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final FocusNode _addressFocus;
  late final TextEditingController _addressController;

  String? _stateOfResidence;
  String? _cityOfResidence;
  String? _stateOfOrigin;
  String? _lga;
  String? _nearestCampus;

  @override
  void initState() {
    super.initState();
    _addressFocus = FocusNode();
    _addressController = TextEditingController();
    widget.onRegisterPersist(_persist);
  }

  @override
  void dispose() {
    _addressFocus.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _persist() {
    ref
        .read(applicationViewModelProvider)
        .setContact(
          ContactInformationInput(
            residentialAddress: _addressController.text.trim(),
            stateOfResidence: _stateOfResidence ?? '',
            cityOfResidence: _cityOfResidence ?? '',
            stateOfOrigin: _stateOfOrigin ?? '',
            lga: _lga ?? '',
            nearestCampus: _nearestCampus ?? '',
          ),
        );
  }

  List<AppDropdownOption<String>> _stateOptions() {
    return [
      for (final location in widget.applicationProcess.locations)
        (value: location.state, label: location.state),
    ];
  }

  /// City/town uses LGAs for the selected state of residence (API has no separate cities list).
  List<AppDropdownOption<String>> _cityOptions() {
    if (_stateOfResidence == null) return [];
    final location = widget.applicationProcess.locationForState(_stateOfResidence!);
    if (location == null) return [];
    return [for (final c in location.lgas) (value: c, label: c)];
  }

  List<AppDropdownOption<String>> _lgaOptions() {
    if (_stateOfOrigin == null) return [];
    final location = widget.applicationProcess.locationForState(_stateOfOrigin!);
    if (location == null) return [];
    return [for (final l in location.lgas) (value: l, label: l)];
  }

  List<AppDropdownOption<String>> _campusOptions() {
    return [
      for (final location in widget.applicationProcess.locations)
        (value: location.state, label: location.state),
    ];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final cities = _cityOptions();
    final lgas = _lgaOptions();

    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          AppText.medium(
            'Contact Information',
            fontSize: 24,
            letterSpacing: -0.4,
            color: AppColors.tertiary60,
          ),
          Gap.h8,
          AppText.regular(
            'Provide your contact details so we can reach you with important updates.',
            fontSize: 14,
            height: 1.4,
            color: AppColors.blackTint20,
          ),
          Gap.h24,
          AppTextField(
            title: 'Residential Address',
            hint: 'Enter your address',
            controller: _addressController,
            titleColor: AppColors.black,
            focusNode: _addressFocus,
            validator: Validator.emptyField,
            textInputAction: TextInputAction.next,
            maxLines: 3,
            minLines: 1,
          ),
          Gap.h16,
          AppDropdownFormField<String>(
            title: 'State of Residence',
            hint: 'Select state of residence',
            options: _stateOptions(),
            onChanged: (v) {
              setState(() {
                _stateOfResidence = v;
                _cityOfResidence = null;
              });
            },
          ),
          Gap.h16,
          AppDropdownFormField<String>(
            key: ValueKey<String?>('city_${_stateOfResidence ?? 'none'}'),
            title: 'City/Town',
            hint: _stateOfResidence == null
                ? 'Select state of residence first'
                : 'Select city of residence',
            options: cities,
            enabled: _stateOfResidence != null && cities.isNotEmpty,
            onChanged: (v) => setState(() => _cityOfResidence = v),
            validator: (v) {
              if (_stateOfResidence == null) return null;
              if (cities.isEmpty) return null;
              if (v == null || v.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
          ),
          Gap.h16,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppDropdownFormField<String>(
                  title: 'State of Origin',
                  hint: 'Select state',
                  options: _stateOptions(),
                  onChanged: (v) {
                    setState(() {
                      _stateOfOrigin = v;
                      _lga = null;
                    });
                  },
                ),
              ),
              Gap.w12,
              Expanded(
                child: AppDropdownFormField<String>(
                  key: ValueKey<String?>('lga_${_stateOfOrigin ?? 'none'}'),
                  title: 'LGA',
                  hint: _stateOfOrigin == null
                      ? 'Select state first'
                      : 'Select LGA',
                  options: lgas,
                  enabled: _stateOfOrigin != null && lgas.isNotEmpty,
                  onChanged: (v) => setState(() => _lga = v),
                  validator: (v) {
                    if (_stateOfOrigin == null) return null;
                    if (lgas.isEmpty) return null;
                    if (v == null || v.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          Gap.h16,
          AppDropdownFormField<String>(
            title: 'Nearest Campus',
            hint: 'Select the campus nearest to you.',
            options: _campusOptions(),
            onChanged: (v) => setState(() => _nearestCampus = v),
          ),
          Gap.h32,
        ],
      ),
    );
  }
}
