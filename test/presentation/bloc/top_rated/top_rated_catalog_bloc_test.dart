import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/domain/usecases/get_top_rated.dart';
import 'package:ditonton/presentation/bloc/top_rated/top_rated_catalog_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated/top_rated_catalog_event.dart';
import 'package:ditonton/presentation/bloc/top_rated/top_rated_catalog_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'top_rated_catalog_bloc_test.mocks.dart';

class DummyTopRatedEvent extends TopRatedCatalogEvent {}

@GenerateMocks([GetTopRated])
void main() {
  late TopRatedCatalogBloc bloc;
  late MockGetTopRated mockGetTopRated;

  setUp(() {
    mockGetTopRated = MockGetTopRated();
    bloc = TopRatedCatalogBloc(mockGetTopRated);
  });

  test('initial state should be TopRatedCatalogEmpty', () {
    expect(bloc.state, TopRatedCatalogEmpty());
  });

  blocTest<TopRatedCatalogBloc, TopRatedCatalogState>(
    'emits [Loading, HasData] when data is fetched successfully',
    build: () {
      when(
        mockGetTopRated.execute(Catalog.movie),
      ).thenAnswer((_) async => Right(testCatalogItemList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedCatalog(Catalog.movie)),
    expect:
        () => [
          TopRatedCatalogLoading(),
          TopRatedCatalogHasData(testCatalogItemList),
        ],
    verify: (_) {
      verify(mockGetTopRated.execute(Catalog.movie)).called(1);
    },
  );

  blocTest<TopRatedCatalogBloc, TopRatedCatalogState>(
    'emits [Loading, Error] when fetching data fails',
    build: () {
      when(
        mockGetTopRated.execute(Catalog.tv),
      ).thenAnswer((_) async => Left(ServerFailure('Server error')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedCatalog(Catalog.tv)),
    expect:
        () => [TopRatedCatalogLoading(), TopRatedCatalogError('Server error')],
    verify: (_) {
      verify(mockGetTopRated.execute(Catalog.tv)).called(1);
    },
  );

  test('FetchWatchlist props should match the values', () {
    final event = FetchTopRatedCatalog(Catalog.tv);
    expect(event.props, [Catalog.tv]);
  });

  test('TopRatedEvent default supports value comparison', () {
    expect(DummyTopRatedEvent(), equals(DummyTopRatedEvent()));
  });
}
