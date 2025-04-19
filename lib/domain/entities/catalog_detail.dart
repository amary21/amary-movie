import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

class CatalogDetail extends Equatable {
  const CatalogDetail({
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
    this.numberOfSeasons = 0,
    this.numberOfEpisodes = 0,
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
  final int numberOfSeasons;
  final int numberOfEpisodes;

  MovieDetail toMovieDetail() => MovieDetail(
    adult: adult,
    backdropPath: backdropPath,
    genres: genres,
    id: id,
    originalTitle: originalTitle,
    overview: overview,
    posterPath: posterPath,
    releaseDate: releaseDate,
    runtime: runtime,
    title: title,
    voteAverage: voteAverage,
    voteCount: voteCount,
  );

  TvDetail toTvDetail() => TvDetail(
    adult: adult,
    backdropPath: backdropPath,
    firstAirDate: releaseDate,
    genres: genres,
    homepage: '',
    id: id,
    inProduction: false,
    lastAirDate: releaseDate,
    name: originalTitle,
    numberOfEpisodes: numberOfEpisodes,
    numberOfSeasons: numberOfSeasons,
    originalLanguage: '',
    originalName: originalTitle,
    overview: overview,
    popularity: 0.0,
    posterPath: posterPath,
    status: '',
    tagline: '',
    type: '',
    voteAverage: voteAverage,
    voteCount: voteCount,
    runtime: runtime,
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
