import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/parser.dart' show parseFragment;
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/models/challenge_file_model.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/models/curriculum_model.dart';
import 'package:mobile_app_new/learn/services/code_service.dart';
import 'package:mobile_app_new/learn/services/test_runner_service.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/complete_button.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/help_dialog.dart';
import 'package:mobile_app_new/learn/ui/editor_challenge/editor_body.dart';
import 'package:mobile_app_new/learn/ui/editor_challenge/editor_challenge_viewmodel.dart';
import 'package:mobile_app_new/learn/ui/editor_challenge/editor_panels.dart';
import 'package:phone_ide/models/textfield_data.dart';
import 'package:phone_ide/phone_ide.dart';

class EditorChallengeView extends ConsumerStatefulWidget {
  const EditorChallengeView({
    super.key,
    required this.challenge,
    this.block,
    this.selector,
  });

  final Challenge challenge;
  // Daily challenges belong to no block and select a language instead of a file.
  final Block? block;
  final Widget? selector;

  @override
  ConsumerState<EditorChallengeView> createState() =>
      _EditorChallengeViewState();
}

enum _EditorSheet { tests, hint, pass, preview, console }

class _EditorChallengeViewState extends ConsumerState<EditorChallengeView> {
  final _subscriptions = <StreamSubscription<Object>>[];
  final _modifiedFiles = <String>{};
  Editor? _editor;
  TextFieldData? _focused;
  _EditorSheet? _sheet;
  bool _instructionsExpanded = true;
  final _instructionBodyKey = GlobalKey();
  double? _instructionHeight;
  double? _instructionDragHeight;
  bool _hintViewed = false;
  int _editorLoad = 0;
  int _codeEdit = 0;

  EditorChallengeNotifierProvider get _provider =>
      editorChallengeProvider(widget.challenge);

  @override
  void initState() {
    super.initState();
    _loadEditor(ref.read(_provider).file);
  }

  @override
  void didUpdateWidget(EditorChallengeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.challenge != widget.challenge) {
      _sheet = null;
      _hintViewed = false;
      _instructionsExpanded = true;
      _instructionHeight = null;
      _instructionDragHeight = null;
      _modifiedFiles.clear();
      _loadEditor(ref.read(_provider).file);
    }
  }

  @override
  void dispose() {
    _cancelSubscriptions();
    super.dispose();
  }

  void _cancelSubscriptions() {
    for (final subscription in _subscriptions) {
      unawaited(subscription.cancel());
    }
    _subscriptions.clear();
  }

  Future<void> _loadEditor(ChallengeFile file) async {
    final load = ++_editorLoad;
    _cancelSubscriptions();
    setState(() {
      _editor = null;
      _focused = null;
    });
    final challenge = widget.challenge;
    final resetCount = ref.read(_provider).resetCount;
    final contents = await ref
        .read(learnCodeServiceProvider)
        .contents(challenge, file);
    // A newer load may have started while the saved code was being read.
    if (!mounted || load != _editorLoad || challenge != widget.challenge) {
      return;
    }
    final current = ref.read(_provider);
    if (current.file != file || current.resetCount != resetCount) return;

    final region = file.editableRegionBoundaries;
    final editor = Editor(
      key: ValueKey(
        '${LearnCodeService.editorPath(challenge, file)}#$resetCount',
      ),
      defaultLanguage: file.ext.name,
      defaultValue: contents,
      path: LearnCodeService.editorPath(challenge, file),
      options: EditorOptions(
        fontFamily: 'Hack',
        regionOptions: region.isEmpty
            ? null
            : EditorRegionOptions(start: region[0], end: region[1]),
      ),
    );

    _cancelSubscriptions();
    _subscriptions.addAll([
      editor.onTextChange.stream.listen((text) {
        _codeEdit++;
        if (_sheet != null) _showSheet(null, preserveFocus: true);
        _hintViewed = false;
        ref.read(_provider.notifier).codeChanged(file, text);
        final modified = text != file.contents;
        if (modified != _modifiedFiles.contains(file.fileName)) {
          setState(
            () => modified
                ? _modifiedFiles.add(file.fileName)
                : _modifiedFiles.remove(file.fileName),
          );
        }
      }),
      editor.textfieldData.stream.listen((data) => _focused = data),
    ]);
    setState(() {
      contents != file.contents
          ? _modifiedFiles.add(file.fileName)
          : _modifiedFiles.remove(file.fileName);
      _editor = editor;
      _focused = null;
    });
  }

  void _insertSymbol(String symbol) {
    final focused = _focused;
    final editor = _editor;
    if (focused == null || editor == null) return;

    final controller = focused.controller;
    final selection = controller.selection;
    if (!selection.isValid) return;

    final text = symbol == 'Tab' ? '\t' : symbol;
    controller.value = TextEditingValue(
      text: controller.text.replaceRange(selection.start, selection.end, text),
      selection: TextSelection.collapsed(offset: selection.start + text.length),
    );
    editor.textfieldData.add(
      TextFieldData(controller: controller, position: focused.position),
    );
  }

  void _editHistory(Intent intent) {
    final fieldContext = FocusManager.instance.primaryFocus?.context;
    if (fieldContext != null) Actions.maybeInvoke(fieldContext, intent);
  }

  void _showSheet(_EditorSheet? sheet, {bool preserveFocus = false}) {
    if (!preserveFocus) FocusManager.instance.primaryFocus?.unfocus();
    final body = switch (sheet) {
      _EditorSheet.preview => EditorBody.preview,
      _EditorSheet.console => EditorBody.console,
      _EditorSheet.tests ||
      _EditorSheet.pass ||
      _EditorSheet.hint => EditorBody.tests,
      null => EditorBody.editor,
    };
    if (ref.read(_provider).body != body) {
      ref.read(_provider.notifier).showBody(body);
    }
    setState(() {
      _sheet = sheet;
      if (sheet != null) _instructionsExpanded = false;
      if (sheet == _EditorSheet.hint) _hintViewed = true;
    });
  }

  void _retryRunner(String workerType) {
    if (ref.read(learnTestRunnerServerProvider).hasError) {
      ref.invalidate(learnTestRunnerServerProvider);
    } else {
      ref.invalidate(learnTestRunnerServiceProvider(workerType));
    }
  }

  Future<void> _runTests() async {
    final challenge = widget.challenge;
    final edit = _codeEdit;
    final reset = ref.read(_provider).resetCount;
    FocusManager.instance.primaryFocus?.unfocus();
    _showSheet(_EditorSheet.tests);
    try {
      await ref.read(_provider.notifier).runTests();
      if (!mounted ||
          widget.challenge != challenge ||
          edit != _codeEdit ||
          reset != ref.read(_provider).resetCount) {
        return;
      }
      _showSheet(
        ref.read(_provider).passed ? _EditorSheet.pass : _EditorSheet.tests,
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The test runner could not start. Please try again.'),
        ),
      );
    }
  }

  Future<void> _reset() async {
    final challenge = widget.challenge;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset code'),
        content: const Text(
          'Reset your code to the starting code for this step?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted || widget.challenge != challenge) return;
    await ref.read(_provider.notifier).reset();
    if (!mounted || widget.challenge != challenge) return;
    setState(() {
      _sheet = null;
      _instructionsExpanded = true;
      _hintViewed = false;
      _modifiedFiles.clear();
    });
  }

  Future<void> _help() async {
    final code = await ref
        .read(learnCodeServiceProvider)
        .filesMarkdown(widget.challenge);
    if (!mounted) return;
    await showHelpDialog(
      context,
      widget.challenge,
      widget.block?.name ?? 'Daily coding challenge',
      code: code,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      _provider.select((s) => (s.file, s.resetCount)),
      (_, next) => _loadEditor(next.$1),
    );
    final state = ref.watch(_provider);
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    return PopScope(
      canPop: _sheet == null,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _sheet != null) _showSheet(null);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _appBar(keyboard > 0),
        body: Padding(
          padding: EdgeInsets.only(bottom: keyboard),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) => Column(
                      children: [
                        _instructions(
                          math.min(
                            keyboard > 0 ? 140 : 220,
                            constraints.maxHeight * .32,
                          ),
                        ),
                        _fileSelector(state),
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, editorSpace) => Stack(
                              fit: StackFit.expand,
                              children: [
                                _editor ??
                                    const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                if (_sheet != null && keyboard == 0)
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: _panel(state, editorSpace.maxHeight),
                                  ),
                              ],
                            ),
                          ),
                          _instructionHeightLimit(constraints.maxHeight),
                        ),
                      ],
                    ),
                  ),
                ),
                _bottomBar(state, keyboard > 0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar(bool keyboard) {
    final block = widget.block;
    final index =
        block?.challenges.indexWhere((c) => c.id == widget.challenge.id) ?? -1;
    final title = index >= 0
        ? 'Step ${index + 1} of ${block!.challenges.length}'
        : widget.challenge.title;
    final scale = MediaQuery.textScalerOf(context);
    return AppBar(
      leading: IconButton(
        tooltip: 'Back',
        onPressed: () => Navigator.of(context).maybePop(),
        icon: const Icon(Icons.chevron_left_rounded),
      ),
      leadingWidth: 40,
      titleSpacing: 8,
      toolbarHeight: math.max(56, scale.scale(16) + scale.scale(12) + 14),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          if (block != null)
            Text(
              block.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
      actions: [
        if (keyboard)
          TextFieldTapRegion(
            child: ExcludeFocus(
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Undo',
                    onPressed: () => _editHistory(
                      const UndoTextIntent(SelectionChangedCause.keyboard),
                    ),
                    icon: const Icon(Icons.undo_rounded),
                  ),
                  IconButton(
                    tooltip: 'Redo',
                    onPressed: () => _editHistory(
                      const RedoTextIntent(SelectionChangedCause.keyboard),
                    ),
                    icon: const Icon(Icons.redo_rounded),
                  ),
                ],
              ),
            ),
          )
        else ...[
          IconButton(
            tooltip: 'Reset code',
            onPressed:
                ref.watch(_provider.select((state) => state.testsRunning))
                ? null
                : _reset,
            icon: const Icon(Icons.restart_alt_rounded),
          ),
          IconButton(
            tooltip: 'Help',
            onPressed: _help,
            icon: const Icon(Icons.help_outline_rounded),
          ),
        ],
        const SizedBox(width: 4),
      ],
    );
  }

  double _instructionHeightLimit(double availableHeight) {
    final scale = MediaQuery.textScalerOf(context);
    // Reserve the header, file/language selector and at least 80px of editor.
    final headerHeight = math.max(44, scale.scale(14) * 1.5 + 22);
    final selectorHeight = math.max(44, scale.scale(16) * 1.5 + 22);
    return math.max(
      0,
      math.min(
        availableHeight * .65,
        availableHeight - headerHeight - selectorHeight - 80,
      ),
    );
  }

  void _finishInstructionDrag(double limit) {
    final height = _instructionDragHeight;
    if (height == null) return;
    setState(() {
      _instructionsExpanded = height >= math.min(48, limit) && height > 0;
      if (_instructionsExpanded) _instructionHeight = height;
      _instructionDragHeight = null;
    });
  }

  Widget _instructions(double defaultBodyHeight, double maxBodyHeight) {
    final colors = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final customHeight = _instructionDragHeight ?? _instructionHeight;
    final bodyHeight = (customHeight ?? defaultBodyHeight).clamp(
      0.0,
      maxBodyHeight,
    );
    final summary =
        parseFragment(
          widget.challenge.instructions,
        ).text?.replaceAll(RegExp(r'\s+'), ' ').trim() ??
        '';
    return Material(
      color: Color(dark ? 0xFF29216C : 0xFFF6F6FE),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragStart: (_) {
              _instructionDragHeight = _instructionsExpanded
                  ? _instructionBodyKey.currentContext?.size?.height ??
                        bodyHeight
                  : 0;
            },
            onVerticalDragUpdate: (details) => setState(() {
              _instructionDragHeight =
                  ((_instructionDragHeight ?? 0) + details.delta.dy).clamp(
                    0.0,
                    maxBodyHeight,
                  );
              _instructionsExpanded = _instructionDragHeight! > 0;
            }),
            onVerticalDragEnd: (_) => _finishInstructionDrag(maxBodyHeight),
            onVerticalDragCancel: () => _finishInstructionDrag(maxBodyHeight),
            child: InkWell(
              key: const ValueKey('editor-instructions-toggle'),
              onTap: () => setState(
                () => _instructionsExpanded = !_instructionsExpanded,
              ),
              child: Container(
                constraints: const BoxConstraints(minHeight: 44),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(color: colors.outlineVariant),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.menu_book_outlined,
                      size: 18,
                      color: colors.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _instructionsExpanded || summary.isEmpty
                            ? 'Instructions'
                            : summary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: _instructionsExpanded
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _instructionsExpanded ? 'Hide' : 'Show',
                      style: TextStyle(
                        color: colors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      _instructionsExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: colors.primary,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_instructionsExpanded)
            ConstrainedBox(
              key: _instructionBodyKey,
              constraints: BoxConstraints(
                minHeight: customHeight == null ? 0 : bodyHeight,
                maxHeight: bodyHeight,
              ),
              child: InstructionPanel(
                key: const ValueKey('editor-instructions-body'),
                challenge: widget.challenge,
                block: widget.block,
              ),
            ),
        ],
      ),
    );
  }

  Widget _fileSelector(EditorChallengeState state) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final shadow = theme.colorScheme.shadow;
    return Stack(
      children: [
        widget.selector ?? _fileTabs(state),
        // Paint after the opaque tabs so the instruction panel's shadow is visible.
        if (_instructionsExpanded)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 20,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0, .5, 1],
                    colors: [
                      shadow.withValues(alpha: dark ? .28 : .12),
                      shadow.withValues(alpha: dark ? .08 : .035),
                      shadow.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _fileTabs(EditorChallengeState state) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.outlineVariant)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final file in widget.challenge.challengeFiles)
              Material(
                color: state.file == file
                    ? colors.surface
                    : Theme.of(context).scaffoldBackgroundColor,
                child: InkWell(
                  key: ValueKey('editor-file-${file.fileName}'),
                  onTap: () {
                    _showSheet(null);
                    ref.read(_provider.notifier).selectFile(file);
                  },
                  child: Semantics(
                    selected: state.file == file,
                    label: _modifiedFiles.contains(file.fileName)
                        ? '${file.fileName}, modified'
                        : file.fileName,
                    excludeSemantics: true,
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 44),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: state.file == file
                                ? colors.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                          right: BorderSide(color: colors.outlineVariant),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: switch (file.ext) {
                                Ext.css => Color(
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? 0xFF8EC5FF
                                      : 0xFF1F6FD1,
                                ),
                                Ext.js => Color(
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? 0xFFFFD978
                                      : 0xFF5D4900,
                                ),
                                _ => colors.primary,
                              },
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 7),
                          Text(
                            file.fileName,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: state.file == file
                                  ? colors.onSurface
                                  : colors.onSurfaceVariant,
                            ),
                          ),
                          if (_modifiedFiles.contains(file.fileName)) ...[
                            const SizedBox(width: 7),
                            Icon(Icons.circle, size: 6, color: colors.primary),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _panel(EditorChallengeState state, double availableHeight) {
    final sheet = _sheet!;
    final colors = Theme.of(context).colorScheme;
    final scale = MediaQuery.textScalerOf(context).scale(1);
    final desiredHeight = switch (sheet) {
      _EditorSheet.console => 280.0,
      _EditorSheet.preview => 360.0,
      _EditorSheet.hint => 300.0,
      _EditorSheet.pass => 430.0,
      _EditorSheet.tests => 320.0,
    };
    final title = switch (sheet) {
      _EditorSheet.tests => 'Tests',
      _EditorSheet.hint => 'Socrates says',
      _EditorSheet.pass => 'Tests',
      _EditorSheet.preview => 'Preview',
      _EditorSheet.console => 'Console',
    };
    final results = state.testResults;
    final passing = results?.where((passed) => passed).length ?? 0;
    final resultColor = state.passed
        ? Theme.of(context).extension<FccDesignColors>()!.success
        : colors.error;
    return Container(
      key: ValueKey('editor-sheet-${sheet.name}'),
      height: math.min(
        desiredHeight * math.min(scale, 1.4),
        availableHeight * .88,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: .15),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: sheet == _EditorSheet.pass
          ? PassPanel(
              challenge: widget.challenge,
              block: widget.block,
              onReviewCode: () => _showSheet(null),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 4),
                  child: Row(
                    children: [
                      if (sheet == _EditorSheet.hint) ...[
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: colors.primary,
                          child: Icon(
                            Icons.auto_awesome_outlined,
                            color: colors.onPrimary,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Wrap(
                          spacing: 10,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            if ((sheet == _EditorSheet.tests ||
                                    sheet == _EditorSheet.pass) &&
                                results != null)
                              Text(
                                '$passing of ${widget.challenge.tests.length} passing',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: resultColor,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (sheet == _EditorSheet.preview)
                        IconButton(
                          tooltip: 'Expand preview',
                          onPressed: _expandPreview,
                          icon: const Icon(
                            Icons.open_in_full_rounded,
                            size: 20,
                          ),
                        ),
                      IconButton(
                        tooltip: 'Hide panel',
                        onPressed: () => _showSheet(null),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: colors.outlineVariant),
                Expanded(
                  child: switch (sheet) {
                    _EditorSheet.tests => TestList(
                      tests: widget.challenge.tests,
                      results: results,
                      hint: state.hint,
                      hintViewed: _hintViewed,
                      onHint: () => _showSheet(_EditorSheet.hint),
                    ),
                    _EditorSheet.hint => HintPanel(hint: state.hint),
                    _EditorSheet.pass => PassPanel(
                      challenge: widget.challenge,
                      block: widget.block,
                      onReviewCode: () => _showSheet(null),
                    ),
                    _EditorSheet.preview => Padding(
                      padding: const EdgeInsets.all(12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: ProjectPreview(
                          load: () =>
                              ref.read(_provider.notifier).previewHtml(),
                        ),
                      ),
                    ),
                    _EditorSheet.console => ConsoleOutput(
                      testConsole: state.testConsole,
                      userConsole: state.userConsole,
                    ),
                  },
                ),
              ],
            ),
    );
  }

  void _expandPreview() {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            leading: IconButton(
              tooltip: 'Close preview',
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Preview',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
          ),
          body: SafeArea(
            top: false,
            child: ProjectPreview(
              load: () => ref.read(_provider.notifier).previewHtml(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomBar(EditorChallengeState state, bool keyboard) {
    final colors = Theme.of(context).colorScheme;
    final workerType = workerTypeOf(widget.challenge.challengeType);
    final runner = ref.watch(learnTestRunnerServiceProvider(workerType));
    final failed = runner.hasError && !runner.isLoading;
    final busy = state.testsRunning || (!runner.hasValue && !failed);
    final results = state.testResults;
    final passing = results?.where((passed) => passed).length ?? 0;
    final block = widget.block;
    final index =
        block?.challenges.indexWhere((c) => c.id == widget.challenge.id) ?? -1;
    final nextLabel = block == null
        ? 'Finish challenge'
        : index >= 0 && index < block.challenges.length - 1
        ? 'Next step'
        : 'Finish';
    final actionStyle = FilledButton.styleFrom(
      minimumSize: const Size(96, 48),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      textStyle: const TextStyle(
        fontFamily: 'Lato',
        fontSize: 16,
        fontWeight: FontWeight.w800,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: colors.outlineVariant)),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: keyboard
                ? TextFieldTapRegion(
                    child: ExcludeFocus(
                      child: _SymbolBar(onSymbol: _insertSymbol),
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _ToolButton(
                          label: 'Tests',
                          icon: Icons.checklist_rounded,
                          active:
                              _sheet == _EditorSheet.tests ||
                              _sheet == _EditorSheet.pass,
                          badge: results == null
                              ? null
                              : '$passing/${widget.challenge.tests.length}',
                          badgeColor: state.passed
                              ? Theme.of(
                                  context,
                                ).extension<FccDesignColors>()!.success
                              : colors.error,
                          onPressed: () => _showSheet(
                            _sheet == _EditorSheet.tests ||
                                    _sheet == _EditorSheet.pass
                                ? null
                                : state.passed
                                ? _EditorSheet.pass
                                : _EditorSheet.tests,
                          ),
                        ),
                        if (workerType == 'dom')
                          _ToolButton(
                            label: 'Preview',
                            icon: Icons.visibility_outlined,
                            active: _sheet == _EditorSheet.preview,
                            onPressed: () => _showSheet(
                              _sheet == _EditorSheet.preview
                                  ? null
                                  : _EditorSheet.preview,
                            ),
                          ),
                        _ToolButton(
                          label: 'Console',
                          icon: Icons.terminal_rounded,
                          active: _sheet == _EditorSheet.console,
                          onPressed: () => _showSheet(
                            _sheet == _EditorSheet.console
                                ? null
                                : _EditorSheet.console,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          if (keyboard)
            IconButton(
              tooltip: 'Hide keyboard',
              onPressed: () => FocusManager.instance.primaryFocus?.unfocus(),
              icon: const Icon(Icons.keyboard_hide_outlined),
            ),
          const SizedBox(width: 8),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width * .5,
            ),
            child: state.passed
                ? SizedBox(
                    width: 128,
                    child: CompleteButton(
                      challenge: widget.challenge,
                      block: block,
                      label: nextLabel,
                      trailingIcon: Icons.arrow_forward_rounded,
                      buttonStyle: actionStyle.copyWith(
                        backgroundColor: WidgetStatePropertyAll(colors.surface),
                        foregroundColor: WidgetStatePropertyAll(
                          colors.onSurface,
                        ),
                        side: WidgetStatePropertyAll(
                          BorderSide(color: colors.primary, width: 1.5),
                        ),
                      ),
                    ),
                  )
                : FilledButton(
                    style: actionStyle,
                    onPressed: busy
                        ? null
                        : failed
                        ? () => _retryRunner(workerType)
                        : _runTests,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (busy)
                          const SizedBox.square(
                            dimension: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else
                          Icon(
                            failed
                                ? Icons.refresh_rounded
                                : Icons.play_arrow_rounded,
                            size: 18,
                          ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            state.testsRunning
                                ? 'Checking…'
                                : failed
                                ? 'Retry'
                                : 'Check',
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  const _ToolButton({
    required this.label,
    required this.icon,
    required this.active,
    required this.onPressed,
    this.badge,
    this.badgeColor,
  });
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onPressed;
  final String? badge;
  final Color? badgeColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: active
            ? Theme.of(context).brightness == Brightness.dark
                  ? colors.onPrimary
                  : colors.primary
            : colors.onSurfaceVariant,
        backgroundColor: active
            ? Theme.of(context).brightness == Brightness.dark
                  ? colors.primary
                  : colors.primaryContainer
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        minimumSize: const Size(60, 64),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Badge(
            isLabelVisible: badge != null,
            label: Text(badge ?? ''),
            backgroundColor: badgeColor,
            textColor: Theme.of(context).brightness == Brightness.dark
                ? colors.surface
                : Colors.white,
            child: Icon(icon, size: 22),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _SymbolBar extends StatelessWidget {
  const _SymbolBar({required this.onSymbol});
  final ValueChanged<String> onSymbol;
  static const _symbols = [
    'Tab',
    '(',
    ')',
    '{',
    '}',
    '<',
    '>',
    '/',
    '=',
    ';',
    "'",
    '"',
    r'\',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final symbol in _symbols)
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: OutlinedButton(
                onPressed: () => onSymbol(symbol),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(44, 48),
                  padding: const EdgeInsets.all(10),
                  backgroundColor: colors.surface,
                  side: BorderSide(color: colors.outlineVariant),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: symbol == 'Tab'
                    ? const Icon(Icons.keyboard_tab_rounded, size: 20)
                    : Text(
                        symbol,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
        ],
      ),
    );
  }
}
