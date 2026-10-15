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

const _postListFields = r'''
    fragment PostListFields on Post {
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
      readTimeInMinutes
      publishedAt
    }
  ''';

const _postDetailFields =
    _postListFields +
    r'''
    fragment PostDetailFields on Post {
      ...PostListFields
      url
      content {
        html
      }
    }
  ''';

const _getAllPostsQuery =
    _postListFields +
    r'''
    query GetAllPosts($publicationId: ObjectId!, $first: Int!, $after: String) {
      publication(id: $publicationId) {
        id
        posts(first: $first, after: $after) {
          edges {
            node {
              ...PostListFields
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
    _postListFields +
    r'''
    query GetPostsByAuthorQuery($first: Int!, $after: String, $filter: SearchPostsOfPublicationFilter!) {
      searchPostsOfPublication(first: $first, after: $after, filter: $filter) {
        edges {
          node {
            ...PostListFields
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
    _postListFields +
    r'''
    query GetPostsByTagQuery($publicationId: ObjectId!, $first: Int!, $after: String, $filter: PublicationPostConnectionFilter!) {
      publication(id: $publicationId) {
        id
        posts(first: $first, after: $after, filter: $filter) {
          edges {
            node {
              ...PostListFields
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
    _postDetailFields +
    r'''
    query GetPostBySlug($publicationId: ObjectId!, $slug: String!) {
      publication(id: $publicationId) {
        id
        post(slug: $slug) {
          ...PostDetailFields
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

  Future<Map<String, dynamic>> _query(
    String document,
    Map<String, dynamic> variables,
  ) async {
    final result = await _client.query(
      QueryOptions(document: gql(document), variables: variables),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    return result.data!;
  }

  RawPaginatedResponse _toPage(Map<String, dynamic> connection) => (
    items: (connection['edges'] as List).cast<Map<String, dynamic>>(),
    endCursor: connection['pageInfo']['endCursor'] as String,
    hasNextPage: connection['pageInfo']['hasNextPage'] as bool,
  );

  Future<RawPaginatedResponse> getAllPosts({String afterCursor = ''}) async {
    final data = await _query(_getAllPostsQuery, {
      'publicationId': _publicationId,
      'first': postsPerPage,
      'after': afterCursor,
    });

    return _toPage(data['publication']['posts'] as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> getPostBySlug(String slug) async {
    final data = await _query(_getPostBySlugQuery, {
      'publicationId': _publicationId,
      'slug': slug,
    });

    return data['publication']['post'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getAuthor(String authorSlug) async {
    final data = await _query(_getAuthorQuery, {'authorSlug': authorSlug});

    return data['user'] as Map<String, dynamic>;
  }

  Future<RawPaginatedResponse> getPostsByAuthor(
    String authorId, {
    String afterCursor = '',
  }) async {
    final data = await _query(_getPostsByAuthorQuery, {
      'first': postsPerPage,
      'after': afterCursor,
      'filter': {
        'publicationId': _publicationId,
        'authorIds': [authorId],
      },
    });

    return _toPage(data['searchPostsOfPublication'] as Map<String, dynamic>);
  }

  Future<RawPaginatedResponse> getPostsByTag(
    String tagSlug, {
    String afterCursor = '',
  }) async {
    final data = await _query(_getPostsByTagQuery, {
      'publicationId': _publicationId,
      'first': postsPerPage,
      'after': afterCursor,
      'filter': {
        'tagSlugs': [tagSlug],
      },
    });

    return _toPage(data['publication']['posts'] as Map<String, dynamic>);
  }
}
