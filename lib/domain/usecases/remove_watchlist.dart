import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/domain/entities/catalog_detail.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

class RemoveWatchlist {
  final MovieRepository _movieRepository;
  final TvRepository _tvRepository;

  RemoveWatchlist(this._movieRepository, this._tvRepository);
  Future<Either<Failure, String>> execute(Catalog catalog, CatalogDetail catalogDetail) async {
    if (catalog == Catalog.movie) {
      return _movieRepository.removeWatchlist(catalogDetail.toMovieDetail());
    } else {
      return _tvRepository.removeWatchlist(catalogDetail.toTvDetail());
    }
  }
}
