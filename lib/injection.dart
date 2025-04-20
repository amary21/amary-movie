import 'package:about/about.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:ditonton/presentation/bloc/detail/catalog_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/home/catalog_list_bloc.dart';
import 'package:ditonton/presentation/bloc/popular/popular_catalog_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated/top_rated_catalog_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist/watchlist_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:navigation/navigation.dart';
import 'package:search/search.dart';

final locator = GetIt.instance;

Future<void> init() async {
  // navigation
  _registerLazySingletonIfAbsent<RouteAbout>(() => AboutRoute());
  _registerLazySingletonIfAbsent<RouteSearch>(() => SearchRoute());

  // bloc
  _registerFactoryIfAbsent(() => SearchBloc(locator()));
  _registerFactoryIfAbsent(() => WatchlistBloc(locator()));
  _registerFactoryIfAbsent(() => TopRatedCatalogBloc(locator()));
  _registerFactoryIfAbsent(() => PopularCatalogBloc(locator()));
  _registerFactoryIfAbsent(
    () => CatalogListBloc(
      getNowPlaying: locator(),
      getPopular: locator(),
      getTopRated: locator(),
    ),
  );
  _registerFactoryIfAbsent(
    () => CatalogDetailBloc(
      getDetail: locator(),
      getRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );

  // use case
  _registerLazySingletonIfAbsent(() => GetNowPlaying(locator(), locator()));
  _registerLazySingletonIfAbsent(() => GetPopular(locator(), locator()));
  _registerLazySingletonIfAbsent(() => GetTopRated(locator(), locator()));
  _registerLazySingletonIfAbsent(() => GetDetail(locator(), locator()));
  _registerLazySingletonIfAbsent(
    () => GetRecommendations(locator(), locator()),
  );
  _registerLazySingletonIfAbsent(() => SearchCatalog(locator(), locator()));
  _registerLazySingletonIfAbsent(
    () => GetWatchListStatus(locator(), locator()),
  );
  _registerLazySingletonIfAbsent(() => SaveWatchlist(locator(), locator()));
  _registerLazySingletonIfAbsent(() => RemoveWatchlist(locator(), locator()));
  _registerLazySingletonIfAbsent(
    () => GetWatchlistCatalog(locator(), locator()),
  );

  // repository
  _registerLazySingletonIfAbsent<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  _registerLazySingletonIfAbsent<TvRepository>(
    () => TvRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  _registerLazySingletonIfAbsent<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(client: locator()),
  );
  _registerLazySingletonIfAbsent<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(databaseHelper: locator()),
  );
  _registerLazySingletonIfAbsent<TvRemoteDataSource>(
    () => TvRemoteDataSourceImpl(client: locator()),
  );
  _registerLazySingletonIfAbsent<TvLocalDataSource>(
    () => TvLocalDataSourceImpl(databaseHelper: locator()),
  );

  // helper
  if (!locator.isRegistered<DatabaseHelper>()) {
    final databaseHelper = await DatabaseHelper.init();
    locator.registerLazySingleton<DatabaseHelper>(() => databaseHelper);
  }

  // external
  if (!locator.isRegistered<http.Client>()) {
    final httpClient = await NetworkConfig.createSecureClient();
    locator.registerLazySingleton<http.Client>(() => httpClient);
  }
}

void _registerFactoryIfAbsent<T extends Object>(T Function() factoryFunc) {
  if (!locator.isRegistered<T>()) {
    locator.registerFactory<T>(factoryFunc);
  }
}

void _registerLazySingletonIfAbsent<T extends Object>(
  T Function() factoryFunc,
) {
  if (!locator.isRegistered<T>()) {
    locator.registerLazySingleton<T>(factoryFunc);
  }
}
