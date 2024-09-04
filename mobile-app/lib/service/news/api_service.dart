import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql/client.dart';

typedef ApiData = ({String endCursor, bool hasNextPage, List posts});
typedef GetAllPostsT = Future<ApiData>;

const postsPerPage = 20;

const postFieldsFragment = r'''
    fragment PostFields on Post {
      id
      slug
      title
      url
      author {
        id
        username
        name
        bio {
          text
        }
        profilePicture
        socialMediaLinks {
          website
          twitter
          facebook
        }
        location
      }
      tags {
        id
        name
        slug
      }
      coverImage {
        url
      }
      brief
      readTimeInMinutes
      content {
        html
      }
      seo {
        description
      }
      publishedAt
      updatedAt
    }
  ''';

const getAllPostsQuery = postFieldsFragment +
    r'''
    query GetAllPosts($publicationId: ObjectId!, $first: Int!, $after: String) {
      publication(id: $publicationId) {
        id
        posts(first: $first, after: $after) {
          edges {
            node {
              ...PostFields
            }
          }
          pageInfo {
            endCursor
            hasNextPage
          }
        }
      }
    }
  ''';

const getAuthorQuery = postFieldsFragment +
    r'''
    query GetAuthor($authorSlug: String!) {
      user(username: $authorSlug) {
        id
        username
        name
        bio {
          text
        }
        profilePicture
        socialMediaLinks {
          website
          twitter
          facebook
        }
        location
      }
    }
  ''';

const getPostsByAuthorQuery = postFieldsFragment +
    r'''
    query GetPostsByAuthorQuery($first: Int!, $after: String, $filter: SearchPostsOfPublicationFilter!) {
      searchPostsOfPublication(first: $first, after: $after, filter: $filter) {
        edges {
          node {
            ...PostFields
          }
        }
        pageInfo {
          endCursor
          hasNextPage
        }
      }
    }
  ''';

const getPostsByTagQuery = postFieldsFragment +
    r'''
    query GetPostsByTagQuery($publicationId: ObjectId!, $first: Int!, $after: String, $filter: PublicationPostConnectionFilter!) {
      publication(id: $publicationId) {
        id
        posts(first: $first, after: $after, filter: $filter) {
          edges {
            node {
              ...PostFields
            }
          }
          pageInfo {
            endCursor
            hasNextPage
          }
        }
      }
    }
  ''';

const getPostQuery = postFieldsFragment +
    r'''
    query GetPost($id: ID!) {
      post(id: $id) {
        ...PostFields
      }
    }
  ''';

class NewsApiServive {
  static final NewsApiServive _instance = NewsApiServive._internal();
  factory NewsApiServive() => _instance;

  HttpLink apiLink = HttpLink('https://gql.hashnode.com');
  late final GraphQLClient client;
  late final String publicationId;

  Future<void> init() async {
    // TODO: Initialize dotenv in main once for the entire app
    await dotenv.load();

    client = GraphQLClient(
      link: apiLink,
      cache: GraphQLCache(),
    );
    publicationId = dotenv.get('HASHNODE_PUBLICATION_ID');
  }

  GetAllPostsT getAllPosts({String afterCursor = ''}) async {
    final result = await client.query(
      QueryOptions(
        document: gql(getAllPostsQuery),
        variables: {
          'publicationId': publicationId,
          'first': postsPerPage,
          'after': afterCursor,
        },
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final List<dynamic> posts = result.data!['publication']['posts']['edges'];
    final String endCursor =
        result.data!['publication']['posts']['pageInfo']['endCursor'];
    final bool hasNextPage =
        result.data!['publication']['posts']['pageInfo']['hasNextPage'];

    log('Fetched ${posts.length} posts');
    // log('First post: ${posts.first}');
    log('End cursor: $endCursor');
    log('Has next page: $hasNextPage');

    return (
      posts: posts,
      endCursor: endCursor,
      hasNextPage: hasNextPage,
    );
  }

  Future<Map<String, dynamic>> getPost(String postId) async {
    final result = await client.query(
      QueryOptions(
        document: gql(getPostQuery),
        variables: {
          'id': postId,
        },
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final Map<String, dynamic> post = result.data!['post'];

    return post;
  }

  Future<Map<String, dynamic>> getAuthor(String authorSlug) async {
    final result = await client.query(
      QueryOptions(
        document: gql(getAuthorQuery),
        variables: {
          'authorSlug': authorSlug,
        },
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final Map<String, dynamic> author = result.data!['user'];

    return author;
  }

  GetAllPostsT getPostsByAuthor(
    String authorId, {
    String afterCursor = '',
  }) async {
    final result = await client.query(
      QueryOptions(
        document: gql(getPostsByAuthorQuery),
        variables: {
          'first': postsPerPage,
          'after': afterCursor,
          'filter': {
            'publicationId': publicationId,
            'authorIds': [authorId],
          },
        },
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final List<dynamic> posts =
        result.data!['searchPostsOfPublication']['edges'];
    final String endCursor =
        result.data!['searchPostsOfPublication']['pageInfo']['endCursor'];
    final bool hasNextPage =
        result.data!['searchPostsOfPublication']['pageInfo']['hasNextPage'];

    log('Fetched ${posts.length} posts');

    return (
      posts: posts,
      endCursor: endCursor,
      hasNextPage: hasNextPage,
    );
  }

  GetAllPostsT getPostsByTag(
    String tagSlug, {
    String afterCursor = '',
  }) async {
    final result = await client.query(
      QueryOptions(
        document: gql(getPostsByTagQuery),
        variables: {
          'publicationId': publicationId,
          'first': postsPerPage,
          'after': afterCursor,
          'filter': {
            'tagSlugs': [tagSlug],
          },
        },
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final List<dynamic> posts = result.data!['publication']['posts']['edges'];
    final String endCursor =
        result.data!['publication']['posts']['pageInfo']['endCursor'];
    final bool hasNextPage =
        result.data!['publication']['posts']['pageInfo']['hasNextPage'];

    log('Fetched ${posts.length} posts');

    return (
      posts: posts,
      endCursor: endCursor,
      hasNextPage: hasNextPage,
    );
  }

  NewsApiServive._internal();
}
