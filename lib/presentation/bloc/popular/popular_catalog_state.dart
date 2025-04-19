import 'package:ditonton/domain/entities/catalog_item.dart';
import 'package:equatable/equatable.dart';

abstract class PopularCatalogState extends Equatable {
  const PopularCatalogState();

  @override
  List<Object> get props => [];
}

class PopularCatalogEmpty extends PopularCatalogState {}

class PopularCatalogLoading extends PopularCatalogState {}

class PopularCatalogError extends PopularCatalogState {
  final String message;

  const PopularCatalogError(this.message);

  @override
  List<Object> get props => [message];
}

class PopularCatalogHasData extends PopularCatalogState {
  final List<CatalogItem> items;

  const PopularCatalogHasData(this.items);

  @override
  List<Object> get props => [items];
}
