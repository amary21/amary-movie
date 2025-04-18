import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

class GetWatchListStatus {
  final MovieRepository _movieRepository;
  final TvRepository _tvRepository;

  GetWatchListStatus(this._movieRepository, this._tvRepository);

  Future<bool> execute(Catalog catalog, int id) async {
    if (catalog == Catalog.movie) {
      return _movieRepository.isAddedToWatchlist(id);
    } else {
      return _tvRepository.isAddedToWatchlist(id);
    }
  }
}
