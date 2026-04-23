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
  late final FocusNode _nearestCampusFocus;
  late final TextEditingController _addressController;
  late final TextEditingController _nearestCampusController;

  String? _stateOfResidence;
  String? _cityOfResidence;
  String? _stateOfOrigin;
  String? _lga;

  String? _cityPrerequisiteError;
  String? _lgaPrerequisiteError;

  @override
  void initState() {
    super.initState();
    _addressFocus = FocusNode();
    _nearestCampusFocus = FocusNode();
    _addressController = TextEditingController();
    _nearestCampusController = TextEditingController();
    widget.onRegisterPersist(_persist);
  }

  @override
  void dispose() {
    _addressFocus.dispose();
    _nearestCampusFocus.dispose();
    _addressController.dispose();
    _nearestCampusController.dispose();
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
            nearestCampus: _nearestCampusController.text.trim(),
          ),
        );
  }

  /// All states we got from the server (one menu item per state).
  List<AppDropdownOption<String>> _stateOptions() {
    return [
      for (final location in widget.applicationProcess.locations)
        AppDropdownOption(value: location.state, label: location.state),
    ];
  }

  /// Cities/towns shown here are really LGAs for the state they live in.
  /// The API does not send a separate city list. No items until they pick that state.
  List<AppDropdownOption<String>> _cityOptions() {
    if (_stateOfResidence == null) return [];
    final location = widget.applicationProcess.locationForState(
      _stateOfResidence!,
    );
    if (location == null) return [];
    return [
      for (final lga in location.lgas)
        AppDropdownOption(value: lga, label: lga),
    ];
  }

  /// LGAs for their state of origin (same idea as city list, different state field).
  /// No items until they pick state of origin.
  List<AppDropdownOption<String>> _lgaOptions() {
    if (_stateOfOrigin == null) return [];
    final location = widget.applicationProcess.locationForState(
      _stateOfOrigin!,
    );
    if (location == null) return [];
    return [
      for (final lga in location.lgas)
        AppDropdownOption(value: lga, label: lga),
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
            search: true,
            options: _stateOptions(),
            onChanged: (v) {
              setState(() {
                _stateOfResidence = v;
                _cityOfResidence = null;
                _cityPrerequisiteError = null;
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
            search: true,
            options: cities,
            enabled: _stateOfResidence != null && cities.isNotEmpty,
            interactionError: _cityPrerequisiteError,
            onDisabledTap: () {
              setState(() {
                if (_stateOfResidence == null) {
                  _cityPrerequisiteError =
                      "Select your state of residence before choosing a city or town.";
                } else if (cities.isEmpty) {
                  _cityPrerequisiteError =
                      "No city or town options are available for the selected state. "
                      "Choose a different state of residence.";
                }
              });
            },
            onChanged: (v) => setState(() {
              _cityOfResidence = v;
              _cityPrerequisiteError = null;
            }),
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
                  search: true,
                  options: _stateOptions(),
                  onChanged: (v) {
                    setState(() {
                      _stateOfOrigin = v;
                      _lga = null;
                      _lgaPrerequisiteError = null;
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
                  search: true,
                  options: lgas,
                  enabled: _stateOfOrigin != null && lgas.isNotEmpty,
                  interactionError: _lgaPrerequisiteError,
                  onDisabledTap: () {
                    setState(() {
                      if (_stateOfOrigin == null) {
                        _lgaPrerequisiteError =
                            "Select your state of origin before choosing an LGA.";
                      } else if (lgas.isEmpty) {
                        _lgaPrerequisiteError =
                            "No LGA options are available for the selected state of origin. "
                            "Choose a different state.";
                      }
                    });
                  },
                  onChanged: (v) => setState(() {
                    _lga = v;
                    _lgaPrerequisiteError = null;
                  }),
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
          AppTextField(
            title: 'Nearest Campus',
            hint: 'Enter the campus nearest to you',
            controller: _nearestCampusController,
            focusNode: _nearestCampusFocus,
            titleColor: AppColors.black,
            validator: Validator.emptyField,
            textInputAction: TextInputAction.done,
          ),
          Gap.h32,
        ],
      ),
    );
  }
}
