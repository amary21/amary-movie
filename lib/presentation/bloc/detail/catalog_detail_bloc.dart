import 'package:bloc/bloc.dart';
import 'package:ditonton/presentation/bloc/detail/catalog_detail_event.dart';
import 'package:ditonton/presentation/bloc/detail/catalog_detail_state.dart';
import 'package:domain/domain.dart';

class CatalogDetailBloc extends Bloc<CatalogDetailEvent, CatalogDetailState> {
  final GetDetail getDetail;
  final GetRecommendations getRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  CatalogDetailBloc({
    required this.getDetail,
    required this.getRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(CatalogDetailEmpty()) {
    on<FetchCatalogDetail>(_onFetchCatalogDetail);
    on<AddToWatchlist>(_onAddToWatchlist);
    on<RemoveFromWatchlist>(_onRemoveFromWatchlist);
    on<LoadWatchlistStatus>(_onLoadWatchlistStatus);
  }

  Future<void> _onFetchCatalogDetail(
    FetchCatalogDetail event,
    Emitter<CatalogDetailState> emit,
  ) async {
    emit(CatalogDetailLoading());

    final detailResult = await getDetail.execute(event.catalog, event.id);
    final recommendationResult = await getRecommendations.execute(
      event.catalog,
      event.id,
    );

    detailResult.fold((failure) => emit(CatalogDetailError(failure.message)), (
      catalogDetail,
    ) {
      recommendationResult.fold(
        (failure) => emit(
          CatalogDetailHasData(
            catalogDetail: catalogDetail,
            recommendations: [],
            isAddedToWatchlist: false,
            message: failure.message,
          ),
        ),
        (recommendations) => emit(
          CatalogDetailHasData(
            catalogDetail: catalogDetail,
            recommendations: recommendations,
            isAddedToWatchlist: false,
            message: '',
          ),
        ),
      );
      add(LoadWatchlistStatus(event.catalog, catalogDetail.id));
    });
  }

  Future<void> _onAddToWatchlist(
    AddToWatchlist event,
    Emitter<CatalogDetailState> emit,
  ) async {
    final result = await saveWatchlist.execute(
      event.catalog,
      event.catalogDetail,
    );
    result.fold(
      (failure) => emit(CatalogDetailWatchlistMessage(failure.message)),
      (success) {
        emit(CatalogDetailWatchlistMessage(success));
        emit(
          CatalogDetailHasData(
            catalogDetail: event.catalogDetail,
            recommendations: event.recommendations,
            isAddedToWatchlist: true,
            message: '',
          ),
        );
      },
    );
    add(LoadWatchlistStatus(event.catalog, event.catalogDetail.id));
  }

  Future<void> _onRemoveFromWatchlist(
    RemoveFromWatchlist event,
    Emitter<CatalogDetailState> emit,
  ) async {
    final result = await removeWatchlist.execute(
      event.catalog,
      event.catalogDetail,
    );
    result.fold(
      (failure) => emit(CatalogDetailWatchlistMessage(failure.message)),
      (success) {
        emit(CatalogDetailWatchlistMessage(success));
        emit(
          CatalogDetailHasData(
            catalogDetail: event.catalogDetail,
            recommendations: event.recommendations,
            isAddedToWatchlist: false,
            message: '',
          ),
        );
      },
    );
    add(LoadWatchlistStatus(event.catalog, event.catalogDetail.id));
  }

  Future<void> _onLoadWatchlistStatus(
    LoadWatchlistStatus event,
    Emitter<CatalogDetailState> emit,
  ) async {
    final result = await getWatchListStatus.execute(event.catalog, event.id);
    final currentState = state;
    if (currentState is CatalogDetailHasData) {
      emit(currentState.copyWith(isAddedToWatchlist: result));
    }
  }
}
