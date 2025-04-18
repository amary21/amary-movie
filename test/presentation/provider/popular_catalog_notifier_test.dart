import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/domain/entities/catalog_item.dart';
import 'package:ditonton/domain/usecases/get_popular.dart';
import 'package:ditonton/presentation/provider/popular_catalog_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_catalog_notifier_test.mocks.dart';

@GenerateMocks([GetPopular])
void main() {
  late MockGetPopular mockGetPopular;
  late PopularCatalogNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetPopular = MockGetPopular();
    notifier = PopularCatalogNotifier(mockGetPopular)
      ..addListener(() {
        listenerCallCount++;
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

  test('should change movie state to loading when usecase is called', () async {
    // arrange
    when(mockGetPopular.execute(Catalog.movie))
        .thenAnswer((_) async => Right(tCatalogItemList));
    // act
    notifier.fetchPopular(Catalog.movie);
    // assert
    expect(notifier.state, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should change movies data when data is gotten successfully', () async {
    // arrange
    when(mockGetPopular.execute(Catalog.movie))
        .thenAnswer((_) async => Right(tCatalogItemList));
    // act
    await notifier.fetchPopular(Catalog.movie);
    // assert
    expect(notifier.state, RequestState.Loaded);
    expect(notifier.catalogItem, tCatalogItemList);
    expect(listenerCallCount, 2);
  });

  test('should movie return error when data is unsuccessful', () async {
    // arrange
    when(mockGetPopular.execute(Catalog.movie))
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchPopular(Catalog.movie);
    // assert
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });

  test('should change tv state to loading when usecase is called', () async {
    // arrange
    when(mockGetPopular.execute(Catalog.tv))
        .thenAnswer((_) async => Right(tCatalogItemList));
    // act
    notifier.fetchPopular(Catalog.tv);
    // assert
    expect(notifier.state, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should change tv data when data is gotten successfully', () async {
    // arrange
    when(mockGetPopular.execute(Catalog.tv))
        .thenAnswer((_) async => Right(tCatalogItemList));
    // act
    await notifier.fetchPopular(Catalog.tv);
    // assert
    expect(notifier.state, RequestState.Loaded);
    expect(notifier.catalogItem, tCatalogItemList);
    expect(listenerCallCount, 2);
  });

  test('should tv return error when data is unsuccessful', () async {
    // arrange
    when(mockGetPopular.execute(Catalog.tv))
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchPopular(Catalog.tv);
    // assert
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
