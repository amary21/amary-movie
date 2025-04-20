import 'package:dartz/dartz.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helpers/test_helper.dart';
import '../helpers/test_helper.mocks.dart';

void main() {
  late GetDetail usecase;
  late MockMovieRepository mockMovieRepository;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    mockTvRepository = MockTvRepository();
    usecase = GetDetail(mockMovieRepository, mockTvRepository);
  });

  final tId = 1;

  test('should get movie detail from the repository', () async {
    // arrange
    when(
      mockMovieRepository.getMovieDetail(tId),
    ).thenAnswer((_) async => Right(testMovieDetail));
    // act
    final result = await usecase.execute(Catalog.movie, tId);
    // assert
    expect(result, Right(testCatalogDetail));
  });

  test('should get tv detail from the repository', () async {
    // arrange
    when(
      mockTvRepository.getTvDetail(tId),
    ).thenAnswer((_) async => Right(testTvDetail));
    // act
    final result = await usecase.execute(Catalog.tv, tId);
    // assert
    expect(result, Right(testCatalogDetail));
  });
}
