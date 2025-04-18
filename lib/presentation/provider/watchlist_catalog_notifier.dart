import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/domain/entities/catalog_item.dart';
import 'package:ditonton/domain/usecases/get_watchlist_catalog.dart';
import 'package:flutter/foundation.dart';

class WatchlistCatalogNotifier extends ChangeNotifier {
  var _watchlistCatalog = <CatalogItem>[];
  List<CatalogItem> get watchlistCatalog => _watchlistCatalog;

  var _watchlistState = RequestState.Empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  WatchlistCatalogNotifier({required this.getWatchlistCatalog});

  final GetWatchlistCatalog getWatchlistCatalog;

  Future<void> fetchWatchlistMovies(Catalog catalog) async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistCatalog.execute(catalog);
    result.fold(
      (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _watchlistState = RequestState.Loaded;
        _watchlistCatalog = data;
        notifyListeners();
      },
    );
  }
}
