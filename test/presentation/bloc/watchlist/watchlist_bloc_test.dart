import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:common/common.dart';
import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/domain/usecases/get_watchlist_catalog.dart';
import 'package:ditonton/presentation/bloc/watchlist/watchlist_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist/watchlist_event.dart';
import 'package:ditonton/presentation/bloc/watchlist/watchlist_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'watchlist_bloc_test.mocks.dart';

class DummyWatchlistEvent extends WatchlistEvent {}

@GenerateMocks([GetWatchlistCatalog])
void main() {
  late WatchlistBloc watchlistBloc;
  late MockGetWatchlistCatalog mockGetWatchlistCatalog;

  setUp(() {
    mockGetWatchlistCatalog = MockGetWatchlistCatalog();
    watchlistBloc = WatchlistBloc(mockGetWatchlistCatalog);
  });

  test('initial state should be WatchlistEmpty', () {
    expect(watchlistBloc.state, WatchlistEmpty());
  });

  blocTest<WatchlistBloc, WatchlistState>(
    'emits [WatchlistLoading, WatchlistHasData] when fetch is successful',
    build: () {
      when(
        mockGetWatchlistCatalog.execute(Catalog.movie),
      ).thenAnswer((_) async => Right(testCatalogItemList));
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlist(Catalog.movie)),
    expect: () => [WatchlistLoading(), WatchlistHasData(testCatalogItemList)],
    verify: (_) {
      verify(mockGetWatchlistCatalog.execute(Catalog.movie)).called(1);
    },
  );

  blocTest<WatchlistBloc, WatchlistState>(
    'emits [WatchlistLoading, WatchlistError] when fetch fails',
    build: () {
      when(
        mockGetWatchlistCatalog.execute(Catalog.tv),
      ).thenAnswer((_) async => Left(ServerFailure('Server Error')));
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlist(Catalog.tv)),
    expect: () => [WatchlistLoading(), WatchlistError('Server Error')],
    verify: (_) {
      verify(mockGetWatchlistCatalog.execute(Catalog.tv)).called(1);
    },
  );

  test('FetchWatchlist props should match the values', () {
    final event = FetchWatchlist(Catalog.tv);
    expect(event.props, [Catalog.tv]);
  });

  test('WatchlistEvent default supports value comparison', () {
    expect(DummyWatchlistEvent(), equals(DummyWatchlistEvent()));
  });
}
