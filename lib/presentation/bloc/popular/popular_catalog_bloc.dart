import 'package:bloc/bloc.dart';
import 'package:domain/domain.dart';
import 'package:ditonton/presentation/bloc/popular/popular_catalog_event.dart';
import 'package:ditonton/presentation/bloc/popular/popular_catalog_state.dart';

class PopularCatalogBloc
    extends Bloc<PopularCatalogEvent, PopularCatalogState> {
  final GetPopular _getPopular;

  PopularCatalogBloc(this._getPopular) : super(PopularCatalogEmpty()) {
    on<FetchPopularCatalog>(_fetchPopular);
  }

  Future<void> _fetchPopular(
    FetchPopularCatalog event,
    Emitter<PopularCatalogState> emit,
  ) async {
    emit(PopularCatalogLoading());

    final result = await _getPopular.execute(event.catalog);

    result.fold(
      (failure) => emit(PopularCatalogError(failure.message)),
      (data) => emit(PopularCatalogHasData(data)),
    );
  }
}
