import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/news/models/post_model.dart';
import 'package:mobile_app_new/news/ui/post/post_viewmodel.dart';
import 'package:mobile_app_new/news/ui/widgets/back_to_top_button.dart';
import 'package:mobile_app_new/news/ui/widgets/bookmark_button.dart';
import 'package:mobile_app_new/news/ui/widgets/bottom_button.dart';
import 'package:mobile_app_new/news/ui/widgets/tag_button.dart';
import 'package:mobile_app_new/routing/news.dart';
import 'package:mobile_app_new/widgets/error_retry.dart';
import 'package:mobile_app_new/widgets/html_handler/html_handler.dart';
import 'package:share_plus/share_plus.dart';

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
                    GestureDetector(
                      onTap: () => NewsAuthorRoute(
                        username: post.author.username,
                        $extra: post.author,
                      ).push(context),
                      child: Text(
                        'Written by ${post.author.name}',
                        style: const TextStyle(height: 1.5),
                      ),
                    ),
                    if (post.tags.isNotEmpty)
                      Wrap(
                        children: [
                          for (final tag in post.tags.take(3))
                            TagButton(tagName: tag.name, tagSlug: tag.slug),
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

  final GlobalKey _shareButtonKey = GlobalKey();

  bool _showBottomBar = true;

  // NOTE: Parsed and stored here to avoid re-parsing on every build
  List<Widget>? _htmlWidgets;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleBottomBarVisibility);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  double _lastScrollOffset = 0;

  void _handleBottomBarVisibility() {
    final offset = _scrollController.offset;
    // Scrolling up reveals the bar, scrolling down hides it.
    final shouldShow = offset <= _lastScrollOffset;
    _lastScrollOffset = offset;

    if (shouldShow == _showBottomBar) return;
    setState(() => _showBottomBar = shouldShow);
  }

  @override
  Widget build(BuildContext context) {
    final postAsync = ref.watch(newsPostProvider(widget.slug));

    return Scaffold(
      backgroundColor: FccColors.gray90,
      floatingActionButton: BackToTopButton(controller: _scrollController),
      body: postAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          log('Error loading post: $error');
          return ErrorRetry(
            message: 'Unable to load post.',
            onRetry: () => ref.invalidate(newsPostProvider(widget.slug)),
          );
        },
        data: (post) {
          final htmlWidgets = _htmlWidgets ??= _parseHtml(post);

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

  List<Widget> _parseHtml(Post post) {
    final elements = HTMLParser(context: context).parse(post.content.html);

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

    return elements;
  }

  void _sharePost(Post post) {
    final box =
        _shareButtonKey.currentContext?.findRenderObject() as RenderBox?;

    SharePlus.instance.share(
      ShareParams(
        text: '${post.title}\n\n${post.url}',
        sharePositionOrigin: box == null
            ? null
            : box.localToGlobal(Offset.zero) & box.size,
      ),
    );
  }

  Widget _buildBottomButtons(Post post) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedSlide(
        offset: _showBottomBar ? Offset.zero : const Offset(0, 1),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: SizedBox(
            width: 300,
            child: Row(
              children: [
                BookmarkButton(post: post),
                const SizedBox(
                  height: 35,
                  child: VerticalDivider(color: Colors.white, width: 0),
                ),
                NewsBottomButton(
                  key: _shareButtonKey,
                  label: 'Share',
                  icon: Icons.share,
                  onPressed: () => _sharePost(post),
                  rightSided: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
