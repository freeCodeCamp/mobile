import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/models/challenge_file_model.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/models/curriculum_model.dart';
import 'package:freecodecamp/learn/services/code_service.dart';
import 'package:freecodecamp/learn/services/test_runner_service.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/complete_button.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/help_dialog.dart';
import 'package:freecodecamp/learn/ui/editor_challenge/editor_body.dart';
import 'package:freecodecamp/learn/ui/editor_challenge/editor_challenge_viewmodel.dart';
import 'package:freecodecamp/learn/ui/editor_challenge/editor_panels.dart';
import 'package:freecodecamp/learn/ui/editor_challenge/phone_ide_theme.dart';
import 'package:freecodecamp/learn/ui/widgets/learn_presentation.dart';
import 'package:freecodecamp/learn/ui/widgets/resizable_panel.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:phone_ide/models/textfield_data.dart';
import 'package:phone_ide/phone_ide.dart';

class EditorChallengeView extends ConsumerStatefulWidget {
  const EditorChallengeView({
    super.key,
    required this.challenge,
    this.block,
    this.selector,
    this.dailyChallengeNumber,
  });

  final Challenge challenge;
  // Daily challenges belong to no block and select a language instead of a file.
  final Block? block;
  final Widget? selector;
  final int? dailyChallengeNumber;

  @override
  ConsumerState<EditorChallengeView> createState() =>
      _EditorChallengeViewState();
}

enum _EditorSheet { tests, pass, preview, console }

class _EditorChallengeViewState extends ConsumerState<EditorChallengeView> {
  final _subscriptions = <StreamSubscription<Object>>[];
  final _modifiedFiles = <String>{};
  Editor? _editor;
  ThemeData? _editorTheme;
  TextFieldData? _focused;
  _EditorSheet? _sheet;
  final _instructionsPanel = ResizablePanelController();
  final _fileSelectorKey = GlobalKey();
  double? _selectorHeight;
  double? _panelHeight;
  int _editorLoad = 0;
  int _codeEdit = 0;
  final _warmRunners = <String>{};

  bool get _daily => widget.dailyChallengeNumber != null;

  EditorChallengeNotifierProvider get _provider =>
      editorChallengeProvider(widget.challenge);

  @override
  void initState() {
    super.initState();
    _loadEditor(ref.read(_provider).file);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = Theme.of(context);
    final current = _editor;
    if (current != null && _editorTheme != theme) {
      final editor = Editor(
        key: current.key,
        defaultLanguage: current.defaultLanguage,
        defaultValue: current.defaultValue,
        path: current.path,
        options: phoneIdeOptions(
          context,
          daily: _daily,
          regionOptions: current.options.regionOptions,
        ),
      );
      _subscribeToEditor(editor, ref.read(_provider).file);
      _editor = editor;
    }
    _editorTheme = theme;
  }

  @override
  void didUpdateWidget(EditorChallengeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.challenge != widget.challenge) {
      _sheet = null;
      // A daily challenge switching language keeps its instruction layout.
      if (oldWidget.challenge.id != widget.challenge.id) {
        _instructionsPanel.reset();
        _panelHeight = null;
      }
      _modifiedFiles.clear();
      _loadEditor(ref.read(_provider).file);
    }
  }

  @override
  void dispose() {
    _cancelSubscriptions();
    _instructionsPanel.dispose();
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
    // The previous editor stays on screen until the new one is ready, so a
    // reload never flashes a spinner.
    _focused = null;
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
      options: phoneIdeOptions(
        context,
        daily: _daily,
        regionOptions: region.isEmpty
            ? null
            : EditorRegionOptions(start: region[0], end: region[1]),
      ),
    );

    _subscribeToEditor(editor, file);
    setState(() {
      contents != file.contents
          ? _modifiedFiles.add(file.fileName)
          : _modifiedFiles.remove(file.fileName);
      _editor = editor;
      _editorTheme = Theme.of(context);
      _focused = null;
    });
  }

  void _subscribeToEditor(Editor editor, ChallengeFile file) {
    _cancelSubscriptions();
    _subscriptions.addAll([
      editor.onTextChange.stream.listen((text) {
        _codeEdit++;
        if (_sheet != null) _showSheet(null, preserveFocus: true);
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
      _EditorSheet.tests || _EditorSheet.pass => EditorBody.tests,
      null => EditorBody.editor,
    };
    if (ref.read(_provider).body != body) {
      ref.read(_provider.notifier).showBody(body);
    }
    setState(() {
      _sheet = sheet;
      if (sheet != null) {
        _instructionsPanel.update(expanded: false);
      }
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
      _instructionsPanel.update(expanded: true);
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

  void _measureFileSelector() {
    if (!mounted) {
      return;
    }
    final selector = _fileSelectorKey.currentContext?.size?.height;
    if (selector != _selectorHeight) {
      setState(() => _selectorHeight = selector);
    }
  }

  // Sizes measured after layout avoid a gap; the estimate covers the first frame.
  double _instructionsMaxHeight(double availableHeight) {
    final scale = MediaQuery.textScalerOf(context);
    final selector =
        _selectorHeight ?? math.max(44.0, scale.scale(16) * 1.5 + 22);
    return math.max(0.0, availableHeight - selector);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureFileSelector());
    ref.listen(
      _provider.select((s) => (s.file, s.resetCount)),
      (_, next) => _loadEditor(next.$1),
    );
    final state = ref.watch(_provider);
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    if (_daily) {
      // Runners are auto-dispose and one exists per language, so keep every
      // one used so far alive. Switching back then finds it ready.
      _warmRunners.add(workerTypeOf(widget.challenge.challengeType));
      for (final workerType in _warmRunners) {
        ref.watch(learnTestRunnerServiceProvider(workerType));
      }
    }
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
                    builder: (context, constraints) => Stack(
                      fit: StackFit.expand,
                      children: [
                        Column(
                          children: [
                            ResizablePanel(
                              controller: _instructionsPanel,
                              title: 'Instructions',
                              summaryHtml: widget.challenge.instructions,
                              maxHeight: _instructionsMaxHeight(
                                constraints.maxHeight,
                              ),
                              child: InstructionPanel(
                                key: const ValueKey('editor-instructions-body'),
                                challenge: widget.challenge,
                              ),
                            ),
                            _fileSelector(state),
                            Expanded(
                              child: _editorArea(
                                state,
                                keyboard > 0,
                                withPanel: false,
                              ),
                            ),
                          ],
                        ),
                        if (_sheet != null && keyboard == 0)
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: _panel(state, constraints.maxHeight),
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

  Widget _editorArea(
    EditorChallengeState state,
    bool keyboard, {
    bool withPanel = true,
  }) {
    return LayoutBuilder(
      builder: (context, editorSpace) => Stack(
        fit: StackFit.expand,
        children: [
          _editor ?? const Center(child: CircularProgressIndicator()),
          if (withPanel && _sheet != null && !keyboard)
            Align(
              alignment: Alignment.bottomCenter,
              child: _panel(state, editorSpace.maxHeight),
            ),
        ],
      ),
    );
  }

  PreferredSizeWidget _appBar(bool keyboard) {
    final block = widget.block;
    final index =
        block?.challenges.indexWhere((c) => c.id == widget.challenge.id) ?? -1;
    final isLab = block?.label == BlockLabel.lab;
    final title = _daily
        ? 'Challenge ${widget.dailyChallengeNumber}'
        : isLab
        ? block!.name
        : index >= 0
        ? 'Step ${index + 1} of ${block!.challenges.length}'
        : widget.challenge.title;
    final scale = MediaQuery.textScalerOf(context);
    final completed = ref.watch(
      authProvider.select(
        (auth) =>
            auth.value?.completedChallenges.any(
              (c) => c.id == widget.challenge.id,
            ) ??
            false,
      ),
    );
    return AppBar(
      leading: IconButton(
        tooltip: 'Back',
        onPressed: () => Navigator.of(context).maybePop(),
        icon: const Icon(Icons.arrow_back),
      ),
      leadingWidth: 44,
      titleSpacing: 8,
      toolbarHeight: math.max(56, scale.scale(16) + scale.scale(12) + 14),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _daily
                ? const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)
                : const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
          ),
          if (_daily || (block != null && !isLab))
            Text(
              _daily ? 'Daily coding challenge' : block!.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
      actions: [
        if (_daily)
          TextButton(
            onPressed: _help,
            child: const Text(
              'Get help',
              style: TextStyle(decoration: TextDecoration.underline),
            ),
          )
        else if (keyboard)
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
          if (completed)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Tooltip(
                message: 'Step completed',
                child: SizedBox.square(
                  dimension: 20,
                  child: FittedBox(child: LearnStatus(complete: true)),
                ),
              ),
            ),
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

  Widget _fileSelector(EditorChallengeState state) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final shadow = theme.colorScheme.shadow;
    return Stack(
      key: _fileSelectorKey,
      children: [
        widget.selector ?? _fileTabs(state),
        // Paint after the opaque tabs so the instruction panel's shadow is visible.
        ListenableBuilder(
          listenable: _instructionsPanel,
          builder: (context, _) => _instructionsPanel.expanded
              ? Positioned(
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
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _fileTabs(EditorChallengeState state) {
    final colors = Theme.of(context).colorScheme;
    final design = FccDesignColors.of(context);
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
                                Ext.css => design.lecture,
                                Ext.js => design.javascriptMarker,
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
    final maxHeight = availableHeight;
    final minHeight = math.min(140.0, maxHeight);
    final defaultHeight = switch (sheet) {
      _EditorSheet.pass => 430.0,
      _ => 320.0 * math.min(scale, 1.4),
    };
    final height = (_panelHeight ?? defaultHeight).clamp(minHeight, maxHeight);
    final title = switch (sheet) {
      _EditorSheet.tests => 'Tests',
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
      height: height,
      decoration: BoxDecoration(
        color: colors.surface,
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
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onVerticalDragUpdate: (details) => setState(
                    () => _panelHeight = (height - details.delta.dy).clamp(
                      minHeight,
                      maxHeight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: colors.outlineVariant,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 10,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
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
                    ),
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
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
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final design = FccDesignColors.of(context);
    final signedIn = ref.watch(authProvider).value != null;
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
    final actionStyle = theme.filledButtonTheme.style!.copyWith(
      minimumSize: const WidgetStatePropertyAll(Size(96, 48)),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      textStyle: const WidgetStatePropertyAll(
        TextStyle(
          fontFamily: 'Lato',
          fontSize: 17,
          fontWeight: FontWeight.w900,
        ),
      ),
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
                          icon: Icons.checklist,
                          selectedIcon: Icons.checklist,
                          active:
                              _sheet == _EditorSheet.tests ||
                              _sheet == _EditorSheet.pass,
                          badge: results == null
                              ? null
                              : '$passing/${widget.challenge.tests.length}',
                          badgeColor: state.passed
                              ? design.successBorder
                              : design.dangerFill,
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
                            selectedIcon: Icons.visibility,
                            active: _sheet == _EditorSheet.preview,
                            onPressed: () => _showSheet(
                              _sheet == _EditorSheet.preview
                                  ? null
                                  : _EditorSheet.preview,
                            ),
                          ),
                        _ToolButton(
                          label: 'Console',
                          icon: Icons.terminal_outlined,
                          selectedIcon: Icons.terminal_rounded,
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
              maxWidth: math.max(48, MediaQuery.sizeOf(context).width - 96),
            ),
            child: state.passed
                ? IntrinsicWidth(
                    child: CompleteButton(
                      challenge: widget.challenge,
                      block: block,
                      label: nextLabel,
                      trailingIcon: Icons.arrow_forward_rounded,
                      buttonStyle:
                          (signedIn
                                  ? actionStyle
                                  : theme.outlinedButtonTheme.style!)
                              .copyWith(
                                minimumSize: const WidgetStatePropertyAll(
                                  Size(48, 48),
                                ),
                                padding: const WidgetStatePropertyAll(
                                  EdgeInsetsDirectional.fromSTEB(18, 0, 14, 0),
                                ),
                                textStyle: WidgetStatePropertyAll(
                                  TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 16,
                                    fontWeight: signedIn
                                        ? FontWeight.w900
                                        : FontWeight.w700,
                                  ),
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
    required this.selectedIcon,
    required this.active,
    required this.onPressed,
    this.badge,
    this.badgeColor,
  });
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool active;
  final VoidCallback onPressed;
  final String? badge;
  final Color? badgeColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return TextButton(
      onPressed: onPressed,
      style:
          FccTheme.surfaceButtonStyle(
            context,
            fill: Colors.transparent,
            foreground: active ? colors.onSurface : colors.onSurfaceVariant,
          ).copyWith(
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
            minimumSize: const WidgetStatePropertyAll(Size(60, 64)),
          ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Badge(
            isLabelVisible: badge != null,
            label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 2,
                ),
              ),
              child: Text(
                badge ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            child: Icon(active ? selectedIcon : icon, size: 22),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: active ? FontWeight.w900 : FontWeight.w700,
            ),
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
