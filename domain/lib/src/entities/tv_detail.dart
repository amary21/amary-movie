import 'catalog_detail.dart';
import 'genre.dart';
import 'package:equatable/equatable.dart';

class TvDetail extends Equatable {
  TvDetail({
    required this.adult,
    required this.backdropPath,
    required this.firstAirDate,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.inProduction,
    required this.lastAirDate,
    required this.name,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.status,
    required this.tagline,
    required this.type,
    required this.voteAverage,
    required this.voteCount,
    required this.runtime,
  });

  bool adult;
  String? backdropPath;
  String firstAirDate;
  List<Genre> genres;
  String homepage;
  int id;
  bool inProduction;
  String lastAirDate;
  String name;
  int numberOfEpisodes;
  int numberOfSeasons;
  String originalLanguage;
  String originalName;
  String overview;
  double popularity;
  String posterPath;
  String status;
  String tagline;
  String type;
  double voteAverage;
  int voteCount;
  int runtime;

  CatalogDetail toCatalogDetail() => CatalogDetail(
    adult: adult,
    backdropPath: backdropPath,
    genres: genres,
    id: id,
    originalTitle: originalName,
    overview: overview,
    posterPath: posterPath,
    releaseDate: firstAirDate,
    runtime: runtime,
    title: name,
    voteAverage: voteAverage,
    voteCount: voteCount,
    numberOfSeasons: numberOfSeasons,
    numberOfEpisodes: numberOfEpisodes,
  );

  @override
  List<Object?> get props => [
    adult,
    backdropPath,
    firstAirDate,
    genres,
    homepage,
    id,
    inProduction,
    lastAirDate,
    name,
    numberOfEpisodes,
    numberOfSeasons,
    originalLanguage,
    originalName,
    overview,
    popularity,
    posterPath,
    status,
    tagline,
    type,
    voteAverage,
    voteCount,
  ];
}
