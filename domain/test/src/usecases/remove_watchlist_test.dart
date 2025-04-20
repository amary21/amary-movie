import 'package:dartz/dartz.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helpers/test_helper.dart';
import '../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlist usecase;
  late MockMovieRepository mockMovieRepository;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    mockTvRepository = MockTvRepository();

    usecase = RemoveWatchlist(mockMovieRepository, mockTvRepository);
  });

  test('should remove watchlist movie from repository', () async {
    // arrange
    when(mockMovieRepository.removeWatchlist(testMovieDetail))
        .thenAnswer((_) async => Right('Removed from watchlist'));
    // act
    final result = await usecase.execute(Catalog.movie, testCatalogDetail);
    // assert
    verify(mockMovieRepository.removeWatchlist(testMovieDetail));
    expect(result, Right('Removed from watchlist'));
  });

  test('should remove watchlist tv from repository', () async {
    // arrange
    final tvDetail = testCatalogDetail.toTvDetail();
    when(mockTvRepository.removeWatchlist(tvDetail))
        .thenAnswer((_) async => Right('Removed from watchlist'));
    // act
    final result = await usecase.execute(Catalog.tv, testCatalogDetail);
    // assert
    verify(mockTvRepository.removeWatchlist(tvDetail));
    expect(result, Right('Removed from watchlist'));
  });
}
