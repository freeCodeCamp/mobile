import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/learn/daily_challenges/daily_challenges_viewmodel.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
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
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            title: const Text('Daily Challenges'),
          ),
          drawer: const DrawerWidgetView(),
          body: viewModel.isBusy
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildChallengeBlock(
                          context,
                          viewModel,
                          'July 2025',
                          viewModel.julyChallenges,
                          viewModel.isJulyOpen,
                          () => viewModel.toggleJulyOpen(),
                        ),
                        const SizedBox(height: 16),
                        _buildChallengeBlock(
                          context,
                          viewModel,
                          'June 2025',
                          viewModel.juneChallenges,
                          viewModel.isJuneOpen,
                          () => viewModel.toggleJuneOpen(),
                        ),
                        const SizedBox(height: 16),
                        _buildChallengeBlock(
                          context,
                          viewModel,
                          'May 2025',
                          viewModel.mayChallenges,
                          viewModel.isMayOpen,
                          () => viewModel.toggleMayOpen(),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildChallengeBlock(
    BuildContext context,
    DailyChallengesViewModel viewModel,
    String title,
    List<dynamic> challenges,
    bool isOpen,
    VoidCallback onToggle,
  ) {
    final completed = 0; // No completion logic yet
    final total = challenges.length;
    final progress =
        total == 0 ? 0.01 : (completed == 0 ? 0.01 : completed / total);
    final description = total > 0
        ? (challenges.isNotEmpty && challenges[0]['description'] != null
            ? challenges[0]['description']
            : 'Your daily coding challenges.')
        : 'Your daily coding challenges.';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
        ),
        color: const Color.fromRGBO(0x1b, 0x1b, 0x32, 1),
      ),
      padding: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.calendar_today,
                    color: Theme.of(context).colorScheme.primary, size: 30),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      wordSpacing: 0,
                      letterSpacing: 0,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              completed == total && total > 0
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.check_circle,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Text(
                            'Completed',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: LinearProgressIndicator(
                        minHeight: 12,
                        value: progress,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary,
                        ),
                        backgroundColor:
                            const Color.fromRGBO(0x2a, 0x2a, 0x40, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              description,
              style: const TextStyle(color: FccColors.gray05),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextButton(
                  onPressed: onToggle,
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(0x1b, 0x1b, 0x32, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(
                        color: Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                      ),
                    ),
                  ),
                  child: Text(
                    isOpen ? 'Hide Challenges' : 'Show Challenges',
                  ),
                ),
              ),
            ],
          ),
          if (isOpen)
            Container(
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(
                maxHeight: 300,
              ),
              child: GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: challenges.length > 24
                    ? const AlwaysScrollableScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  mainAxisSpacing: 3,
                  crossAxisSpacing: 3,
                ),
                itemCount: challenges.length,
                itemBuilder: (context, step) {
                  final challenge = challenges[step];
                  final match =
                      RegExp(r'\d+').firstMatch(challenge['title'] ?? '');
                  final stepNumber =
                      match != null ? int.parse(match.group(0)!) : step + 1;
                  return TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor:
                          const Color.fromRGBO(0x2a, 0x2a, 0x40, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(
                          color: Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                        ),
                      ),
                    ),
                    child: Text(
                      stepNumber.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
