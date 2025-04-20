import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';

abstract class CatalogDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchCatalogDetail extends CatalogDetailEvent {
  final Catalog catalog;
  final int id;

  FetchCatalogDetail(this.catalog, this.id);

  @override
  List<Object?> get props => [catalog, id];
}

class AddToWatchlist extends CatalogDetailEvent {
  final Catalog catalog;
  final CatalogDetail catalogDetail;
  final List<CatalogItem> recommendations; 

  AddToWatchlist(this.catalog, this.catalogDetail, this.recommendations);

  @override
  List<Object?> get props => [catalog, catalogDetail, recommendations];
}

class RemoveFromWatchlist extends CatalogDetailEvent {
  final Catalog catalog;
  final CatalogDetail catalogDetail;
  final List<CatalogItem> recommendations; 

  RemoveFromWatchlist(this.catalog, this.catalogDetail, this.recommendations);

  @override
  List<Object?> get props => [catalog, catalogDetail, recommendations];
}

class LoadWatchlistStatus extends CatalogDetailEvent {
  final Catalog catalog;
  final int id;

  LoadWatchlistStatus(this.catalog, this.id);

  @override
  List<Object?> get props => [catalog, id];
}