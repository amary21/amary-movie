import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object> get props => [];
}

class FetchWatchlist extends WatchlistEvent {
  final Catalog catalog;

  const FetchWatchlist(this.catalog);

  @override
  List<Object> get props => [catalog];
}
