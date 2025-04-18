import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/domain/entities/catalog_item.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

class GetTopRated {
  final MovieRepository _movieRepository;
  final TvRepository _tvRepository;

  GetTopRated(this._movieRepository, this._tvRepository);

  Future<Either<Failure, List<CatalogItem>>> execute(Catalog catalog) async {
    if (catalog == Catalog.movie) {
      final result = await _movieRepository.getTopRatedMovies();
      return result.fold((failure) => Left(failure), (data) {
        final movies = data.map((movie) => movie.toCatalogItem()).toList();
        return Right(movies);
      });
    } else {
      final result = await _tvRepository.getTopRatedTv();
      return result.fold((failure) => Left(failure), (data) {
        final tvs = data.map((tv) => tv.toCatalogItem()).toList();
        return Right(tvs);
      });
    }
  }
}
