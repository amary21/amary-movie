import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';

abstract class CatalogListEvent extends Equatable {
  const CatalogListEvent();

  @override
  List<Object> get props => [];
}

class FetchCatalogList extends CatalogListEvent {
  final Catalog catalog;

  const FetchCatalogList(this.catalog);

  @override
  List<Object> get props => [catalog];
}
