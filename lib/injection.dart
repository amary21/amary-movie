import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/tv_local_data_source.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/data/repositories/tv_repository_impl.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';
import 'package:ditonton/domain/usecases/get_detail.dart';
import 'package:ditonton/domain/usecases/get_recommendations.dart';
import 'package:ditonton/domain/usecases/get_now_playing.dart';
import 'package:ditonton/domain/usecases/get_popular.dart';
import 'package:ditonton/domain/usecases/get_top_rated.dart';
import 'package:ditonton/domain/usecases/get_watchlist_catalog.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/domain/usecases/search_catalog.dart';
import 'package:ditonton/presentation/bloc/search/search_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist/watchlist_bloc.dart';
import 'package:ditonton/presentation/provider/catalog_detail_notifier.dart';
import 'package:ditonton/presentation/provider/catalog_list_notifier.dart';
import 'package:ditonton/presentation/provider/catalog_search_notifier.dart';
import 'package:ditonton/presentation/provider/popular_catalog_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_catalog_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_catalog_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

Future<void> init() async {
  // Check if locator is already initialized to prevent duplicate registrations
  if (locator.isRegistered<CatalogListNotifier>() ||
      locator.isRegistered<SearchBloc>()) {
    return; // Dependencies already registered, exit early
  }

  // bloc
  locator.registerFactory(() => SearchBloc(locator()));
  locator.registerFactory(() => WatchlistBloc(locator()));

  // provider
  locator.registerFactory(
    () => CatalogListNotifier(
      getNowPlaying: locator(),
      getPopular: locator(),
      getTopRated: locator(),
    ),
  );
  locator.registerFactory(
    () => CatalogDetailNotifier(
      getDetail: locator(),
      getRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => CatalogSearchNotifier(searchCatalog: locator()),
  );
  locator.registerFactory(() => PopularCatalogNotifier(locator()));
  locator.registerFactory(
    () => TopRatedCatalogNotifier(getTopRated: locator()),
  );
  locator.registerFactory(
    () => WatchlistCatalogNotifier(getWatchlistCatalog: locator()),
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlaying(locator(), locator()));
  locator.registerLazySingleton(() => GetPopular(locator(), locator()));
  locator.registerLazySingleton(() => GetTopRated(locator(), locator()));
  locator.registerLazySingleton(() => GetDetail(locator(), locator()));
  locator.registerLazySingleton(() => GetRecommendations(locator(), locator()));
  locator.registerLazySingleton(() => SearchCatalog(locator(), locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator(), locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator(), locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator(), locator()));
  locator.registerLazySingleton(
    () => GetWatchlistCatalog(locator(), locator()),
  );

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TvRepository>(
    () => TvRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(databaseHelper: locator()),
  );
  locator.registerLazySingleton<TvRemoteDataSource>(
    () => TvRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<TvLocalDataSource>(
    () => TvLocalDataSourceImpl(databaseHelper: locator()),
  );

  // helper
  final databaseHelper = await DatabaseHelper.init();
  locator.registerLazySingleton<DatabaseHelper>(() => databaseHelper);

  // external
  locator.registerLazySingleton(() => http.Client());
}
