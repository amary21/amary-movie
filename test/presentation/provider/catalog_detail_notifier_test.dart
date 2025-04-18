import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/domain/usecases/get_detail.dart';
import 'package:ditonton/domain/usecases/get_recommendations.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/provider/catalog_detail_notifier.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'catalog_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetDetail,
  GetRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late CatalogDetailNotifier provider;
  late MockGetDetail mockGetDetail;
  late MockGetRecommendations mockGetRecommendations;
  late MockGetWatchListStatus mockGetWatchlistStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetDetail = MockGetDetail();
    mockGetRecommendations = MockGetRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    provider = CatalogDetailNotifier(
      getDetail: mockGetDetail,
      getRecommendations: mockGetRecommendations,
      getWatchListStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tId = 1;

  void _arrangeUsecase() {
    when(mockGetDetail.execute(Catalog.movie, tId))
        .thenAnswer((_) async => Right(testCatalogDetail));
    when(mockGetRecommendations.execute(Catalog.movie, tId))
        .thenAnswer((_) async => Right(testCatalogItemList));
  }

  group('Get Movie Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchDetail(Catalog.movie, tId);
      // assert
      verify(mockGetDetail.execute(Catalog.movie, tId));
      verify(mockGetRecommendations.execute(Catalog.movie, tId));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      _arrangeUsecase();
      // act
      provider.fetchDetail(Catalog.movie, tId);
      // assert
      expect(provider.catalogState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change movie when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchDetail(Catalog.movie, tId);
      // assert
      expect(provider.catalogState, RequestState.Loaded);
      expect(provider.catalog, testCatalogDetail);
      expect(listenerCallCount, 3);
    });

    test('should change recommendation movies when data is gotten successfully',
        () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchDetail(Catalog.movie, tId);
      // assert
      expect(provider.catalogState, RequestState.Loaded);
      expect(provider.catalogRecommendations, testCatalogItemList);
    });
  });

  group('Get Movie Recommendations', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchDetail(Catalog.movie, tId);
      // assert
      verify(mockGetRecommendations.execute(Catalog.movie, tId));
      expect(provider.catalogRecommendations, testCatalogItemList);
    });

    test('should update recommendation state when data is gotten successfully',
        () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchDetail(Catalog.movie, tId);
      // assert
      expect(provider.recommendationState, RequestState.Loaded);
      expect(provider.catalogRecommendations, testCatalogItemList);
    });

    test('should update error message when request in successful', () async {
      // arrange
      when(mockGetDetail.execute(Catalog.movie, tId))
          .thenAnswer((_) async => Right(testCatalogDetail));
      when(mockGetRecommendations.execute(Catalog.movie, tId))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));
      // act
      await provider.fetchDetail(Catalog.movie, tId);
      // assert
      expect(provider.recommendationState, RequestState.Error);
      expect(provider.message, 'Failed');
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      // arrange
      when(mockGetWatchlistStatus.execute(1)).thenAnswer((_) async => true);
      // act
      await provider.loadWatchlistStatus(1);
      // assert
      expect(provider.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Right('Success'));
      when(mockGetWatchlistStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlist(testMovieDetail);
      // assert
      verify(mockSaveWatchlist.execute(testMovieDetail));
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      when(mockRemoveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Right('Removed'));
      when(mockGetWatchlistStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.removeFromWatchlist(testMovieDetail);
      // assert
      verify(mockRemoveWatchlist.execute(testMovieDetail));
    });

    test('should update watchlist status when add watchlist success', () async {
      // arrange
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchlistStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlist(testMovieDetail);
      // assert
      verify(mockGetWatchlistStatus.execute(testMovieDetail.id));
      expect(provider.isAddedToWatchlist, true);
      expect(provider.watchlistMessage, 'Added to Watchlist');
      expect(listenerCallCount, 1);
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchlistStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.addWatchlist(testMovieDetail);
      // assert
      expect(provider.watchlistMessage, 'Failed');
      expect(listenerCallCount, 1);
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetDetail.execute(Catalog.movie, tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetRecommendations.execute(Catalog.movie, tId))
          .thenAnswer((_) async => Right(testCatalogItemList));
      // act
      await provider.fetchDetail(Catalog.movie, tId);
      // assert
      expect(provider.catalogState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
