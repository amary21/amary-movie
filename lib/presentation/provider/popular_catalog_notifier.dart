import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/domain/entities/catalog_item.dart';
import 'package:ditonton/domain/usecases/get_popular.dart';
import 'package:flutter/foundation.dart';

class PopularCatalogNotifier extends ChangeNotifier {
  final GetPopular getPopular;

  PopularCatalogNotifier(this.getPopular);

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<CatalogItem> _catalogItem = [];
  List<CatalogItem> get catalogItem => _catalogItem;

  String _message = '';
  String get message => _message;

  Future<void> fetchPopular(Catalog catalog) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getPopular.execute(catalog);

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (catalogItem) {
        _catalogItem = catalogItem;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
