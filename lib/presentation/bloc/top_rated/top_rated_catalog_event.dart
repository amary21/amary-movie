import 'package:ditonton/domain/entities/catalog.dart';
import 'package:equatable/equatable.dart';

abstract class TopRatedCatalogEvent extends Equatable {
  const TopRatedCatalogEvent();

  @override
  List<Object> get props => [];
}

class FetchTopRatedCatalog extends TopRatedCatalogEvent {
  final Catalog catalog;

  const FetchTopRatedCatalog(this.catalog);

  @override
  List<Object> get props => [catalog];
}
