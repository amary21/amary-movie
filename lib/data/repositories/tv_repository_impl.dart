import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/datasources/tv_local_data_source.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

class TvRepositoryImpl implements TvRepository {
  final TvRemoteDataSource remoteDataSource;
  final TvLocalDataSource localDataSource;

  TvRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Tv>>> getNowPlayingTv() {
    // TODO: implement getNowPlayingTv
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Tv>>> getPopularTv() {
    // TODO: implement getPopularTv
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Tv>>> getTopRatedTv() {
    // TODO: implement getTopRatedTv
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, TvDetail>> getTvDetail(int id) {
    // TODO: implement getTvDetail
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Tv>>> getTvRecommendations(int id) {
    // TODO: implement getTvRecommendations
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Tv>>> getWatchlistTv() {
    // TODO: implement getWatchlistTv
    throw UnimplementedError();
  }

  @override
  Future<bool> isAddedToWatchlist(int id) {
    // TODO: implement isAddedToWatchlist
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(TvDetail Tv) {
    // TODO: implement removeWatchlist
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> saveWatchlist(TvDetail Tv) {
    // TODO: implement saveWatchlist
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Tv>>> searchTv(String query) {
    // TODO: implement searchTv
    throw UnimplementedError();
  }
  
}