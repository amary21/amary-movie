import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/domain/entities/catalog_item.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetRecommendations usecase;
  late MockMovieRepository mockMovieRepository;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    mockTvRepository = MockTvRepository();
    usecase = GetRecommendations(mockMovieRepository, mockTvRepository);
  });

  final tId = 1;
  final tMovies = <Movie>[];
  final tTv = <Tv>[];
  final tCatalogItem = <CatalogItem>[];

  test(
    'should get list of movie recommendations from the repository',
    () async {
      // arrange
      when(
        mockMovieRepository.getMovieRecommendations(tId),
      ).thenAnswer((_) async => Right(tMovies));
      // act
      final result = await usecase.execute(Catalog.movie, tId);
      // assert
      expect(result.getOrElse(() => []), equals(tCatalogItem));
    },
  );

    test(
    'should get list of tv recommendations from the repository',
    () async {
      // arrange
      when(
        mockTvRepository.getTvRecommendations(tId),
      ).thenAnswer((_) async => Right(tTv));
      // act
      final result = await usecase.execute(Catalog.tv, tId);
      // assert
      expect(result.getOrElse(() => []), equals(tCatalogItem));
    },
  );
}
