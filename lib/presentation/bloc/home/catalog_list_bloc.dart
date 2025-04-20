import 'package:bloc/bloc.dart';
import 'package:ditonton/presentation/bloc/home/catalog_category_state.dart';
import 'package:ditonton/presentation/bloc/home/catalog_list_event.dart';
import 'package:ditonton/presentation/bloc/home/catalog_list_state.dart';
import 'package:domain/domain.dart';

class CatalogListBloc extends Bloc<CatalogListEvent, CatalogListState> {
  final GetNowPlaying getNowPlaying;
  final GetPopular getPopular;
  final GetTopRated getTopRated;

  CatalogListBloc({
    required this.getNowPlaying,
    required this.getPopular,
    required this.getTopRated,
  }) : super(CatalogListState.initial()) {
    on<FetchCatalogList>(_onFetch);
  }

  Future<void> _onFetch(
    FetchCatalogList event,
    Emitter<CatalogListState> emit,
  ) async {
    emit(
      state.copyWith(
        catalog: event.catalog,
        nowPlaying: CatalogCategoryLoading(),
        popular: CatalogCategoryLoading(),
        topRated: CatalogCategoryLoading(),
      ),
    );

    final nowPlayingResult = await getNowPlaying.execute(event.catalog);
    final popularResult = await getPopular.execute(event.catalog);
    final topRatedResult = await getTopRated.execute(event.catalog);

    nowPlayingResult.fold(
      (failure) => emit(
        state.copyWith(nowPlaying: CatalogCategoryError(failure.message)),
      ),
      (data) => emit(state.copyWith(nowPlaying: CatalogCategoryLoaded(data))),
    );

    popularResult.fold(
      (failure) =>
          emit(state.copyWith(popular: CatalogCategoryError(failure.message))),
      (data) => emit(state.copyWith(popular: CatalogCategoryLoaded(data))),
    );

    topRatedResult.fold(
      (failure) =>
          emit(state.copyWith(topRated: CatalogCategoryError(failure.message))),
      (data) => emit(state.copyWith(topRated: CatalogCategoryLoaded(data))),
    );
  }
}
