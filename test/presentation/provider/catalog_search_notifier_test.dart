import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/domain/entities/catalog_item.dart';
import 'package:ditonton/domain/usecases/search_catalog.dart';
import 'package:ditonton/presentation/provider/catalog_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'catalog_search_notifier_test.mocks.dart';

@GenerateMocks([SearchCatalog])
void main() {
  late CatalogSearchNotifier provider;
  late MockSearchCatalog mockSearchCatalog;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchCatalog = MockSearchCatalog();
    provider = CatalogSearchNotifier(searchCatalog: mockSearchCatalog)
      ..addListener(() {
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
  final tQuery = 'spiderman';

  group('search catalog', () {
    test(
      'should change movie state to loading when usecase is called',
      () async {
        // arrange
        when(
          mockSearchCatalog.execute(Catalog.movie, tQuery),
        ).thenAnswer((_) async => Right(tCatalogItemList));
        // act
        provider.fetchCatalogSearch(Catalog.movie, tQuery);
        // assert
        expect(provider.state, RequestState.Loading);
      },
    );

    test(
      'should change search movie result data when data is gotten successfully',
      () async {
        // arrange
        when(
          mockSearchCatalog.execute(Catalog.movie, tQuery),
        ).thenAnswer((_) async => Right(tCatalogItemList));
        // act
        await provider.fetchCatalogSearch(Catalog.movie, tQuery);
        // assert
        expect(provider.state, RequestState.Loaded);
        expect(provider.searchResult, tCatalogItemList);
        expect(listenerCallCount, 2);
      },
    );

    test('should movie return error when data is unsuccessful', () async {
      // arrange
      when(
        mockSearchCatalog.execute(Catalog.movie, tQuery),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchCatalogSearch(Catalog.movie, tQuery);
      // assert
      expect(provider.state, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });

    test(
      'should change movie state to loading when usecase is called',
      () async {
        // arrange
        when(
          mockSearchCatalog.execute(Catalog.tv, tQuery),
        ).thenAnswer((_) async => Right(tCatalogItemList));
        // act
        provider.fetchCatalogSearch(Catalog.tv, tQuery);
        // assert
        expect(provider.state, RequestState.Loading);
      },
    );

    test(
      'should change search tv result data when data is gotten successfully',
      () async {
        // arrange
        when(
          mockSearchCatalog.execute(Catalog.tv, tQuery),
        ).thenAnswer((_) async => Right(tCatalogItemList));
        // act
        await provider.fetchCatalogSearch(Catalog.tv, tQuery);
        // assert
        expect(provider.state, RequestState.Loaded);
        expect(provider.searchResult, tCatalogItemList);
        expect(listenerCallCount, 2);
      },
    );

    test('should tv return error when data is unsuccessful', () async {
      // arrange
      when(
        mockSearchCatalog.execute(Catalog.tv, tQuery),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchCatalogSearch(Catalog.tv, tQuery);
      // assert
      expect(provider.state, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });

    test('reset search catalog', () async {
      // arrange
      when(
        mockSearchCatalog.execute(Catalog.movie, tQuery),
      ).thenAnswer((_) async => Right(tCatalogItemList));

      // act
      await provider.fetchCatalogSearch(Catalog.movie, tQuery);
      await provider.resetData();

      // assert
      expect(provider.state, RequestState.Empty);
      expect(provider.searchResult, isEmpty);
    });
  });
}
