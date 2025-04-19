import 'package:ditonton/domain/entities/catalog.dart';
import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class OnQueryChanged extends SearchEvent {
  final String query;
  final Catalog catalog;

  const OnQueryChanged(this.query, this.catalog);

  @override
  List<Object> get props => [query, catalog];
}

class OnResetSearch extends SearchEvent {}
