import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_viewmodel.dart';
import 'package:freecodecamp/ui/views/news/news-search/news_search_viewmodel.dart';
import 'package:stacked/stacked.dart';

class NewsSearchView extends StatelessWidget {
  const NewsSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewsSearchModel>.reactive(
      viewModelBuilder: () => NewsSearchModel(),
      onViewModelReady: (model) => model.init(),
      onDispose: (model) => model.onDispose(),
      builder: (context, model, child) {
        // final isSearchable = model.searchbarController.text != '' &&
        //     !model.isLoading &&
        //     model.hasData;

        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            title: TextField(
              controller: model.searchbarController,
              decoration: InputDecoration(
                hintText: context.t.tutorial_search_placeholder,
                fillColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                border: InputBorder.none,
                filled: true,
              ),
              onChanged: (value) {
                model.setSearchTerm(value);
                model.setHasData = false;
                model.setIsLoading = true;
              },
              // onSubmitted: isSearchable
              //     ? (value) {
              //         model.searchSubject();
              //       }
              //     : (value) {},
            ),
            // actions: [
            //   Container(
            //     margin: const EdgeInsets.only(left: 8),
            //     color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
            //     child: IconButton(
            //       onPressed: isSearchable
            //           ? () {
            //               model.searchSubject();
            //             }
            //           : null,
            //       icon: const Icon(
            //         Icons.search_sharp,
            //       ),
            //     ),
            //   )
            // ],
          ),
          body: StreamBuilder<SearchResponse>(
            stream: model.algolia.responses,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'There was an error loading tutorials \n please try again',
                    textAlign: TextAlign.center,
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting ||
                  model.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!snapshot.hasData) {
                return Center(
                  child: Text(
                    context.t.tutorial_search_no_results,
                  ),
                );
              }

              final currentData = snapshot.data!.hits;

              return Column(
                children: [
                  Expanded(
                    child: currentData.isNotEmpty
                        ? Scrollbar(
                            thumbVisibility: true,
                            trackVisibility: true,
                            child: ListView.separated(
                              physics: const ClampingScrollPhysics(),
                              itemCount: currentData.length,
                              separatorBuilder: (context, int i) =>
                                  const Divider(
                                color: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                                thickness: 1,
                                height: 1,
                              ),
                              itemBuilder: (context, index) {
                                final item = currentData[index];
                                final String? featureImage = item['featureImage'];
                                final String title = item['title'] ?? '';
                                final String? authorName = item['author']?['name'];
                                final String? authorImage = item['author']?['profileImage'];
                                final String? publishedAt = item['publishedAt'];

                                return InkWell(
                                  onTap: () => model.navigateToTutorial(
                                    item['objectID'] ?? '',
                                    item['slug'] ?? '',
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 16,
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: SizedBox(
                                            width: 120,
                                            height: 80,
                                            child: featureImage != null
                                                ? CachedNetworkImage(
                                                    imageUrl: featureImage,
                                                    fit: BoxFit.cover,
                                                    placeholder: (context, url) =>
                                                        Container(
                                                      color: const Color(0xFF2A2A40),
                                                    ),
                                                    errorWidget: (context, url, error) =>
                                                        Image.asset(
                                                      'assets/images/freecodecamp-banner.png',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                : Image.asset(
                                                    'assets/images/freecodecamp-banner.png',
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                title,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  height: 1.3,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  if (authorImage != null)
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(12),
                                                      child: CachedNetworkImage(
                                                        imageUrl: authorImage,
                                                        width: 24,
                                                        height: 24,
                                                        fit: BoxFit.cover,
                                                        errorWidget:
                                                            (context, url, error) =>
                                                                Image.asset(
                                                          'assets/images/placeholder-profile-img.png',
                                                          width: 24,
                                                          height: 24,
                                                        ),
                                                      ),
                                                    )
                                                  else
                                                    Image.asset(
                                                      'assets/images/placeholder-profile-img.png',
                                                      width: 24,
                                                      height: 24,
                                                    ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      authorName ?? '',
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.white
                                                            .withValues(alpha: 0.7),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              if (publishedAt != null)
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 4),
                                                  child: Text(
                                                    NewsFeedViewModel.parseDate(
                                                        publishedAt),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white
                                                          .withValues(alpha: 0.5),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Text(
                              context.t.tutorial_search_no_results,
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
