import "package:dth_v4/core/core.dart";
import "package:dth_v4/features/application/data/application_stub_options.dart";
import "package:dth_v4/features/application/view_model/application_wizard_notifier.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_utils/flutter_utils.dart";

class TalentShowcaseStep extends ConsumerStatefulWidget {
  const TalentShowcaseStep({
    super.key,
    required this.formKey,
    required this.onRegisterPersist,
  });

  final GlobalKey<FormState> formKey;
  final void Function(void Function() persist) onRegisterPersist;

  @override
  ConsumerState<TalentShowcaseStep> createState() => _TalentShowcaseStepState();
}

class _TalentShowcaseStepState extends ConsumerState<TalentShowcaseStep>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final FocusNode _stageFocus;
  late final FocusNode _descriptionFocus;
  late final FocusNode _participantsFocus;
  late final TextEditingController _stageController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _participantsController;

  String? _category;
  String? _presentationMode;
  String? _crewSize;

  bool get _isGroup =>
      (_presentationMode ?? '').toLowerCase() ==
      ApplicationStubOptions.presentationModes[1].toLowerCase();

  @override
  void initState() {
    super.initState();
    _stageFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _participantsFocus = FocusNode();
    _stageController = TextEditingController();
    _descriptionController = TextEditingController();
    _participantsController = TextEditingController();
    widget.onRegisterPersist(_persist);
  }

  @override
  void dispose() {
    _stageFocus.dispose();
    _descriptionFocus.dispose();
    _participantsFocus.dispose();
    _stageController.dispose();
    _descriptionController.dispose();
    _participantsController.dispose();
    super.dispose();
  }

  void _persist() {
    final mode = _presentationMode ?? '';
    ref
        .read(applicationWizardProvider.notifier)
        .setTalentShowcase(
          stageName: _stageController.text.trim(),
          talentCategory: _category ?? '',
          talentDescription: _descriptionController.text.trim(),
          presentationMode: mode,
          crewSize: _isGroup ? (_crewSize ?? '') : '',
          participantNames: _isGroup ? _participantsController.text.trim() : '',
        );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final categoryOptions = [
      for (final c in ApplicationStubOptions.talentCategories)
        (value: c, label: c),
    ];
    final modeOptions = [
      for (final m in ApplicationStubOptions.presentationModes)
        (value: m, label: m),
    ];
    final crewOptions = [
      for (final s in ApplicationStubOptions.crewSizes) (value: s, label: s),
    ];

    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          AppText.medium(
            'Talent Showcase',
            fontSize: 24,
            letterSpacing: -0.4,
            color: AppColors.tertiary60,
          ),
          Gap.h8,
          AppText.regular(
            'Share details about your talent and whether you perform individually or as a group.',
            fontSize: 14,
            height: 1.4,
            color: AppColors.blackTint20,
          ),
          Gap.h24,
          AppTextField(
            title: 'Stage Name',
            hint: 'Enter your stage name',
            controller: _stageController,
            focusNode: _stageFocus,
            titleColor: AppColors.black,
            validator: (v) =>
                v.trim().isEmpty ? 'This field is required' : null,
            textInputAction: TextInputAction.next,
            formatter: [FilteringTextInputFormatter.singleLineFormatter],
          ),
          Gap.h16,
          AppDropdownFormField<String>(
            title: 'Talent Category',
            hint: 'Select category',
            options: categoryOptions,
            onChanged: (v) => setState(() => _category = v),
          ),
          Gap.h16,
          AppTextField(
            title: 'Description',
            hint: 'Briefly tell us more about your talent',
            controller: _descriptionController,
            focusNode: _descriptionFocus,
            titleColor: AppColors.black,
            validator: (v) =>
                v.trim().isEmpty ? 'This field is required' : null,
            maxLines: 4,
            minLines: 3,
            textInputAction: TextInputAction.next,
          ),
          Gap.h16,
          AppDropdownFormField<String>(
            title: 'Mode of Presentation',
            hint: 'Group or Individual',
            options: modeOptions,
            onChanged: (v) {
              setState(() {
                _presentationMode = v;
                if (!_isGroup) {
                  _crewSize = null;
                  _participantsController.clear();
                }
              });
            },
          ),
          if (_isGroup) ...[
            Gap.h16,
            AppDropdownFormField<String>(
              key: const ValueKey('crew_size'),
              title: 'Size of Crew',
              hint: 'Enter size of crew?',
              options: crewOptions,
              onChanged: (v) => setState(() => _crewSize = v),
              validator: (v) {
                if (!_isGroup) return null;
                if (v == null || v.isEmpty) return 'This field is required';
                return null;
              },
            ),
            Gap.h16,
            AppTextField(
              title: 'Name of Participants',
              hint: 'Enter the full name of your crew members',
              controller: _participantsController,
              focusNode: _participantsFocus,
              titleColor: AppColors.black,
              validator: Validator.emptyField,
              maxLines: 4,
              minLines: 2,
              textInputAction: TextInputAction.done,
            ),
          ],
          Gap.h32,
        ],
      ),
    );
  }
}
