import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/domain/entities/catalog_item.dart';
import 'package:ditonton/domain/usecases/get_now_playing.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_popular.dart';
import 'package:ditonton/domain/usecases/get_top_rated.dart';
import 'package:ditonton/presentation/provider/catalog_list_notifier.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'catalog_list_notifier_test.mocks.dart';

@GenerateMocks([GetNowPlaying, GetPopular, GetTopRated])
void main() {
  late CatalogListNotifier provider;
  late MockGetNowPlaying mockGetNowPlaying;
  late MockGetPopular mockGetPopular;
  late MockGetTopRated mockGetTopRatedMovies;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetNowPlaying = MockGetNowPlaying();
    mockGetPopular = MockGetPopular();
    mockGetTopRatedMovies = MockGetTopRated();
    provider = CatalogListNotifier(
      getNowPlaying: mockGetNowPlaying,
      getPopular: mockGetPopular,
      getTopRated: mockGetTopRatedMovies,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tCatalogItem = CatalogItem(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );
  final tCatalogItemList = <CatalogItem>[tCatalogItem];

  group('now playing catalog', () {
    test('initialState should be Empty', () {
      expect(provider.nowPlayingState, equals(RequestState.Empty));
    });

    test('should movie get data from the usecase', () async {
      // arrange
      when(mockGetNowPlaying.execute(Catalog.movie))
          .thenAnswer((_) async => Right(tCatalogItemList));
      // act
      provider.fetchNowPlaying(Catalog.movie);
      // assert
      verify(mockGetNowPlaying.execute(Catalog.movie));
    });

    test('should change movie state to Loading when usecase is called', () {
      // arrange
      when(mockGetNowPlaying.execute(Catalog.movie))
          .thenAnswer((_) async => Right(tCatalogItemList));
      // act
      provider.fetchNowPlaying(Catalog.movie);
      // assert
      expect(provider.nowPlayingState, RequestState.Loading);
      expect(provider.catalog, Catalog.movie);
    });

    test('should change movies when data is gotten successfully', () async {
      // arrange
      when(mockGetNowPlaying.execute(Catalog.movie))
          .thenAnswer((_) async => Right(tCatalogItemList));
      // act
      await provider.fetchNowPlaying(Catalog.movie);
      // assert
      expect(provider.nowPlayingState, RequestState.Loaded);
      expect(provider.nowPlaying, tCatalogItemList);
      expect(listenerCallCount, 2);
    });

    test('should movies return error when data is unsuccessful', () async {
      // arrange
      when(mockGetNowPlaying.execute(Catalog.movie))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchNowPlaying(Catalog.movie);
      // assert
      expect(provider.nowPlayingState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });

    test('should tv get data from the usecase', () async {
      // arrange
      when(mockGetNowPlaying.execute(Catalog.tv))
          .thenAnswer((_) async => Right(tCatalogItemList));
      // act
      provider.fetchNowPlaying(Catalog.tv);
      // assert
      verify(mockGetNowPlaying.execute(Catalog.tv));
    });

    test('should change tv state to Loading when usecase is called', () {
      // arrange
      when(mockGetNowPlaying.execute(Catalog.tv))
          .thenAnswer((_) async => Right(tCatalogItemList));
      // act
      provider.fetchNowPlaying(Catalog.tv);
      // assert
      expect(provider.nowPlayingState, RequestState.Loading);
      expect(provider.catalog, Catalog.tv);
    });

    test('should change tvs when data is gotten successfully', () async {
      // arrange
      when(mockGetNowPlaying.execute(Catalog.tv))
          .thenAnswer((_) async => Right(tCatalogItemList));
      // act
      await provider.fetchNowPlaying(Catalog.tv);
      // assert
      expect(provider.nowPlayingState, RequestState.Loaded);
      expect(provider.nowPlaying, tCatalogItemList);
      expect(listenerCallCount, 2);
    });

    test('should tvs return error when data is unsuccessful', () async {
      // arrange
      when(mockGetNowPlaying.execute(Catalog.tv))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchNowPlaying(Catalog.tv);
      // assert
      expect(provider.nowPlayingState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular catalog', () {
    test('should change movies state to loading when usecase is called', () async {
      // arrange
      when(mockGetPopular.execute(Catalog.movie))
          .thenAnswer((_) async => Right(tCatalogItemList));
      // act
      provider.fetchPopular(Catalog.movie);
      // assert
      expect(provider.popularState, RequestState.Loading);
    });

    test('should change movies data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetPopular.execute(Catalog.movie))
          .thenAnswer((_) async => Right(tCatalogItemList));
      // act
      await provider.fetchPopular(Catalog.movie);
      // assert
      expect(provider.popularState, RequestState.Loaded);
      expect(provider.popular, tCatalogItemList);
      expect(listenerCallCount, 2);
    });

    test('should movies return error when data is unsuccessful', () async {
      // arrange
      when(mockGetPopular.execute(Catalog.movie))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchPopular(Catalog.movie);
      // assert
      expect(provider.popularState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });

    test('should tv series change state to loading when usecase is called', () async {
      // arrange
      when(mockGetPopular.execute(Catalog.tv))
          .thenAnswer((_) async => Right(tCatalogItemList));
      // act
      provider.fetchPopular(Catalog.tv);
      // assert
      expect(provider.popularState, RequestState.Loading);
    });

    test('should change tv series data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetPopular.execute(Catalog.tv))
          .thenAnswer((_) async => Right(tCatalogItemList));
      // act
      await provider.fetchPopular(Catalog.tv);
      // assert
      expect(provider.popularState, RequestState.Loaded);
      expect(provider.popular, tCatalogItemList);
      expect(listenerCallCount, 2);
    });

    test('should tv series return error when data is unsuccessful', () async {
      // arrange
      when(mockGetPopular.execute(Catalog.tv))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchPopular(Catalog.tv);
      // assert
      expect(provider.popularState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated', () {
    test('should change movies state to loading when usecase is called', () async {
      // arrange
      when(mockGetTopRatedMovies.execute(Catalog.movie))
          .thenAnswer((_) async => Right(tCatalogItemList));
      // act
      provider.fetchTopRated(Catalog.movie);
      // assert
      expect(provider.topRatedState, RequestState.Loading);
    });

    test('should change movies data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetTopRatedMovies.execute(Catalog.movie))
          .thenAnswer((_) async => Right(tCatalogItemList));
      // act
      await provider.fetchTopRated(Catalog.movie);
      // assert
      expect(provider.topRatedState, RequestState.Loaded);
      expect(provider.topRated, tCatalogItemList);
      expect(listenerCallCount, 2);
    });

    test('should movies return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTopRatedMovies.execute(Catalog.movie))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTopRated(Catalog.movie);
      // assert
      expect(provider.topRatedState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });

    test('should change tv series state to loading when usecase is called', () async {
      // arrange
      when(mockGetTopRatedMovies.execute(Catalog.tv))
          .thenAnswer((_) async => Right(tCatalogItemList));
      // act
      provider.fetchTopRated(Catalog.tv);
      // assert
      expect(provider.topRatedState, RequestState.Loading);
    });

    test('should change tv series data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetTopRatedMovies.execute(Catalog.tv))
          .thenAnswer((_) async => Right(tCatalogItemList));
      // act
      await provider.fetchTopRated(Catalog.tv);
      // assert
      expect(provider.topRatedState, RequestState.Loaded);
      expect(provider.topRated, tCatalogItemList);
      expect(listenerCallCount, 2);
    });

    test('should tv series return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTopRatedMovies.execute(Catalog.tv))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTopRated(Catalog.tv);
      // assert
      expect(provider.topRatedState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
