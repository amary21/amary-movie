import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/domain/entities/catalog_item.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/search_catalog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late SearchCatalog usecase;
  late MockMovieRepository mockMovieRepository;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    mockTvRepository = MockTvRepository();
    usecase = SearchCatalog(mockMovieRepository, mockTvRepository);
  });

  final tMovies = <Movie>[];
  final tTv = <Tv>[];
  final tCatalogItem = <CatalogItem>[];
  final tQuery = 'Spiderman';

  test('should get list of movies from the repository', () async {
    // arrange
    when(
      mockMovieRepository.searchMovies(tQuery),
    ).thenAnswer((_) async => Right(tMovies));
    // act
    final result = await usecase.execute(Catalog.movie, tQuery);
    // assert
    expect(result.getOrElse(() => []), equals(tCatalogItem));
  });

  test('should get list of tv from the repository', () async {
    // arrange
    when(
      mockTvRepository.searchTv(tQuery),
    ).thenAnswer((_) async => Right(tTv));
    // act
    final result = await usecase.execute(Catalog.tv, tQuery);
    // assert
    expect(result.getOrElse(() => []), equals(tCatalogItem));
  });
}
