import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql/client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_repository.g.dart';

typedef RawPaginatedResponse = ({
  String endCursor,
  bool hasNextPage,
  List<Map<String, dynamic>> items,
});

const _apiUrl = 'https://gql-beta.hashnode.com';

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
      readTimeInMinutes
      content {
        html
      }
      publishedAt
    }
  ''';

const _getAllPostsQuery =
    postFieldsFragment +
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

const _getAuthorQuery = r'''
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

const _getPostsByAuthorQuery =
    postFieldsFragment +
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

const _getPostsByTagQuery =
    postFieldsFragment +
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

const _getPostBySlugQuery =
    postFieldsFragment +
    r'''
    query GetPostBySlug($publicationId: ObjectId!, $slug: String!) {
      publication(id: $publicationId) {
        post(slug: $slug) {
          ...PostFields
        }
      }
    }
  ''';

@riverpod
NewsApiRepository newsApiRepository(Ref ref) => NewsApiRepository();

class NewsApiRepository {
  final GraphQLClient _client = GraphQLClient(
    link: HttpLink(_apiUrl),
    cache: GraphQLCache(),
  );
  final String _publicationId = dotenv.get('HASHNODE_PUBLICATION_ID');

  Future<RawPaginatedResponse> getAllPosts({String afterCursor = ''}) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(_getAllPostsQuery),
        variables: {
          'publicationId': _publicationId,
          'first': postsPerPage,
          'after': afterCursor,
        },
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final data = result.data!['publication']['posts'];
    return (
      items: (data['edges'] as List).cast<Map<String, dynamic>>(),
      endCursor: data['pageInfo']['endCursor'] as String,
      hasNextPage: data['pageInfo']['hasNextPage'] as bool,
    );
  }

  Future<Map<String, dynamic>> getPostBySlug(String slug) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(_getPostBySlugQuery),
        variables: {
          'publicationId': _publicationId,
          'slug': slug,
        },
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    return result.data!['publication']['post'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getAuthor(String authorSlug) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(_getAuthorQuery),
        variables: {'authorSlug': authorSlug},
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    return result.data!['user'] as Map<String, dynamic>;
  }

  Future<RawPaginatedResponse> getPostsByAuthor(
    String authorId, {
    String afterCursor = '',
  }) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(_getPostsByAuthorQuery),
        variables: {
          'first': postsPerPage,
          'after': afterCursor,
          'filter': {
            'publicationId': _publicationId,
            'authorIds': [authorId],
          },
        },
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final data = result.data!['searchPostsOfPublication'];
    return (
      items: (data['edges'] as List).cast<Map<String, dynamic>>(),
      endCursor: data['pageInfo']['endCursor'] as String,
      hasNextPage: data['pageInfo']['hasNextPage'] as bool,
    );
  }

  Future<RawPaginatedResponse> getPostsByTag(
    String tagSlug, {
    String afterCursor = '',
  }) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(_getPostsByTagQuery),
        variables: {
          'publicationId': _publicationId,
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

    final data = result.data!['publication']['posts'];
    return (
      items: (data['edges'] as List).cast<Map<String, dynamic>>(),
      endCursor: data['pageInfo']['endCursor'] as String,
      hasNextPage: data['pageInfo']['hasNextPage'] as bool,
    );
  }
}
