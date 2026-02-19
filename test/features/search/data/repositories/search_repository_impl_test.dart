import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/features/search/data/datasources/search_local_data_source.dart';
import 'package:inha_notice/features/search/data/datasources/search_remote_data_source.dart';
import 'package:inha_notice/features/search/data/models/trending_topic_model.dart';
import 'package:inha_notice/features/search/data/repositories/search_repository_impl.dart';

class _FakeSearchRemoteDataSource implements SearchRemoteDataSource {
  List<TrendingTopicModel> topics = [];
  Object? error;

  @override
  Future<List<TrendingTopicModel>> getTrendingTopics() async {
    if (error != null) {
      throw error!;
    }
    return List.from(topics);
  }
}

class _FakeSearchLocalDataSource implements SearchLocalDataSource {
  List<String> recentWords = [];
  Object? addError;
  Object? removeError;
  Object? clearError;
  String? addedQuery;
  String? removedQuery;
  bool cleared = false;

  @override
  Future<void> initialize() async {}

  @override
  Future<void> addRecentSearchWord(String query) async {
    if (addError != null) {
      throw addError!;
    }
    addedQuery = query;
  }

  @override
  Future<void> clearRecentSearchWords() async {
    if (clearError != null) {
      throw clearError!;
    }
    cleared = true;
  }

  @override
  List<String> getRecentSearchWords() {
    return List.from(recentWords);
  }

  @override
  Future<void> removeRecentSearchWord(String query) async {
    if (removeError != null) {
      throw removeError!;
    }
    removedQuery = query;
  }
}

void main() {
  group('SearchRepositoryImpl 유닛 테스트', () {
    test('getTrendingTopics 성공 시 Right를 반환한다', () async {
      final remote = _FakeSearchRemoteDataSource()
        ..topics = const [
          TrendingTopicModel(
            id: '1',
            queryCount: '1',
            count: '10',
            updown: 'N',
            text: '학사',
            makeTimes: '12:00',
          ),
        ];
      final local = _FakeSearchLocalDataSource();
      final repository = SearchRepositoryImpl(
          remoteDataSource: remote, localDataSource: local);

      final result = await repository.getTrendingTopics();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Right 이어야 합니다.'),
        (topics) => expect(topics.first.text, '학사'),
      );
    });

    test('getTrendingTopics 실패 시 server Failure를 반환한다', () async {
      final remote = _FakeSearchRemoteDataSource()
        ..error = Exception('network');
      final local = _FakeSearchLocalDataSource();
      final repository = SearchRepositoryImpl(
          remoteDataSource: remote, localDataSource: local);

      final result = await repository.getTrendingTopics();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, 'API 서버 연결 실패'),
        (_) => fail('Left 이어야 합니다.'),
      );
    });

    test('addRecentSearchWord 성공 시 Right(null)을 반환한다', () async {
      final remote = _FakeSearchRemoteDataSource();
      final local = _FakeSearchLocalDataSource();
      final repository = SearchRepositoryImpl(
          remoteDataSource: remote, localDataSource: local);

      final result = await repository.addRecentSearchWord('장학');

      expect(local.addedQuery, '장학');
      expect(result, const Right(null));
    });

    test('addRecentSearchWord 실패 시 localDatabase Failure를 반환한다', () async {
      final remote = _FakeSearchRemoteDataSource();
      final local = _FakeSearchLocalDataSource()..addError = Exception('db');
      final repository = SearchRepositoryImpl(
          remoteDataSource: remote, localDataSource: local);

      final result = await repository.addRecentSearchWord('장학');

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, '로컬 데이터베이스 오류'),
        (_) => fail('Left 이어야 합니다.'),
      );
    });

    test('getRecentSearchWords는 로컬 데이터소스 값을 반환한다', () {
      final remote = _FakeSearchRemoteDataSource();
      final local = _FakeSearchLocalDataSource()..recentWords = ['정석', '학과'];
      final repository = SearchRepositoryImpl(
          remoteDataSource: remote, localDataSource: local);

      final result = repository.getRecentSearchWords();

      expect(result, ['정석', '학과']);
    });

    test('removeRecentSearchWord 실패 시 localDatabase Failure를 반환한다', () async {
      final remote = _FakeSearchRemoteDataSource();
      final local = _FakeSearchLocalDataSource()..removeError = Exception('db');
      final repository = SearchRepositoryImpl(
          remoteDataSource: remote, localDataSource: local);

      final result = await repository.removeRecentSearchWord('학사');

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, '로컬 데이터베이스 오류'),
        (_) => fail('Left 이어야 합니다.'),
      );
    });

    test('clearRecentSearchWords 실패 시 localDatabase Failure를 반환한다', () async {
      final remote = _FakeSearchRemoteDataSource();
      final local = _FakeSearchLocalDataSource()..clearError = Exception('db');
      final repository = SearchRepositoryImpl(
          remoteDataSource: remote, localDataSource: local);

      final result = await repository.clearRecentSearchWords();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, '로컬 데이터베이스 오류'),
        (_) => fail('Left 이어야 합니다.'),
      );
    });
  });
}
