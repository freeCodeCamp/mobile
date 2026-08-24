import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/models/news/post_model.dart';
import 'package:mobile_app_new/ui/core/html_handler/html_handler.dart';
import 'package:mobile_app_new/ui/views/news/news-post/news_post_viewmodel.dart';
import 'package:mobile_app_new/ui/views/news/widgets/tag_button.dart';

class NewsPostHeader extends StatelessWidget {
  const NewsPostHeader({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final imageUrl = post.coverImage?.url;

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: imageUrl == null
              ? Image.asset(
                  'assets/images/freecodecamp-banner.png',
                  fit: BoxFit.cover,
                )
              : CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      ColoredBox(color: FccColors.gray80),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/freecodecamp-banner.png',
                    fit: BoxFit.cover,
                  ),
                ),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                color: FccColors.gray80,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      style: const TextStyle(fontSize: 24, height: 1.5),
                    ),
                    Text(
                      'Written by ${post.author.name}',
                      style: const TextStyle(height: 1.5),
                    ),
                    if (post.tags.isNotEmpty)
                      Wrap(
                        children: [
                          for (int j = 0; j < post.tags.length && j < 3; j++)
                            TagButton(
                              tagName: post.tags[j].name,
                              tagSlug: post.tags[j].slug,
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class NewsPostView extends ConsumerStatefulWidget {
  const NewsPostView({super.key, required this.slug});

  final String slug;

  @override
  ConsumerState<NewsPostView> createState() => _NewsPostViewState();
}

class _NewsPostViewState extends ConsumerState<NewsPostView> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _bottomButtonController = ScrollController();

  bool _hasInitializedAnimation = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleBottomButtonAnimation);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bottomButtonController.dispose();
    super.dispose();
  }

  double _lastScrollOffset = 0;

  void _handleBottomButtonAnimation() {
    if (!_bottomButtonController.hasClients) return;

    if (_scrollController.offset <= _lastScrollOffset) {
      // Scrolling up — show buttons
      _bottomButtonController.animateTo(
        _bottomButtonController.position.maxScrollExtent - 50,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
      );
    } else {
      // Scrolling down — hide buttons
      _bottomButtonController.animateTo(
        0,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
      );
    }
    _lastScrollOffset = _scrollController.offset;
  }

  void _initBottomButtonAnimation() {
    if (_hasInitializedAnimation) return;
    _hasInitializedAnimation = true;

    Future.delayed(const Duration(seconds: 1), () {
      if (_bottomButtonController.hasClients) {
        _bottomButtonController.animateTo(
          _bottomButtonController.position.maxScrollExtent - 50,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final postAsync = ref.watch(newsPostProvider(widget.slug));

    return Scaffold(
      backgroundColor: FccColors.gray90,
      body: postAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          log('Error loading post: $error');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Unable to load post.', textAlign: TextAlign.center),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () =>
                      ref.invalidate(newsPostProvider(widget.slug)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        },
        data: (post) {
          final htmlWidgets = _buildLazyLoadedHtml(post);
          return Stack(
            children: [
              ListView.builder(
                controller: _scrollController,
                itemCount: htmlWidgets.length,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, i) {
                  return Row(children: [Expanded(child: htmlWidgets[i])]);
                },
              ),
              _buildBottomButtons(post),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildLazyLoadedHtml(Post post) {
    HTMLParser htmlParser = HTMLParser(context: context);

    List<Widget> elements = htmlParser.parse(post.content.html);

    elements.insert(
      0,
      Stack(
        children: [
          NewsPostHeader(post: post),
          AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            leading: Tooltip(
              message: 'Back',
              child: InkWell(
                onTap: () => context.pop(),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.black.withValues(alpha: 0.5),
                  ),
                  child: const Icon(Icons.arrow_back),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    elements.add(const SizedBox(height: 100));

    _initBottomButtonAnimation();

    return elements;
  }

  Widget _buildBottomButtons(Post post) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 75,
        width: 300,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _bottomButtonController,
          children: [
            Row(
              children: [
                Container(height: 150),
                // TODO: Bookmark button
                _BottomButton(
                  label: 'Bookmark',
                  icon: Icons.bookmark_border,
                  onPressed: () {
                    // TODO: Implement bookmark functionality
                  },
                  rightSided: false,
                ),
                const SizedBox(
                  height: 35,
                  child: VerticalDivider(color: Colors.white, width: 0),
                ),
                _BottomButton(
                  label: 'Share',
                  icon: Icons.share,
                  onPressed: () {
                    // TODO: Implement share functionality
                  },
                  rightSided: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomButton extends StatelessWidget {
  const _BottomButton({
    required this.label,
    required this.onPressed,
    required this.icon,
    required this.rightSided,
  });

  final VoidCallback onPressed;
  final String label;
  final bool rightSided;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
        label: Text(label),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(rightSided ? 0 : 10),
              topRight: Radius.circular(rightSided ? 10 : 0),
              bottomLeft: Radius.circular(rightSided ? 0 : 10),
              bottomRight: Radius.circular(rightSided ? 10 : 0),
            ),
          ),
          backgroundColor: FccColors.gray80,
        ),
      ),
    );
  }
}
