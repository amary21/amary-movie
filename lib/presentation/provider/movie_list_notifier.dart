import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/domain/entities/catalog_item.dart';
import 'package:ditonton/domain/usecases/get_now_playing.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_popular.dart';
import 'package:ditonton/domain/usecases/get_top_rated.dart';
import 'package:flutter/material.dart';

class MovieListNotifier extends ChangeNotifier {
  var _catalog = Catalog.movie;
  Catalog get catalog => _catalog;

  var _nowPlaying = <CatalogItem>[];
  List<CatalogItem> get nowPlaying => _nowPlaying;

  RequestState _nowPlayingState = RequestState.Empty;
  RequestState get nowPlayingState => _nowPlayingState;

  var _popular = <CatalogItem>[];
  List<CatalogItem> get popular => _popular;

  RequestState _popularState = RequestState.Empty;
  RequestState get popularState => _popularState;

  var _topRated = <CatalogItem>[];
  List<CatalogItem> get topRated => _topRated;

  RequestState _topRatedState = RequestState.Empty;
  RequestState get topRatedState => _topRatedState;

  String _message = '';
  String get message => _message;

  MovieListNotifier({
    required this.getNowPlaying,
    required this.getPopular,
    required this.getTopRated,
  });

  final GetNowPlaying getNowPlaying;
  final GetPopular getPopular;
  final GetTopRated getTopRated;

  Future<void> fetchNowPlaying(Catalog catalog) async {
    _catalog = catalog;
    _nowPlayingState = RequestState.Loading;
    notifyListeners();

    final result = await getNowPlaying.execute(catalog);
    result.fold(
      (failure) {
        _nowPlayingState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _nowPlayingState = RequestState.Loaded;
        _nowPlaying = data;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopular(Catalog catalog) async {
    _popularState = RequestState.Loading;
    notifyListeners();

    final result = await getPopular.execute(catalog);
    result.fold(
      (failure) {
        _popularState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _popularState = RequestState.Loaded;
        _popular = data;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRated(Catalog catalog) async {
    _topRatedState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRated.execute(catalog);
    result.fold(
      (failure) {
        _topRatedState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _topRatedState = RequestState.Loaded;
        _topRated = data;
        notifyListeners();
      },
    );
  }
}
