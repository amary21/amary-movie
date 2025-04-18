import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/domain/entities/catalog_item.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

class GetPopular {
  final MovieRepository _movieRepository;
  final TvRepository _tvRepository;

  GetPopular(this._movieRepository, this._tvRepository);

  Future<Either<Failure, List<CatalogItem>>> execute(Catalog catalog) async {
        if (catalog == Catalog.movie) {
      final result = await _movieRepository.getPopularMovies();
      return result.fold(
        (failure) => Left(failure),
        (data) {
          final movies = data.map(
            (movie) => movie.toCatalogItem(),
          ).toList();
          print("popular movies: $movies");
          return Right(movies);
        },
      );
    } else if (catalog == Catalog.tv) {
      final result = await _tvRepository.getPopularTv();
      return result.fold(
        (failure) => Left(failure),
        (data) {
          final tvs = data.map(
            (tv) => tv.toCatalogItem(),
          ).toList();
          return Right(tvs);
        },
      );
    } else {
      return Left(ServerFailure('Invalid catalog type'));
    }
  }
}
