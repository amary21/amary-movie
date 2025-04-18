import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/now_playing.dart';
import 'package:ditonton/domain/usecases/get_now_playing.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_list_notifier_test.mocks.dart';

@GenerateMocks([GetNowPlaying, GetPopularMovies, GetTopRatedMovies])
void main() {
  late MovieListNotifier provider;
  late MockGetNowPlaying mockGetNowPlaying;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetNowPlaying = MockGetNowPlaying();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    provider = MovieListNotifier(
      getNowPlaying: mockGetNowPlaying,
      getPopularMovies: mockGetPopularMovies,
      getTopRatedMovies: mockGetTopRatedMovies,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tNowPlaying = NowPlaying(
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
  final tNowPlayingList = <NowPlaying>[tNowPlaying];

  final tMovie = Movie(
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
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovieList = <Movie>[tMovie];

  group('now playing movies', () {
    test('initialState should be Empty', () {
      expect(provider.nowPlayingState, equals(RequestState.Empty));
    });

    test('should movie get data from the usecase', () async {
      // arrange
      when(mockGetNowPlaying.execute(Catalog.movie))
          .thenAnswer((_) async => Right(tNowPlayingList));
      // act
      provider.fetchNowPlaying(Catalog.movie);
      // assert
      verify(mockGetNowPlaying.execute(Catalog.movie));
    });

    test('should change movie state to Loading when usecase is called', () {
      // arrange
      when(mockGetNowPlaying.execute(Catalog.movie))
          .thenAnswer((_) async => Right(tNowPlayingList));
      // act
      provider.fetchNowPlaying(Catalog.movie);
      // assert
      expect(provider.nowPlayingState, RequestState.Loading);
    });

    test('should change movies when data is gotten successfully', () async {
      // arrange
      when(mockGetNowPlaying.execute(Catalog.movie))
          .thenAnswer((_) async => Right(tNowPlayingList));
      // act
      await provider.fetchNowPlaying(Catalog.movie);
      // assert
      expect(provider.nowPlayingState, RequestState.Loaded);
      expect(provider.nowPlaying, tNowPlayingList);
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
          .thenAnswer((_) async => Right(tNowPlayingList));
      // act
      provider.fetchNowPlaying(Catalog.tv);
      // assert
      verify(mockGetNowPlaying.execute(Catalog.tv));
    });

    test('should change tv state to Loading when usecase is called', () {
      // arrange
      when(mockGetNowPlaying.execute(Catalog.tv))
          .thenAnswer((_) async => Right(tNowPlayingList));
      // act
      provider.fetchNowPlaying(Catalog.tv);
      // assert
      expect(provider.nowPlayingState, RequestState.Loading);
    });

    test('should change tvs when data is gotten successfully', () async {
      // arrange
      when(mockGetNowPlaying.execute(Catalog.tv))
          .thenAnswer((_) async => Right(tNowPlayingList));
      // act
      await provider.fetchNowPlaying(Catalog.tv);
      // assert
      expect(provider.nowPlayingState, RequestState.Loaded);
      expect(provider.nowPlaying, tNowPlayingList);
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

  group('popular movies', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      // act
      provider.fetchPopularMovies();
      // assert
      expect(provider.popularMoviesState, RequestState.Loading);
      // verify(provider.setState(RequestState.Loading));
    });

    test('should change movies data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      // act
      await provider.fetchPopularMovies();
      // assert
      expect(provider.popularMoviesState, RequestState.Loaded);
      expect(provider.popularMovies, tMovieList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchPopularMovies();
      // assert
      expect(provider.popularMoviesState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated movies', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      // act
      provider.fetchTopRatedMovies();
      // assert
      expect(provider.topRatedMoviesState, RequestState.Loading);
    });

    test('should change movies data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      // act
      await provider.fetchTopRatedMovies();
      // assert
      expect(provider.topRatedMoviesState, RequestState.Loaded);
      expect(provider.topRatedMovies, tMovieList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTopRatedMovies();
      // assert
      expect(provider.topRatedMoviesState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
