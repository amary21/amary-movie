import 'package:equatable/equatable.dart';
import 'package:domain/domain.dart';
import 'catalog_category_state.dart';

class CatalogListState extends Equatable {
  final Catalog catalog;

  final CatalogCategoryState nowPlaying;
  final CatalogCategoryState popular;
  final CatalogCategoryState topRated;

  const CatalogListState({
    required this.catalog,
    required this.nowPlaying,
    required this.popular,
    required this.topRated,
  });

  factory CatalogListState.initial() => CatalogListState(
        catalog: Catalog.movie,
        nowPlaying: CatalogCategoryInitial(),
        popular: CatalogCategoryInitial(),
        topRated: CatalogCategoryInitial(),
      );

  CatalogListState copyWith({
    Catalog? catalog,
    CatalogCategoryState? nowPlaying,
    CatalogCategoryState? popular,
    CatalogCategoryState? topRated,
  }) {
    return CatalogListState(
      catalog: catalog ?? this.catalog,
      nowPlaying: nowPlaying ?? this.nowPlaying,
      popular: popular ?? this.popular,
      topRated: topRated ?? this.topRated,
    );
  }

  @override
  List<Object> get props => [catalog, nowPlaying, popular, topRated];
}
