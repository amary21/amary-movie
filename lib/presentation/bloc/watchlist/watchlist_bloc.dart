import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/get_watchlist_catalog.dart';
import 'package:ditonton/presentation/bloc/watchlist/watchlist_event.dart';
import 'package:ditonton/presentation/bloc/watchlist/watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final GetWatchlistCatalog _getWatchlistCatalog;

  WatchlistBloc(this._getWatchlistCatalog) : super(WatchlistEmpty()) {
    on<FetchWatchlist>(_onFetchWatchlist);
  }

  Future<void> _onFetchWatchlist(
    FetchWatchlist event,
    Emitter<WatchlistState> emit,
  ) async {
    final catalog = event.catalog;

    emit(WatchlistLoading());

    final result = await _getWatchlistCatalog.execute(catalog);

    result.fold(
      (failure) => emit(WatchlistError(failure.message)),
      (data) => emit(WatchlistHasData(data)),
    );
  }
}
