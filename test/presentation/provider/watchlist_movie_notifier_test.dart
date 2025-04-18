import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/domain/usecases/get_watchlist_catalog.dart';
import 'package:ditonton/presentation/provider/watchlist_catalog_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_movie_notifier_test.mocks.dart';

@GenerateMocks([GetWatchlistCatalog])
void main() {
  late WatchlistCatalogNotifier provider;
  late MockGetWatchlistCatalog mockGetWatchlistCatalog;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetWatchlistCatalog = MockGetWatchlistCatalog();
    provider = WatchlistCatalogNotifier(
      getWatchlistCatalog: mockGetWatchlistCatalog,
    )..addListener(() {
      listenerCallCount += 1;
    });
  });

  test('should change movies data when data is gotten successfully', () async {
    // arrange
    when(
      mockGetWatchlistCatalog.execute(Catalog.movie),
    ).thenAnswer((_) async => Right([testCatalogItem]));
    // act
    await provider.fetchWatchlistMovies(Catalog.movie);
    // assert
    expect(provider.watchlistState, RequestState.Loaded);
    expect(provider.watchlistCatalog, [testCatalogItem]);
    expect(listenerCallCount, 2);
  });

  test('should movies return error when data is unsuccessful', () async {
    // arrange
    when(
      mockGetWatchlistCatalog.execute(Catalog.movie),
    ).thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
    // act
    await provider.fetchWatchlistMovies(Catalog.movie);
    // assert
    expect(provider.watchlistState, RequestState.Error);
    expect(provider.message, "Can't get data");
    expect(listenerCallCount, 2);
  });

  test(
    'should change tv series data when data is gotten successfully',
    () async {
      // arrange
      when(
        mockGetWatchlistCatalog.execute(Catalog.tv),
      ).thenAnswer((_) async => Right([testCatalogItem]));
      // act
      await provider.fetchWatchlistMovies(Catalog.tv);
      // assert
      expect(provider.watchlistState, RequestState.Loaded);
      expect(provider.watchlistCatalog, [testCatalogItem]);
      expect(listenerCallCount, 2);
    },
  );

  test('should tv series return error when data is unsuccessful', () async {
    // arrange
    when(
      mockGetWatchlistCatalog.execute(Catalog.tv),
    ).thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
    // act
    await provider.fetchWatchlistMovies(Catalog.tv);
    // assert
    expect(provider.watchlistState, RequestState.Error);
    expect(provider.message, "Can't get data");
    expect(listenerCallCount, 2);
  });
}
