import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:ditonton/presentation/bloc/detail/catalog_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/detail/catalog_detail_event.dart';
import 'package:ditonton/presentation/bloc/detail/catalog_detail_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'catalog_detail_bloc_test.mocks.dart';

class DummyCatalogDetailEvent extends CatalogDetailEvent {}

@GenerateMocks([
  GetDetail,
  GetRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late CatalogDetailBloc bloc;
  late MockGetDetail mockGetDetail;
  late MockGetRecommendations mockGetRecommendations;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  final tId = 1;
  final tCatalog = Catalog.movie;

  setUp(() {
    mockGetDetail = MockGetDetail();
    mockGetRecommendations = MockGetRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();

    bloc = CatalogDetailBloc(
      getDetail: mockGetDetail,
      getRecommendations: mockGetRecommendations,
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  blocTest<CatalogDetailBloc, CatalogDetailState>(
    'emits [Loading, HasData] when FetchCatalogDetail is successful',
    build: () {
      when(
        mockGetDetail.execute(tCatalog, tId),
      ).thenAnswer((_) async => Right(testCatalogDetail));
      when(
        mockGetRecommendations.execute(tCatalog, tId),
      ).thenAnswer((_) async => Right([testCatalogItem]));
      when(
        mockGetWatchListStatus.execute(tCatalog, tId),
      ).thenAnswer((_) async => false);
      return bloc;
    },
    act: (bloc) => bloc.add(FetchCatalogDetail(tCatalog, tId)),
    expect:
        () => [
          CatalogDetailLoading(),
          CatalogDetailHasData(
            catalogDetail: testCatalogDetail,
            recommendations: [testCatalogItem],
            isAddedToWatchlist: false,
            message: '',
          ),
        ],
  );

  blocTest<CatalogDetailBloc, CatalogDetailState>(
    'emits [Error] when GetDetail fails',
    build: () {
      when(
        mockGetDetail.execute(tCatalog, tId),
      ).thenAnswer((_) async => Left(ServerFailure('Failed to fetch')));
      when(
        mockGetRecommendations.execute(tCatalog, tId),
      ).thenAnswer((_) async => Right([]));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchCatalogDetail(tCatalog, tId)),
    expect:
        () => [
          CatalogDetailLoading(),
          const CatalogDetailError('Failed to fetch'),
        ],
  );

  blocTest<CatalogDetailBloc, CatalogDetailState>(
    'emits HasData with empty recommendations and error message when GetRecommendations fails',
    build: () {
      when(
        mockGetDetail.execute(tCatalog, tId),
      ).thenAnswer((_) async => Right(testCatalogDetail));
      when(
        mockGetRecommendations.execute(tCatalog, tId),
      ).thenAnswer((_) async => Left(ServerFailure('Recommendation failed')));
      when(
        mockGetWatchListStatus.execute(tCatalog, tId),
      ).thenAnswer((_) async => false);
      return bloc;
    },
    act: (bloc) => bloc.add(FetchCatalogDetail(tCatalog, tId)),
    expect:
        () => [
          CatalogDetailLoading(),
          CatalogDetailHasData(
            catalogDetail: testCatalogDetail,
            recommendations: [],
            isAddedToWatchlist: false,
            message: 'Recommendation failed',
          ),
        ],
  );

  blocTest<CatalogDetailBloc, CatalogDetailState>(
    'emits WatchlistMessage when AddToWatchlist succeeds',
    build: () {
      when(
        mockSaveWatchlist.execute(tCatalog, testCatalogDetail),
      ).thenAnswer((_) async => const Right('Added to Watchlist'));
      when(
        mockGetWatchListStatus.execute(tCatalog, testCatalogDetail.id),
      ).thenAnswer((_) async => true);
      return bloc;
    },
    act:
        (bloc) => bloc.add(
          AddToWatchlist(tCatalog, testCatalogDetail, testCatalogItemList),
        ),
    expect:
        () => [
          CatalogDetailWatchlistMessage('Added to Watchlist'),
          CatalogDetailHasData(
            catalogDetail: testCatalogDetail,
            recommendations: [testCatalogItem],
            isAddedToWatchlist: true,
            message: '',
          ),
        ],
  );

  blocTest<CatalogDetailBloc, CatalogDetailState>(
    'emits WatchlistMessage when AddToWatchlist fails',
    build: () {
      when(
        mockSaveWatchlist.execute(tCatalog, testCatalogDetail),
      ).thenAnswer((_) async => Left(ServerFailure('Add failed')));
      when(
        mockGetWatchListStatus.execute(tCatalog, testCatalogDetail.id),
      ).thenAnswer((_) async => false);
      return bloc;
    },
    act:
        (bloc) => bloc.add(
          AddToWatchlist(tCatalog, testCatalogDetail, testCatalogItemList),
        ),
    expect: () => [const CatalogDetailWatchlistMessage('Add failed')],
  );

  blocTest<CatalogDetailBloc, CatalogDetailState>(
    'emits [WatchlistMessage] when removing from watchlist is successful',
    build: () {
      when(
        mockRemoveWatchlist.execute(tCatalog, testCatalogDetail),
      ).thenAnswer((_) async => const Right('Removed from Watchlist'));
      when(
        mockGetWatchListStatus.execute(tCatalog, testCatalogDetail.id),
      ).thenAnswer((_) async => false);
      return bloc;
    },
    act:
        (bloc) => bloc.add(
          RemoveFromWatchlist(tCatalog, testCatalogDetail, testCatalogItemList),
        ),
    expect:
        () => [
          CatalogDetailWatchlistMessage('Removed from Watchlist'),
          CatalogDetailHasData(
            catalogDetail: testCatalogDetail,
            recommendations: [testCatalogItem],
            isAddedToWatchlist: false,
            message: '',
          ),
        ],
  );

  blocTest<CatalogDetailBloc, CatalogDetailState>(
    'emits [WatchlistMessage with error] when RemoveFromWatchlist fails',
    build: () {
      when(
        mockRemoveWatchlist.execute(tCatalog, testCatalogDetail),
      ).thenAnswer((_) async => Left(ServerFailure('Remove failed')));
      when(
        mockGetWatchListStatus.execute(tCatalog, testCatalogDetail.id),
      ).thenAnswer((_) async => false);
      return bloc;
    },
    act:
        (bloc) => bloc.add(
          RemoveFromWatchlist(tCatalog, testCatalogDetail, testCatalogItemList),
        ),
    expect: () => [const CatalogDetailWatchlistMessage('Remove failed')],
  );

  blocTest<CatalogDetailBloc, CatalogDetailState>(
    'does not emit new state when LoadWatchlistStatus is called without HasData state',
    build: () {
      when(
        mockGetWatchListStatus.execute(tCatalog, tId),
      ).thenAnswer((_) async => true);
      return bloc;
    },
    seed: () => CatalogDetailLoading(),
    act: (bloc) => bloc.add(LoadWatchlistStatus(tCatalog, tId)),
    expect: () => [],
  );

  blocTest<CatalogDetailBloc, CatalogDetailState>(
    'updates isAddedToWatchlist when LoadWatchlistStatus is triggered with HasData',
    build: () {
      when(
        mockGetWatchListStatus.execute(tCatalog, tId),
      ).thenAnswer((_) async => true);
      return bloc;
    },
    seed:
        () => CatalogDetailHasData(
          catalogDetail: testCatalogDetail,
          recommendations: [testCatalogItem],
          isAddedToWatchlist: false,
          message: '',
        ),
    act: (bloc) => bloc.add(LoadWatchlistStatus(tCatalog, tId)),
    expect:
        () => [
          CatalogDetailHasData(
            catalogDetail: testCatalogDetail,
            recommendations: [testCatalogItem],
            isAddedToWatchlist: true,
            message: '',
          ),
        ],
  );

  blocTest<CatalogDetailBloc, CatalogDetailState>(
    'does not emit state when LoadWatchlistStatus does not change value',
    build: () {
      when(
        mockGetWatchListStatus.execute(tCatalog, tId),
      ).thenAnswer((_) async => false);
      return bloc;
    },
    seed:
        () => CatalogDetailHasData(
          catalogDetail: testCatalogDetail,
          recommendations: [testCatalogItem],
          isAddedToWatchlist: false,
          message: '',
        ),
    act: (bloc) => bloc.add(LoadWatchlistStatus(tCatalog, tId)),
    expect: () => [],
    verify: (_) {
      verify(mockGetWatchListStatus.execute(tCatalog, tId)).called(1);
    },
  );

  test(
    'CatalogDetailHasData.copyWith should override isAddedToWatchlist only',
    () {
      final initialState = CatalogDetailHasData(
        catalogDetail: testCatalogDetail,
        recommendations: [testCatalogItem],
        isAddedToWatchlist: false,
        message: 'original',
      );

      final copied = initialState.copyWith(isAddedToWatchlist: true);

      expect(copied.isAddedToWatchlist, true);
      expect(copied.catalogDetail, testCatalogDetail);
      expect(copied.recommendations, [testCatalogItem]);
      expect(copied.message, 'original');
    },
  );

  test('AddToWatchlist props should match the values', () {
    final event = AddToWatchlist(
      Catalog.tv,
      testCatalogDetail,
      testCatalogItemList,
    );
    expect(event.props, [Catalog.tv, testCatalogDetail, testCatalogItemList]);
  });

  test('DummyCatalogDetailEvent default supports value comparison', () {
    expect(DummyCatalogDetailEvent(), equals(DummyCatalogDetailEvent()));
  });

  test('FetchCatalogDetail props should match the values', () {
    final event = FetchCatalogDetail(Catalog.tv, tId);
    expect(event.props, [Catalog.tv, tId]);
  });

  test('RemoveFromWatchlist default supports value comparison', () {
    final event = RemoveFromWatchlist(
      Catalog.tv,
      testCatalogDetail,
      testCatalogItemList,
    );
    expect(event.props, [Catalog.tv, testCatalogDetail, testCatalogItemList]);
  });

  test('LoadWatchlistStatus default supports value comparison', () {
    final event = LoadWatchlistStatus(Catalog.tv, tId);
    expect(event.props, [Catalog.tv, tId]);
  });
}
