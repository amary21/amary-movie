import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:ditonton/presentation/bloc/popular/popular_catalog_bloc.dart';
import 'package:ditonton/presentation/bloc/popular/popular_catalog_event.dart';
import 'package:ditonton/presentation/bloc/popular/popular_catalog_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'popular_catalog_bloc_test.mocks.dart';

class DummyPopularEvent extends PopularCatalogEvent {}

@GenerateMocks([GetPopular])
void main() {
  late PopularCatalogBloc bloc;
  late MockGetPopular mockGetPopular;

  setUp(() {
    mockGetPopular = MockGetPopular();
    bloc = PopularCatalogBloc(mockGetPopular);
  });

  blocTest<PopularCatalogBloc, PopularCatalogState>(
    'emits [Loading, HasData] when success',
    build: () {
      when(
        mockGetPopular.execute(Catalog.movie),
      ).thenAnswer((_) async => Right(testCatalogItemList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchPopularCatalog(Catalog.movie)),
    expect:
        () => [
          PopularCatalogLoading(),
          PopularCatalogHasData(testCatalogItemList),
        ],
    verify: (_) {
      verify(mockGetPopular.execute(Catalog.movie)).called(1);
    },
  );

  blocTest<PopularCatalogBloc, PopularCatalogState>(
    'emits [Loading, Error] when failed',
    build: () {
      when(
        mockGetPopular.execute(Catalog.tv),
      ).thenAnswer((_) async => Left(ServerFailure('Server error')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchPopularCatalog(Catalog.tv)),
    expect:
        () => [PopularCatalogLoading(), PopularCatalogError('Server error')],
    verify: (_) {
      verify(mockGetPopular.execute(Catalog.tv)).called(1);
    },
  );

  blocTest<PopularCatalogBloc, PopularCatalogState>(
    'emits [Loading, Empty] when empty',
    build: () {
      when(
        mockGetPopular.execute(Catalog.movie),
      ).thenAnswer((_) async => const Right([]));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchPopularCatalog(Catalog.movie)),
    expect: () => [PopularCatalogLoading(), const PopularCatalogHasData([])],
    verify: (_) {
      verify(mockGetPopular.execute(Catalog.movie)).called(1);
    },
  );

  test('FetchPopularCatalog props should match the values', () {
    final event = FetchPopularCatalog(Catalog.tv);
    expect(event.props, [Catalog.tv]);
  });
  
  test('PopularCatalogEvent default supports value comparison', () {
    expect(DummyPopularEvent(), equals(DummyPopularEvent()));
  });
}
