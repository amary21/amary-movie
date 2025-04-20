import 'package:domain/domain.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  MovieRepository,
  TvRepository,
])
void main() {}

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testCatalogDetail = CatalogDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
  numberOfSeasons: 1,
  numberOfEpisodes: 1,
);

final testTvDetail = TvDetail(
  adult: false,
  backdropPath: "backdropPath",
  firstAirDate: "releaseDate",
  genres: [Genre(id: 1, name: 'Action')],
  homepage: "homepage",
  id: 1,
  inProduction: true,
  lastAirDate: "2023-10-01",
  name: "title",
  numberOfEpisodes: 1,
  numberOfSeasons: 1,
  originalLanguage: "originalLanguage",
  originalName: "originalTitle",
  overview: "overview",
  popularity: 1,
  posterPath: "posterPath",
  status: "status",
  tagline: "tagline",
  type: "type",
  voteAverage: 1,
  voteCount: 1,
  runtime: 120,
);

