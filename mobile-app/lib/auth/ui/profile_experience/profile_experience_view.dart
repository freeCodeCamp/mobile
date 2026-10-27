import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/auth/ui/profile_experience/profile_experience_viewmodel.dart';
import 'package:freecodecamp/auth/ui/widgets/profile_form.dart';

class ProfileExperienceView extends ConsumerStatefulWidget {
  const ProfileExperienceView({super.key, this.experienceId});

  final String? experienceId;

  @override
  ConsumerState<ProfileExperienceView> createState() =>
      _ProfileExperienceViewState();
}

class _ProfileExperienceViewState extends ConsumerState<ProfileExperienceView> {
  final _formKey = GlobalKey<ProfileFormScaffoldState>();
  late final TextEditingController _title;
  late final TextEditingController _company;
  late final TextEditingController _location;
  late final TextEditingController _description;

  @override
  void initState() {
    super.initState();
    final experience = ref
        .read(profileExperienceProvider(widget.experienceId))
        ?.draft;
    _title = TextEditingController(text: experience?.title ?? '');
    _company = TextEditingController(text: experience?.company ?? '');
    _location = TextEditingController(text: experience?.location ?? '');
    _description = TextEditingController(text: experience?.description ?? '');
  }

  @override
  void dispose() {
    _title.dispose();
    _company.dispose();
    _location.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (ref
        .read(profileExperienceProvider(widget.experienceId).notifier)
        .save()) {
      await _formKey.currentState?.close();
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete experience?'),
        content: const Text(
          'This experience will be removed when you save your profile.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete experience'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    if (ref
        .read(profileExperienceProvider(widget.experienceId).notifier)
        .delete()) {
      await _formKey.currentState?.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(profileExperienceProvider(widget.experienceId));
    final notifier = ref.read(
      profileExperienceProvider(widget.experienceId).notifier,
    );
    final available = form != null && form.available;
    final colors = Theme.of(context).colorScheme;
    return ProfileFormScaffold(
      key: _formKey,
      title: widget.experienceId == null ? 'Add experience' : 'Edit experience',
      isDirty: form?.isDirty ?? false,
      navigationDirty: form?.navigationDirty ?? false,
      saving: form?.saving ?? false,
      onSave: available ? _save : null,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (!available)
            const ProfileFormError(
              message:
                  'This experience is unavailable. Return to Edit profile to try again.',
            )
          else ...[
            if (form.errors['form'] case final message?)
              ProfileFormError(
                message: message,
                onDismiss: notifier.dismissError,
              ),
            ProfileFormField(
              label: 'Job title',
              controller: _title,
              errorText: form.errors['title'],
              enabled: !form.saving,
              onChanged: (value) => notifier.update(title: value),
            ),
            ProfileFormField(
              label: 'Company',
              controller: _company,
              errorText: form.errors['company'],
              enabled: !form.saving,
              onChanged: (value) => notifier.update(company: value),
            ),
            ProfileFormField(
              label: 'Location',
              controller: _location,
              errorText: form.errors['location'],
              enabled: !form.saving,
              onChanged: (value) => notifier.update(location: value),
            ),
            _MonthYearField(
              label: 'Start date',
              value: form.draft.startDate,
              errorText: form.errors['startDate'],
              enabled: !form.saving,
              onChanged: (value) => notifier.update(startDate: value),
            ),
            _MonthYearField(
              label: 'End date',
              value: form.draft.endDate,
              allowEmpty: true,
              helperText: 'Leave empty if you still work here.',
              errorText: form.errors['endDate'],
              enabled: !form.saving,
              onChanged: (value) => notifier.update(endDate: value),
            ),
            ProfileFormField(
              label: 'Description',
              controller: _description,
              maxLength: 500,
              maxLines: 6,
              errorText: form.errors['description'],
              enabled: !form.saving,
              onChanged: (value) => notifier.update(description: value),
            ),
            if (widget.experienceId != null) ...[
              OutlinedButton.icon(
                onPressed: form.saving ? null : _delete,
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.error,
                  backgroundColor: Colors.transparent,
                  side: BorderSide(color: colors.outlineVariant),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Delete experience'),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _MonthYearField extends StatelessWidget {
  const _MonthYearField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.allowEmpty = false,
    this.enabled = true,
    this.errorText,
    this.helperText,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final bool allowEmpty;
  final bool enabled;
  final String? errorText;
  final String? helperText;

  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  String _date(int? month, int? year) {
    if (month == null && year == null) return '';
    final monthText = month?.toString().padLeft(2, '0') ?? '';
    final yearText = year?.toString().padLeft(4, '0') ?? '';
    return '$monthText/$yearText';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final parts = value.split('/');
    final parsedMonth = parts.length == 2 ? int.tryParse(parts[0]) : null;
    final parsedYear = parts.length == 2 ? int.tryParse(parts[1]) : null;
    final month = parsedMonth != null && parsedMonth >= 1 && parsedMonth <= 12
        ? parsedMonth
        : null;
    final year = parsedYear != null && parsedYear >= 1 && parsedYear <= 9999
        ? parsedYear
        : null;
    final years = {
      for (var option = DateTime.now().year; option >= 1900; option--) option,
      ?year,
    }.toList()..sort((a, b) => b.compareTo(a));
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: errorText == null ? colors.outlineVariant : colors.error,
      ),
    );
    final decoration = InputDecoration(
      filled: true,
      fillColor: colors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: BorderSide(
          color: errorText == null ? colors.primary : colors.error,
          width: 2,
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colors.onSurface,
                  ),
                ),
              ),
              if (allowEmpty && value.isNotEmpty)
                TextButton(
                  onPressed: enabled ? () => onChanged('') : null,
                  style: TextButton.styleFrom(
                    minimumSize: const Size(0, 24),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Clear'),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Semantics(
                  label: '$label month',
                  child: DropdownButtonFormField<int>(
                    initialValue: month,
                    hint: const Text('Month'),
                    isExpanded: true,
                    menuMaxHeight: 300,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    decoration: decoration,
                    items: [
                      for (var index = 0; index < _months.length; index++)
                        DropdownMenuItem(
                          value: index + 1,
                          child: Text(
                            _months[index],
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: enabled
                        ? (selection) => onChanged(_date(selection, year))
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Semantics(
                  label: '$label year',
                  child: DropdownButtonFormField<int>(
                    initialValue: year,
                    hint: const Text('YYYY'),
                    isExpanded: true,
                    menuMaxHeight: 300,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    decoration: decoration,
                    items: [
                      for (final option in years)
                        DropdownMenuItem(
                          value: option,
                          child: Text(option.toString().padLeft(4, '0')),
                        ),
                    ],
                    onChanged: enabled
                        ? (selection) => onChanged(_date(month, selection))
                        : null,
                  ),
                ),
              ),
            ],
          ),
          if (errorText != null || helperText != null) ...[
            const SizedBox(height: 6),
            if (errorText != null)
              ProfileFieldError(message: errorText!)
            else
              Text(
                helperText!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
          ],
        ],
      ),
    );
  }
}
