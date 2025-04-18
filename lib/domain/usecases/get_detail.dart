import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/domain/entities/catalog_detail.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

class GetDetail {
  final MovieRepository _movieRepository;
  final TvRepository _tvRepository;

  GetDetail(this._movieRepository, this._tvRepository);

  Future<Either<Failure, CatalogDetail>> execute(Catalog catalog, int id) async {
    if (catalog == Catalog.movie) {
      final result = await _movieRepository.getMovieDetail(id);
      return result.fold((failure) => Left(failure), (data) {
        return Right(data.toCatalogDetail());
      });
    } else {
      final result = await _tvRepository.getTvDetail(id);
      return result.fold((failure) => Left(failure), (data) {
        return Right(data.toCatalogDetail());
      });
    }
  }
}
