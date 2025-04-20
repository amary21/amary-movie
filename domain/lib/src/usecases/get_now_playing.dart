import 'package:dartz/dartz.dart';
import '../entities/catalog.dart';
import '../entities/catalog_item.dart';
import '../repositories/movie_repository.dart';
import 'package:common/common.dart';
import '../repositories/tv_repository.dart';

class GetNowPlaying {
  final MovieRepository _movieRepository;
  final TvRepository _tvRepository;

  GetNowPlaying(this._movieRepository, this._tvRepository);

  Future<Either<Failure, List<CatalogItem>>> execute(Catalog catalog) async {
    if (catalog == Catalog.movie) {
      final result = await _movieRepository.getNowPlayingMovies();
      return result.fold((failure) => Left(failure), (data) {
        final movies = data.map((movie) => movie.toCatalogItem()).toList();
        return Right(movies);
      });
    } else {
      final result = await _tvRepository.getNowPlayingTv();
      return result.fold((failure) => Left(failure), (data) {
        final tvs = data.map((tv) => tv.toCatalogItem()).toList();
        return Right(tvs);
      });
    }
  }
}
