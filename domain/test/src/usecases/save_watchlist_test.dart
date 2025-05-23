import 'package:dartz/dartz.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helpers/test_helper.dart';
import '../helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchlist usecase;
  late MockMovieRepository mockMovieRepository;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    mockTvRepository = MockTvRepository();
    usecase = SaveWatchlist(mockMovieRepository, mockTvRepository);
  });

  test('should save movie to the repository', () async {
    // arrange
    when(
      mockMovieRepository.saveWatchlist(testMovieDetail),
    ).thenAnswer((_) async => Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(Catalog.movie, testCatalogDetail);
    // assert
    verify(mockMovieRepository.saveWatchlist(testMovieDetail));
    expect(result, Right('Added to Watchlist'));
  });

  test('should save tv to the repository', () async {
    // arrange
    final tvDetail = testCatalogDetail.toTvDetail();
    when(
      mockTvRepository.saveWatchlist(tvDetail),
    ).thenAnswer((_) async => Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(Catalog.tv, testCatalogDetail);
    // assert
    verify(mockTvRepository.saveWatchlist(tvDetail));
    expect(result, Right('Added to Watchlist'));
  });
}
