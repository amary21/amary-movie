import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/domain/entities/catalog_item.dart';
import 'package:ditonton/domain/usecases/search_catalog.dart';
import 'package:flutter/foundation.dart';

class CatalogSearchNotifier extends ChangeNotifier {
  final SearchCatalog searchCatalog;

  CatalogSearchNotifier({required this.searchCatalog});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<CatalogItem> _searchResult = [];
  List<CatalogItem> get searchResult => _searchResult;

  String _message = '';
  String get message => _message;

  Future<void> fetchCatalogSearch(Catalog catalog, String query) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await searchCatalog.execute(catalog, query);
    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (data) {
        _searchResult = data;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  resetData() {
    _searchResult = [];
    _state = RequestState.Empty;
    notifyListeners();
  }
}
