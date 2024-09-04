import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql/client.dart';

typedef GetAllPostsT
    = Future<({String endCursor, bool hasNextPage, List posts})>;

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
    query GetAllPosts($host: String!, $first: Int!, $after: String) {
      publication(host: $host) {
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
  late final String host;

  Future<void> init() async {
    // TODO: Initialize dotenv in main once for the entire app
    await dotenv.load();

    client = GraphQLClient(
      link: apiLink,
      cache: GraphQLCache(),
    );
    host = dotenv.get('HASHNODE_HOST');
  }

  GetAllPostsT getAllPosts({String afterCursor = ''}) async {
    final result = await client.query(
      QueryOptions(
        document: gql(getAllPostsQuery),
        variables: {
          'host': host,
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

  NewsApiServive._internal();
}
