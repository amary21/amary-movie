import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/domain/entities/catalog_item.dart';
import 'package:ditonton/domain/usecases/get_top_rated.dart';
import 'package:flutter/foundation.dart';

class TopRatedCatalogNotifier extends ChangeNotifier {
  final GetTopRated getTopRated;

  TopRatedCatalogNotifier({required this.getTopRated});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<CatalogItem> _catalogItem = [];
  List<CatalogItem> get catalogItem => _catalogItem;

  String _message = '';
  String get message => _message;

  Future<void> fetchTopRated(Catalog catalog) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getTopRated.execute(catalog);

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (data) {
        _catalogItem = data;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
