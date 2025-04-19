import 'package:equatable/equatable.dart';
import 'package:ditonton/domain/entities/catalog_item.dart';

abstract class CatalogCategoryState extends Equatable {
  const CatalogCategoryState();

  @override
  List<Object> get props => [];
}

class CatalogCategoryInitial extends CatalogCategoryState {}

class CatalogCategoryLoading extends CatalogCategoryState {}

class CatalogCategoryLoaded extends CatalogCategoryState {
  final List<CatalogItem> items;

  const CatalogCategoryLoaded(this.items);

  @override
  List<Object> get props => [items];
}

class CatalogCategoryError extends CatalogCategoryState {
  final String message;

  const CatalogCategoryError(this.message);

  @override
  List<Object> get props => [message];
}
