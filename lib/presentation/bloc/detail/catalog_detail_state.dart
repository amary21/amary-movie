import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';

abstract class CatalogDetailState extends Equatable {
  const CatalogDetailState();

  @override
  List<Object?> get props => [];
}

class CatalogDetailEmpty extends CatalogDetailState {}

class CatalogDetailLoading extends CatalogDetailState {}

class CatalogDetailError extends CatalogDetailState {
  final String message;

  const CatalogDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

class CatalogDetailHasData extends CatalogDetailState {
  final CatalogDetail catalogDetail;
  final List<CatalogItem> recommendations;
  final bool isAddedToWatchlist;
  final String message;

  const CatalogDetailHasData({
    required this.catalogDetail,
    required this.recommendations,
    required this.isAddedToWatchlist,
    required this.message,
  });

  CatalogDetailHasData copyWith({
    CatalogDetail? catalogDetail,
    List<CatalogItem>? recommendations,
    bool? isAddedToWatchlist,
    String? message,
  }) {
    return CatalogDetailHasData(
      catalogDetail: catalogDetail ?? this.catalogDetail,
      recommendations: recommendations ?? this.recommendations,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        catalogDetail,
        recommendations,
        isAddedToWatchlist,
        message,
      ];
}

class CatalogDetailWatchlistMessage extends CatalogDetailState {
  final String message;

  const CatalogDetailWatchlistMessage(this.message);

  @override
  List<Object?> get props => [message];
}