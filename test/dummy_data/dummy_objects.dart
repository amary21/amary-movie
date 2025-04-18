import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/tv_table.dart';
import 'package:ditonton/domain/entities/catalog_detail.dart';
import 'package:ditonton/domain/entities/catalog_item.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

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
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

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

final testTvTable = TvTable(
  id: 1,
  name: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'title',
};

final testWatchlistTv = Tv.watchlist(
  id: 1,
  name: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testCatalogItem = CatalogItem(
  adult: false,
  backdropPath: 'backdropPath',
  genreIds: [1, 2, 3],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  popularity: 1,
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);
final testCatalogItemList = <CatalogItem>[testCatalogItem];
