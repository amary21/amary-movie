import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

class CatalogDetail extends Equatable {
  CatalogDetail({
    required this.adult,
    required this.backdropPath,
    required this.genres,
    required this.id,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.runtime,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
  });

  final bool adult;
  final String? backdropPath;
  final List<Genre> genres;
  final int id;
  final String originalTitle;
  final String overview;
  final String posterPath;
  final String releaseDate;
  final int runtime;
  final String title;
  final double voteAverage;
  final int voteCount;

  MovieDetail toMovieDetail() => MovieDetail(
    adult: this.adult,
    backdropPath: this.backdropPath,
    genres: this.genres,
    id: this.id,
    originalTitle: this.originalTitle,
    overview: this.overview,
    posterPath: this.posterPath,
    releaseDate: this.releaseDate,
    runtime: this.runtime,
    title: this.title,
    voteAverage: this.voteAverage,
    voteCount: this.voteCount,
  );

  TvDetail toTvDetail() => TvDetail(
    adult: this.adult,
    backdropPath: this.backdropPath,
    firstAirDate: this.releaseDate,
    genres: this.genres,
    homepage: '',
    id: this.id,
    inProduction: false,
    lastAirDate: this.releaseDate,
    name: this.originalTitle,
    numberOfEpisodes: 0,
    numberOfSeasons: 0,
    originalLanguage: '',
    originalName: this.originalTitle,
    overview: this.overview,
    popularity: 0.0,
    posterPath: this.posterPath,
    status: '',
    tagline: '',
    type: '',
    voteAverage: this.voteAverage,
    voteCount: this.voteCount,
    runtime: this.runtime,
  );

  @override
  List<Object?> get props => [
    adult,
    backdropPath,
    genres,
    id,
    originalTitle,
    overview,
    posterPath,
    releaseDate,
    title,
    voteAverage,
    voteCount,
  ];
}
