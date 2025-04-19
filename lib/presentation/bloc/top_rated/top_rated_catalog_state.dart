import 'package:ditonton/domain/entities/catalog_item.dart';
import 'package:equatable/equatable.dart';

abstract class TopRatedCatalogState extends Equatable {
  const TopRatedCatalogState();

  @override
  List<Object> get props => [];
}

class TopRatedCatalogEmpty extends TopRatedCatalogState {}

class TopRatedCatalogLoading extends TopRatedCatalogState {}

class TopRatedCatalogError extends TopRatedCatalogState {
  final String message;

  const TopRatedCatalogError(this.message);

  @override
  List<Object> get props => [message];
}

class TopRatedCatalogHasData extends TopRatedCatalogState {
  final List<CatalogItem> catalogItems;

  const TopRatedCatalogHasData(this.catalogItems);

  @override
  List<Object> get props => [catalogItems];
}
