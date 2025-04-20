import 'package:dartz/dartz.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helpers/test_helper.mocks.dart';

void main() {
  late GetPopular usecase;
  late MockMovieRepository mockMovieRpository;
  late MockTvRepository mockTvRpository;

  setUp(() {
    mockMovieRpository = MockMovieRepository();
    mockTvRpository = MockTvRepository();
    usecase = GetPopular(mockMovieRpository, mockTvRpository);
  });

  final tMovies = <Movie>[
    Movie(
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
    )
  ];

  final tTv = <Tv>[
    Tv(
      adult: false,
      backdropPath: 'backdropPath',
      genreIds: [1, 2, 3],
      id: 1,
      originalName: 'originalTitle',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      firstAirDate: 'releaseDate',
      name: 'title',
      voteAverage: 1,
      voteCount: 1,
      originCountry: ['originCountry'],
      originalLanguage: 'originalLanguage',
    )
  ];

  final tCatalogItem = <CatalogItem>[
    CatalogItem(
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
    )
  ];

  group('Get Popular Tests', () {
    group('execute', () {
      test(
          'should get list of movies from the repository when execute function is called',
          () async {
        // arrange
        when(mockMovieRpository.getPopularMovies())
            .thenAnswer((_) async => Right(tMovies));
        // act
        final result = await usecase.execute(Catalog.movie);
        // assert
        expect(result.getOrElse(() => []), equals(tCatalogItem));
      });

      test(
          'should get list of tvs from the repository when execute function is called',
          () async {
        // arrange
        when(mockTvRpository.getPopularTv())
            .thenAnswer((_) async => Right(tTv));
        // act
        final result = await usecase.execute(Catalog.tv);
        // assert
        expect(result.getOrElse(() => []), equals(tCatalogItem));
      });
    });
  });
}
