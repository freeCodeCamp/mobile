import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql/client.dart';

const postFieldsFragment = r'''
    fragment PostFields on Post {
      id
      slug
      title
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
    query GetPost($host: String!, $slug: String!) {
      publication(host: $host) {
        id
        post(slug: $slug) {
          ...PostFields
        }
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

  Future<void> getAllPosts() async {
    final result = await client.query(
      QueryOptions(
        document: gql(getAllPostsQuery),
        variables: {
          'host': host,
          'first': 2,
          'after': '',
        },
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    log(result.data.toString());

    // return result.data;
  }

  NewsApiServive._internal();
}
