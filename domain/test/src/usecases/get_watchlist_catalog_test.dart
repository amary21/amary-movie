import 'package:dartz/dartz.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistCatalog usecase;
  late MockMovieRepository mockMovieRepository;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    mockTvRepository = MockTvRepository();
    usecase = GetWatchlistCatalog(mockMovieRepository, mockTvRepository);
  });

  final tMovies = <Movie>[];
  final tTv = <Tv>[];
  final tCatalogItem = <CatalogItem>[];

  test('should get list of movies from the repository', () async {
    // arrange
    when(
      mockMovieRepository.getWatchlistMovies(),
    ).thenAnswer((_) async => Right(tMovies));
    // act
    final result = await usecase.execute(Catalog.movie);
    // assert
    expect(result.getOrElse(() => []), equals(tCatalogItem));
  });

    test('should get list of tv series from the repository', () async {
    // arrange
    when(
      mockTvRepository.getWatchlistTv(),
    ).thenAnswer((_) async => Right(tTv));
    // act
    final result = await usecase.execute(Catalog.tv);
    // assert
    expect(result.getOrElse(() => []), equals(tCatalogItem));
  });
}
