import 'package:bloc/bloc.dart';
import 'package:domain/domain.dart';
import 'package:ditonton/presentation/bloc/search/search_event.dart';
import 'package:ditonton/presentation/bloc/search/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchCatalog _searchCatalog;

  SearchBloc(this._searchCatalog) : super(SearchEmpty()) {
    on<OnQueryChanged>(_onQueryChanged);
    on<OnResetSearch>(_onResetSearch);
  }

  Future<void> _onQueryChanged(
    OnQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query;
    final catalog = event.catalog;

    emit(SearchLoading());

    final result = await _searchCatalog.execute(catalog, query);

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (data) => emit(SearchHasData(data)),
    );
  }

  void _onResetSearch(OnResetSearch event, Emitter<SearchState> emit) {
    emit(SearchEmpty());
  }
}
