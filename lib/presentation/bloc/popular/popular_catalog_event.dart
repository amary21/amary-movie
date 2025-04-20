import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';

abstract class PopularCatalogEvent extends Equatable {
  const PopularCatalogEvent();

  @override
  List<Object> get props => [];
}

class FetchPopularCatalog extends PopularCatalogEvent {
  final Catalog catalog;

  const FetchPopularCatalog(this.catalog);

  @override
  List<Object> get props => [catalog];
}
