import 'package:flutter/material.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:freecodecamp/ui/views/learn/challenge/challenge_viewmodel.dart';
import 'package:freecodecamp/ui/viewmodels/symbol_bar_viewmodel.dart';
import 'package:phone_ide/phone_ide.dart';
import 'package:stacked/stacked.dart';

/// Symbol Bar Widget
///
/// Displays a horizontal scrollable bar of quick-access symbols.
/// Supports both predefined and user-defined custom symbol sets.
///
/// The symbol bar:
/// - Automatically adapts to the currently selected symbol set
/// - Persists user preferences via SymbolBarService
/// - Inserts symbols at the cursor position in the code editor
class SymbolBar extends StatelessWidget {
  const SymbolBar({
    super.key,
    required this.editor,
    required this.challengeModel,
  });

  /// The code editor instance where symbols will be inserted
  final Editor editor;

  /// The challenge view model that handles symbol insertion
  final ChallengeViewModel challengeModel;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SymbolBarViewModel>.reactive(
      viewModelBuilder: () => SymbolBarViewModel(),
      onViewModelReady: (model) => model.init(),
      builder: (context, model, child) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          height: 50,
          color: const Color(0xFF1b1b32),
          child: ScrollShadow(
            size: 12,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: challengeModel.symbolBarScrollController,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: model.currentSymbols.length,
              itemBuilder: (context, index) {
                final symbol = model.currentSymbols[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 1,
                  ),
                  child: TextButton(
                    onPressed: () {
                      challengeModel.insertSymbol(symbol, editor);
                    },
                    style: TextButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.zero),
                      ),
                    ),
                    child: Text(symbol),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
