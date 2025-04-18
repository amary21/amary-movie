import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/domain/entities/now_playing.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

class GetNowPlaying {
  final MovieRepository _movieRepository;
  final TvRepository _tvRepository;

  GetNowPlaying(this._movieRepository, this._tvRepository);

  Future<Either<Failure, List<NowPlaying>>> execute(Catalog catalog) async {
    if (catalog == Catalog.movie) {
      final result = await _movieRepository.getNowPlayingMovies();
      return result.fold(
        (failure) => Left(failure),
        (data) {
          final nowPlayingMovies = data.map(
            (movie) => movie.toNowPlaying(),
          ).toList();
          return Right(nowPlayingMovies);
        },
      );
    } else if (catalog == Catalog.tv) {
      final result = await _tvRepository.getNowPlayingTv();
      return result.fold(
        (failure) => Left(failure),
        (data) {
          final nowPlayingTv = data.map(
            (tv) => tv.toNowPlaying(),
          ).toList();
          return Right(nowPlayingTv);
        },
      );
    } else {
      return Left(ServerFailure('Invalid catalog type'));
    }
  }
}
