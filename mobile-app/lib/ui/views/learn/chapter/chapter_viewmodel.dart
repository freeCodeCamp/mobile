import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/learn/completed_challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ChapterViewModel extends BaseViewModel {
  final _dio = DioService.dio;
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthenticationService auth = locator<AuthenticationService>();

  Future<SuperBlock?>? superBlockFuture;

  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  int _currentChapterIndex = 0;
  int get currentChapterIndex => _currentChapterIndex;

  List<Chapter> _chapters = [];
  List<Chapter> get chapters => _chapters;

  List<GlobalKey> _chapterKeys = [];
  List<GlobalKey> get chapterKeys => _chapterKeys;

  bool _isAnimating = false;
  bool get isAnimating => _isAnimating;

  void init() async {
    superBlockFuture = requestChapters();
  }

  void setChapters(List<Chapter> chapters) {
    _chapters = chapters;
    // Create GlobalKeys for each chapter for accurate scrolling
    _chapterKeys = List.generate(chapters.length, (index) => GlobalKey());
    // Set current chapter index to first available (non-coming-soon) chapter
    _currentChapterIndex = _findFirstAvailableChapter();
    notifyListeners();
  }

  void scrollToPrevious() {
    if (!_isAnimating) {
      int previousIndex = _findPreviousAvailableChapter(_currentChapterIndex);
      if (previousIndex != -1) {
        _currentChapterIndex = previousIndex;
        _scrollToChapter(_currentChapterIndex);
        notifyListeners();
      }
    }
  }

  void scrollToNext() {
    if (!_isAnimating) {
      int nextIndex = _findNextAvailableChapter(_currentChapterIndex);
      if (nextIndex != -1) {
        _currentChapterIndex = nextIndex;
        _scrollToChapter(_currentChapterIndex);
        notifyListeners();
      }
    }
  }

  void _scrollToChapter(int index) async {
    if (index >= 0 && index < _chapterKeys.length) {
      final context = _chapterKeys[index].currentContext;
      if (context != null) {
        _isAnimating = true;
        notifyListeners();
        
        try {
          // Use ensureVisible to scroll to the beginning of the chapter
          await Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            alignment: 0.0, // Scroll to the beginning of the chapter
          );
        } finally {
          _isAnimating = false;
          notifyListeners();
        }
      }
    }
  }

  bool get hasPrevious => _findPreviousAvailableChapter(_currentChapterIndex) != -1;
  bool get hasNext => _findNextAvailableChapter(_currentChapterIndex) != -1;

  /// Find the first available (non-coming-soon) chapter index
  int _findFirstAvailableChapter() {
    for (int i = 0; i < _chapters.length; i++) {
      if (!(_chapters[i].comingSoon ?? false)) {
        return i;
      }
    }
    return 0; // Fallback to first chapter if all are coming soon
  }

  /// Find the previous available (non-coming-soon) chapter index
  int _findPreviousAvailableChapter(int currentIndex) {
    for (int i = currentIndex - 1; i >= 0; i--) {
      if (i < _chapters.length && !(_chapters[i].comingSoon ?? false)) {
        return i;
      }
    }
    return -1; // No previous available chapter found
  }

  /// Find the next available (non-coming-soon) chapter index
  int _findNextAvailableChapter(int currentIndex) {
    for (int i = currentIndex + 1; i < _chapters.length; i++) {
      if (!(_chapters[i].comingSoon ?? false)) {
        return i;
      }
    }
    return -1; // No next available chapter found
  }

  Future<String> calculateProgress(Module module) async {
    int steps = 0;
    num completedCount = 0;

    for (int i = 0; i < module.blocks!.length; i++) {
      steps += module.blocks![i].challenges.length;

      for (int j = 0; j < module.blocks![i].challenges.length; j++) {
        completedCount +=
            await completedChallenge(module.blocks![i].challenges[j].id)
                ? 1
                : 0;
      }
    }

    return '$completedCount/$steps';
  }

  Future<bool> completedChallenge(String incomingId) async {
    FccUserModel? user = await auth.userModel;

    if (user != null) {
      for (CompletedChallenge challenge in user.completedChallenges) {
        if (challenge.id == incomingId) {
          return true;
        }
      }
    }

    return false;
  }

  Future<SuperBlock?> requestChapters() async {
    String baseUrl = LearnService.baseUrlV2;

    final Response res = await _dio.get('$baseUrl/full-stack-developer.json');
    if (res.statusCode == 200) {
      return SuperBlock.fromJson(
        res.data,
        'full-stack-developer',
        'Certified Full Stack Developer Curriculum',
      );
    }

    return null;
  }

  void routeToBlockView(
    List<Block> blocks,
    String moduleName,
  ) {
    _navigationService.navigateTo(
      Routes.chapterBlockView,
      arguments: ChapterBlockViewArguments(
        blocks: blocks,
        moduleName: moduleName,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
