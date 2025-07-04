import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/learn/daily_challenges/daily_challenges_viewmodel.dart';
import 'package:stacked/stacked.dart';

class DailyChallengesView extends StatelessWidget {
  const DailyChallengesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DailyChallengesViewModel>.reactive(
      viewModelBuilder: () => DailyChallengesViewModel(),
      onViewModelReady: (viewModel) => viewModel.fetchDailyChallenges(),
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Daily Challenges'),
          ),
          body: viewModel.isBusy
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: viewModel.dailyChallenges.length,
                  itemBuilder: (context, index) {
                    final challenge = viewModel.dailyChallenges[index];
                    return ListTile(
                      title: Text(challenge['title'] ?? 'No Title'),
                      subtitle:
                          Text(challenge['description'] ?? 'No Description'),
                      onTap: () {
                        print('Tapped on ${challenge['title']}');
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}
