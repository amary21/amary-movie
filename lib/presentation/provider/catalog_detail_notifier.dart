import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/domain/entities/catalog_detail.dart';
import 'package:ditonton/domain/entities/catalog_item.dart';
import 'package:ditonton/domain/usecases/get_detail.dart';
import 'package:ditonton/domain/usecases/get_recommendations.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CatalogDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetDetail getDetail;
  final GetRecommendations getRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  CatalogDetailNotifier({
    required this.getDetail,
    required this.getRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  });

  late CatalogDetail _catalog;
  CatalogDetail get catalog => _catalog;

  RequestState _catalogState = RequestState.Empty;
  RequestState get catalogState => _catalogState;

  List<CatalogItem> _catalogRecommendations = [];
  List<CatalogItem> get catalogRecommendations => _catalogRecommendations;

  RequestState _recommendationState = RequestState.Empty;
  RequestState get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

  bool _isAddedtoWatchlist = false;
  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  Future<void> fetchDetail(Catalog catalog, int id) async {
    _catalogState = RequestState.Loading;
    notifyListeners();
    final detailResult = await getDetail.execute(catalog, id);
    final recommendationResult = await getRecommendations.execute(catalog, id);
    detailResult.fold(
      (failure) {
        _catalogState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _recommendationState = RequestState.Loading;
        _catalog = data;
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _recommendationState = RequestState.Error;
            _message = failure.message;
          },
          (data) {
            _recommendationState = RequestState.Loaded;
            _catalogRecommendations = data;
          },
        );
        _catalogState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> addWatchlist(
    Catalog catalog,
    CatalogDetail catalogDetail,
  ) async {
    final result = await saveWatchlist.execute(catalog, catalogDetail);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(catalog, catalogDetail.id);
  }

  Future<void> removeFromWatchlist(
    Catalog catalog,
    CatalogDetail catalogDetail,
  ) async {
    final result = await removeWatchlist.execute(catalog, catalogDetail);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(catalog, catalogDetail.id);
  }

  Future<void> loadWatchlistStatus(Catalog catalog, id) async {
    final result = await getWatchListStatus.execute(catalog, id);
    _isAddedtoWatchlist = result;
    notifyListeners();
  }
}
