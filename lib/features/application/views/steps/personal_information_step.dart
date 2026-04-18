import "package:dth_v4/core/core.dart";
import "package:dth_v4/data/models/application_process_models.dart";
import "package:dth_v4/data/models/application_wizard_inputs.dart";
import "package:dth_v4/features/application/view_model/application_view_model.dart";
import "package:dth_v4/data/data.dart";
import "package:dth_v4/features/application/data/application_stub_options.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_svg/svg.dart";
import "package:flutter_utils/flutter_utils.dart";
import "package:intl/intl.dart";

class PersonalInformationStep extends ConsumerStatefulWidget {
  const PersonalInformationStep({
    super.key,
    required this.formKey,
    required this.onRegisterPersist,
    required this.applicationProcess,
  });

  final GlobalKey<FormState> formKey;
  final void Function(void Function() persist) onRegisterPersist;
  final ApplicationProcess applicationProcess;

  @override
  ConsumerState<PersonalInformationStep> createState() =>
      _PersonalInformationStepState();
}

class _PersonalInformationStepState
    extends ConsumerState<PersonalInformationStep>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final FocusNode _nameFocus;
  late final FocusNode _emailFocus;
  late final FocusNode _dobFocus;
  late final FocusNode _phoneFocus;
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _dobController;
  late final TextEditingController _phoneController;
  String? _gender;
  DthCountry? _selectedCountry;

  static final _dobFormat = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();
    _nameFocus = FocusNode();
    _emailFocus = FocusNode();
    _dobFocus = FocusNode();
    _phoneFocus = FocusNode();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _dobController = TextEditingController();
    _phoneController = TextEditingController();
    widget.onRegisterPersist(_persist);
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    _emailFocus.dispose();
    _dobFocus.dispose();
    _phoneFocus.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _persist() {
    final national = _phoneController.text.trim();
    final phone = composeInternationalPhone(
      country: _selectedCountry,
      nationalInput: national,
    );
    ref
        .read(applicationViewModelProvider)
        .setPersonal(
          PersonalInformationInput(
            fullName: _nameController.text.trim(),
            email: _emailController.text.trim(),
            dateOfBirthDisplay: _dobController.text.trim(),
            gender: _gender ?? '',
            phoneNumber: phone,
          ),
        );
  }

  Future<void> _pickDob() async {
    FocusScope.of(context).unfocus();
    final now = DateTime.now();
    final initial =
        _tryParseDob() ?? DateTime(now.year - 20, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1940),
      lastDate: DateTime(now.year - 16, now.month, now.day),
    );
    if (picked != null && mounted) {
      setState(() {
        _dobController.text = _dobFormat.format(picked);
      });
    }
  }

  DateTime? _tryParseDob() {
    try {
      return _dobFormat.parseStrict(_dobController.text.trim());
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ref.listen<AsyncValue<List<DthCountry>>>(countriesListProvider, (_, next) {
      next.whenData((list) {
        if (!mounted || _selectedCountry != null) return;
        DthCountry? pick;
        for (final c in list) {
          if (c.isoCode == 'NG') {
            pick = c;
            break;
          }
        }
        pick ??= list.isNotEmpty ? list.first : null;
        if (pick != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _selectedCountry = pick);
          });
        }
      });
    });
    final genderOptions = [
      for (final gender in widget.applicationProcess.genderOptions)
        (value: gender.label, label: gender.label),
    ];
    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          AppText.medium(
            'Personal Information',
            fontSize: 24,
            letterSpacing: -0.4,
            color: AppColors.tertiary60,
          ),
          Gap.h8,
          AppText.regular(
            'Provide your basic details to complete your profile.',
            fontSize: 14,
            height: 1.4,
            color: AppColors.blackTint20,
          ),
          Gap.h24,
          AppTextField(
            title: 'Full Name',
            hint: 'Enter your full name',
            controller: _nameController,
            focusNode: _nameFocus,
            titleColor: AppColors.black,
            validator: Validator.fullname,
            textInputAction: TextInputAction.next,
            formatter: [FilteringTextInputFormatter.singleLineFormatter],
          ),
          Gap.h12,
          AppTextField(
            title: 'Email Address',
            hint: 'example@email.com',
            controller: _emailController,
            focusNode: _emailFocus,
            titleColor: AppColors.black,
            validator: Validator.email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            formatter: [FilteringTextInputFormatter.singleLineFormatter],
          ),
          Gap.h16,
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  title: 'Date of Birth',
                  hint: 'DD-MM-YYYY',
                  controller: _dobController,
                  focusNode: _dobFocus,
                  readOnly: true,
                  enabled: false,
                  titleColor: AppColors.black,
                  validator: Validator.emptyField,
                  textInputAction: TextInputAction.next,
                  suffixIcon: SvgPicture.asset(SvgAssets.calendarEdit),
                  onTap: _pickDob,
                ),
              ),
              Gap.w12,
              Expanded(
                child: AppDropdownFormField<String>(
                  title: 'Gender',
                  hint: 'Select gender',
                  options: genderOptions,
                  onChanged: (v) => setState(() => _gender = v),
                ),
              ),
            ],
          ),

          Gap.h16,
          PhoneNumberCountryInput(
            title: 'Phone Number',
            hint: 'Enter phone number',
            controller: _phoneController,
            focusNode: _phoneFocus,
            displayCountry: _selectedCountry,
            textInputAction: TextInputAction.done,
            onCountryTap: () {
              showCountryPickerBottomSheet(
                context,
                initialCountry: _selectedCountry,
                onSelected: (c) => setState(() => _selectedCountry = c),
              );
            },
            onSubmitted: (_) => FocusScope.of(context).unfocus(),
            validator: (v) => validateNationalPhone(v, _selectedCountry),
          ),
          Gap.h32,
        ],
      ),
    );
  }
}
