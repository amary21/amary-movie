import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/domain/usecases/get_now_playing.dart';
import 'package:ditonton/domain/usecases/get_popular.dart';
import 'package:ditonton/domain/usecases/get_top_rated.dart';
import 'package:ditonton/presentation/bloc/home/catalog_category_state.dart';
import 'package:ditonton/presentation/bloc/home/catalog_list_bloc.dart';
import 'package:ditonton/presentation/bloc/home/catalog_list_event.dart';
import 'package:ditonton/presentation/bloc/home/catalog_list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'catalog_list_bloc_test.mocks.dart';

class DummyCatalogListEvent extends CatalogListEvent {}

@GenerateMocks([GetNowPlaying, GetPopular, GetTopRated])
void main() {
  late CatalogListBloc bloc;
  late MockGetNowPlaying mockNowPlaying;
  late MockGetPopular mockPopular;
  late MockGetTopRated mockTopRated;

  setUp(() {
    mockNowPlaying = MockGetNowPlaying();
    mockPopular = MockGetPopular();
    mockTopRated = MockGetTopRated();

    bloc = CatalogListBloc(
      getNowPlaying: mockNowPlaying,
      getPopular: mockPopular,
      getTopRated: mockTopRated,
    );
  });

  blocTest<CatalogListBloc, CatalogListState>(
    'emits [loading, nowPlayingLoaded, popularLoaded, topRatedLoaded] when all fetch succeed',
    build: () {
      when(
        mockNowPlaying.execute(Catalog.movie),
      ).thenAnswer((_) async => Right(testCatalogItemList));
      when(
        mockPopular.execute(Catalog.movie),
      ).thenAnswer((_) async => Right(testCatalogItemList));
      when(
        mockTopRated.execute(Catalog.movie),
      ).thenAnswer((_) async => Right(testCatalogItemList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchCatalogList(Catalog.movie)),
    expect:
        () => [
          isA<CatalogListState>()
              .having(
                (s) => s.nowPlaying,
                'nowPlaying',
                isA<CatalogCategoryLoading>(),
              )
              .having(
                (s) => s.popular,
                'popular',
                isA<CatalogCategoryLoading>(),
              )
              .having(
                (s) => s.topRated,
                'topRated',
                isA<CatalogCategoryLoading>(),
              ),

          isA<CatalogListState>()
              .having(
                (s) => s.nowPlaying,
                'nowPlaying',
                isA<CatalogCategoryLoaded>(),
              )
              .having(
                (s) => (s.nowPlaying as CatalogCategoryLoaded).items,
                'nowPlayingItems',
                testCatalogItemList,
              ),

          isA<CatalogListState>()
              .having((s) => s.popular, 'popular', isA<CatalogCategoryLoaded>())
              .having(
                (s) => (s.popular as CatalogCategoryLoaded).items,
                'popularItems',
                testCatalogItemList,
              ),

          isA<CatalogListState>()
              .having(
                (s) => s.topRated,
                'topRated',
                isA<CatalogCategoryLoaded>(),
              )
              .having(
                (s) => (s.topRated as CatalogCategoryLoaded).items,
                'topRatedItems',
                testCatalogItemList,
              ),
        ],
    verify: (_) {
      verify(mockNowPlaying.execute(Catalog.movie)).called(1);
      verify(mockPopular.execute(Catalog.movie)).called(1);
      verify(mockTopRated.execute(Catalog.movie)).called(1);
    },
  );

  blocTest<CatalogListBloc, CatalogListState>(
    'emits error state when all fails',
    build: () {
      when(
        mockNowPlaying.execute(Catalog.tv),
      ).thenAnswer((_) async => Left(ServerFailure('Failed')));
      when(
        mockPopular.execute(Catalog.tv),
      ).thenAnswer((_) async => Left(ServerFailure('Failed')));
      when(
        mockTopRated.execute(Catalog.tv),
      ).thenAnswer((_) async => Left(ServerFailure('Failed')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchCatalogList(Catalog.tv)),
    expect:
        () => [
          isA<CatalogListState>()
              .having(
                (s) => s.nowPlaying,
                'nowPlaying',
                isA<CatalogCategoryLoading>(),
              )
              .having(
                (s) => s.popular,
                'popular',
                isA<CatalogCategoryLoading>(),
              )
              .having(
                (s) => s.topRated,
                'topRated',
                isA<CatalogCategoryLoading>(),
              ),

          isA<CatalogListState>()
              .having(
                (s) => s.nowPlaying,
                'nowPlaying',
                isA<CatalogCategoryError>(),
              )
              .having(
                (s) => (s.nowPlaying as CatalogCategoryError).message,
                'message',
                'Failed',
              ),

          isA<CatalogListState>()
              .having(
                (s) => s.popular,
                'popular',
                isA<CatalogCategoryError>(),
              )
              .having(
                (s) => (s.popular as CatalogCategoryError).message,
                'message',
                'Failed',
              ),

          isA<CatalogListState>()
              .having(
                (s) => s.topRated,
                'topRated',
                isA<CatalogCategoryError>(),
              )
              .having(
                (s) => (s.topRated as CatalogCategoryError).message,
                'message',
                'Failed',
              ),
        ],
    verify: (_) {
      verify(mockNowPlaying.execute(Catalog.tv)).called(1);
      verify(mockPopular.execute(Catalog.tv)).called(1);
      verify(mockTopRated.execute(Catalog.tv)).called(1);
    },
  );

  test('CatalogListEvent props should match the values', () {
    final event = FetchCatalogList(Catalog.tv);
    expect(event.props, [Catalog.tv]);
  });

  test('CatalogListEvent default supports value comparison', () {
    expect(DummyCatalogListEvent(), equals(DummyCatalogListEvent()));
  });
}
