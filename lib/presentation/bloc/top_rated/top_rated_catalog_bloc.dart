import 'package:bloc/bloc.dart';
import 'package:domain/domain.dart';
import 'package:ditonton/presentation/bloc/top_rated/top_rated_catalog_event.dart';
import 'package:ditonton/presentation/bloc/top_rated/top_rated_catalog_state.dart';

class TopRatedCatalogBloc
    extends Bloc<TopRatedCatalogEvent, TopRatedCatalogState> {
  final GetTopRated _getTopRated;

  TopRatedCatalogBloc(this._getTopRated) : super(TopRatedCatalogEmpty()) {
    on<FetchTopRatedCatalog>(_fetchTopRated);
  }

  Future<void> _fetchTopRated(
    FetchTopRatedCatalog event,
    Emitter<TopRatedCatalogState> emit,
  ) async {
    final catalog = event.catalog;

    emit(TopRatedCatalogLoading());

    final result = await _getTopRated.execute(catalog);

    result.fold(
      (failure) => emit(TopRatedCatalogError(failure.message)),
      (data) => emit(TopRatedCatalogHasData(data)),
    );
  }
}
