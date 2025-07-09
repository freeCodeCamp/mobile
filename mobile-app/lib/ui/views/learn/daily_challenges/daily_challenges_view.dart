import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/learn/daily_challenges/daily_challenges_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/daily_challenges/widgets/daily_challenge_block_widget.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';

class DailyChallengesView extends StatelessWidget {
  const DailyChallengesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DailyChallengesViewModel>.reactive(
      viewModelBuilder: () => DailyChallengesViewModel(),
      onViewModelReady: (viewModel) => viewModel.init(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            title: const Text('Daily Coding Challenges'),
          ),
          drawer: const DrawerWidgetView(),
          body: model.isBusy
              ? const Center(child: CircularProgressIndicator())
              : model.blocks.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListView.builder(
                        itemCount: model.blocks.length,
                        itemBuilder: (context, index) {
                          final block = model.blocks[index];
                          final isOpen =
                              model.blockOpenStates[block.monthYear] ?? false;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: DailyChallengeBlockWidget(
                              key: ValueKey(index),
                              challengeBlock: block,
                              isOpen: isOpen,
                              onToggleOpen: () =>
                                  model.toggleBlock(block.monthYear),
                              model: model,
                            ),
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: Text(
                        'No challenges available at the moment.',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
        );
      },
    );
  }
}
