import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/models/challenge_file_model.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/models/curriculum_model.dart';
import 'package:mobile_app_new/learn/services/code_service.dart';
import 'package:mobile_app_new/learn/services/test_runner_service.dart';
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
  // NOTE: Null for daily challenges, which belong to no block.
  final Block? block;
  // NOTE: Replaces the file selector; daily challenges pick a language here.
  final Widget? selector;

  @override
  ConsumerState<EditorChallengeView> createState() =>
      _EditorChallengeViewState();
}

class _EditorChallengeViewState extends ConsumerState<EditorChallengeView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _subscriptions = <StreamSubscription<Object>>[];

  Editor? _editor;
  TextFieldData? _focused;
  bool _drawerOpen = false;

  EditorChallengeNotifierProvider get _provider =>
      editorChallengeProvider(widget.challenge);

  @override
  void initState() {
    super.initState();
    _loadEditor(ref.read(_provider).file);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scaffoldKey.currentState?.openEndDrawer(),
    );
  }

  @override
  void didUpdateWidget(EditorChallengeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.challenge != widget.challenge) {
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
    final challenge = widget.challenge;
    final resetCount = ref.read(_provider).resetCount;
    final contents = await ref
        .read(learnCodeServiceProvider)
        .contents(challenge, file);
    // NOTE: A newer load started while this one awaited, so this result is stale.
    if (!mounted || challenge != widget.challenge) return;
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
      editor.onTextChange.stream.listen(
        (text) => ref.read(_provider.notifier).codeChanged(file, text),
      ),
      editor.textfieldData.stream.listen((data) => _focused = data),
    ]);
    setState(() {
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

  void _retryRunner(String workerType) {
    if (ref.read(learnTestRunnerServerProvider).hasError) {
      ref.invalidate(learnTestRunnerServerProvider);
    } else {
      ref.invalidate(learnTestRunnerServiceProvider(workerType));
    }
  }

  Future<void> _runTests() async {
    FocusManager.instance.primaryFocus?.unfocus();
    await ref.read(_provider.notifier).runTests();
    if (mounted) _scaffoldKey.currentState?.openEndDrawer();
  }

  Future<void> _reset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Code'),
        content: const Text('Are you sure you want to reset your code?'),
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
    if (confirmed != true || !mounted) return;

    _scaffoldKey.currentState?.closeEndDrawer();
    await ref.read(_provider.notifier).reset();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      _provider.select((s) => (s.file, s.resetCount)),
      (_, next) => _loadEditor(next.$1),
    );

    final state = ref.watch(_provider);
    final editor = _editor;

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      onEndDrawerChanged: (open) {
        if (open) FocusManager.instance.primaryFocus?.unfocus();
        setState(() => _drawerOpen = open);
      },
      appBar: _appBar(state),
      endDrawer: Drawer(
        width: MediaQuery.sizeOf(context).width * 0.9,
        child: SafeArea(
          child: switch (state.panel) {
            EditorPanel.instruction => InstructionPanel(
              challenge: widget.challenge,
              block: widget.block,
            ),
            EditorPanel.hint => HintPanel(
              challenge: widget.challenge,
              block: widget.block,
              hint: state.hint,
              onReset: _reset,
            ),
            EditorPanel.pass => PassPanel(
              challenge: widget.challenge,
              block: widget.block,
            ),
          },
        ),
      ),
      bottomNavigationBar: _bottomBar(state),
      body: IndexedStack(
        index: state.body.index,
        sizing: StackFit.expand,
        children: [
          editor ?? const Center(child: CircularProgressIndicator()),
          TestList(tests: widget.challenge.tests, results: state.testResults),
          if (state.body == EditorBody.preview)
            ProjectPreview(
              load: () => ref.read(_provider.notifier).previewHtml(),
            )
          else
            const SizedBox.shrink(),
          ConsoleOutput(
            testConsole: state.testConsole,
            userConsole: state.userConsole,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _appBar(EditorChallengeState state) {
    final title = switch (state.body) {
      EditorBody.preview => 'PREVIEW',
      EditorBody.console => 'CONSOLE',
      _ => null,
    };
    final showingTests = state.body == EditorBody.tests;

    return AppBar(
      automaticallyImplyLeading: title == null,
      actions: const [SizedBox.shrink()],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, thickness: 1, color: FccColors.gray45),
      ),
      title: title != null
          ? Text(title, style: const TextStyle(fontWeight: FontWeight.bold))
          : Row(
              children: [
                Expanded(
                  child:
                      widget.selector ??
                      _FileSelector(
                        files: widget.challenge.challengeFiles,
                        selected: state.file,
                        highlight: !showingTests,
                        onSelected: (file) =>
                            ref.read(_provider.notifier).selectFile(file),
                      ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _TabButton(
                    label: 'Tests',
                    icon: Icons.science_outlined,
                    active: showingTests,
                    onPressed: () =>
                        ref.read(_provider.notifier).showBody(EditorBody.tests),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _bottomBar(EditorChallengeState state) {
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    final workerType = workerTypeOf(widget.challenge.challengeType);
    final runner = ref.watch(learnTestRunnerServiceProvider(workerType));
    final failed = runner.hasError && !runner.isLoading;
    final busy = state.testsRunning || (!runner.hasValue && !failed);

    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: FccColors.gray45)),
      ),
      padding: EdgeInsets.only(bottom: keyboard),
      child: BottomAppBar(
        height: keyboard != 0 ? 116 : 72,
        padding: keyboard != 0 ? const EdgeInsets.only(bottom: 8) : null,
        color: const Color(0x990a0a23),
        child: Column(
          children: [
            if (keyboard != 0) _SymbolBar(onSymbol: _insertSymbol),
            Row(
              children: [
                _PanelButton(
                  icon: Icons.info_outline_rounded,
                  active: _drawerOpen && state.panel == EditorPanel.instruction,
                  onPressed: () {
                    ref
                        .read(_provider.notifier)
                        .showPanel(EditorPanel.instruction);
                    _scaffoldKey.currentState?.openEndDrawer();
                  },
                ),
                if (workerType == 'dom')
                  _PanelButton(
                    icon: Icons.remove_red_eye_outlined,
                    active: state.body == EditorBody.preview,
                    onPressed: () => ref
                        .read(_provider.notifier)
                        .showBody(EditorBody.preview),
                  ),
                _PanelButton(
                  icon: Icons.terminal,
                  active: state.body == EditorBody.console,
                  onPressed: () =>
                      ref.read(_provider.notifier).showBody(EditorBody.console),
                ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  color: state.passed
                      ? FccColors.green70
                      : const Color.fromRGBO(0x1D, 0x9B, 0xF0, 1),
                  child: IconButton(
                    tooltip: failed
                        ? 'The test runner failed to load. Tap to retry.'
                        : null,
                    icon: busy
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(),
                          )
                        : failed
                        ? const Icon(Icons.refresh_rounded, size: 30)
                        : Icon(
                            state.passed
                                ? Icons.arrow_forward_rounded
                                : Icons.done_rounded,
                            size: 30,
                          ),
                    onPressed: busy
                        ? null
                        : failed
                        ? () => _retryRunner(workerType)
                        : _runTests,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FileSelector extends StatelessWidget {
  const _FileSelector({
    required this.files,
    required this.selected,
    required this.highlight,
    required this.onSelected,
  });

  final List<ChallengeFile> files;
  final ChallengeFile selected;
  final bool highlight;
  final ValueChanged<ChallengeFile> onSelected;

  @override
  Widget build(BuildContext context) {
    if (files.length == 1) {
      return _TabButton(
        label: selected.fileName,
        icon: Icons.insert_drive_file_outlined,
        active: highlight,
        onPressed: () => onSelected(selected),
      );
    }

    Text label(ChallengeFile file) {
      final active = highlight && file == selected;
      return Text(
        file.fileName,
        style: TextStyle(
          color: active ? FccColors.blue50 : Colors.white,
          fontWeight: active ? FontWeight.bold : FontWeight.normal,
        ),
      );
    }

    return DropdownButton<ChallengeFile>(
      isExpanded: true,
      dropdownColor: FccColors.gray85,
      underline: const SizedBox.shrink(),
      value: selected,
      items: [
        for (final file in files)
          DropdownMenuItem(value: file, child: label(file)),
      ],
      selectedItemBuilder: (_) => [
        for (final file in files) Center(child: label(file)),
      ],
      onChanged: (file) => onSelected(file ?? selected),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.icon,
    required this.active,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = active ? FccColors.blue50 : Colors.white;

    return TextButton.icon(
      onPressed: onPressed,
      label: Text(label, style: TextStyle(color: color)),
      icon: Icon(icon, size: 30, color: color),
      iconAlignment: IconAlignment.end,
      style: TextButton.styleFrom(
        backgroundColor: FccColors.gray90,
        shape: const RoundedRectangleBorder(),
      ),
    );
  }
}

class _PanelButton extends StatelessWidget {
  const _PanelButton({
    required this.icon,
    required this.active,
    required this.onPressed,
  });

  final IconData icon;
  final bool active;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: active ? Colors.white : FccColors.gray75,
      child: IconButton(
        icon: Icon(
          icon,
          size: 32,
          color: active ? FccColors.gray75 : Colors.white,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class _SymbolBar extends StatelessWidget {
  const _SymbolBar({required this.onSymbol});

  final ValueChanged<String> onSymbol;

  static const _symbols = ['Tab', '<', '/', '>', r'\', "'", '"', '=', '{', '}'];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      height: 50,
      color: FccColors.gray85,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
          for (final symbol in _symbols)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 1),
              child: TextButton(
                onPressed: () => onSymbol(symbol),
                style: TextButton.styleFrom(
                  shape: const RoundedRectangleBorder(),
                ),
                child: Text(symbol),
              ),
            ),
        ],
      ),
    );
  }
}
