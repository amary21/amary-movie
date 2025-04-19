import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/presentation/bloc/search/search_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated/top_rated_catalog_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist/watchlist_bloc.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/catalog_detail_page.dart';
import 'package:ditonton/presentation/pages/home_catalog_page.dart';
import 'package:ditonton/presentation/pages/popular_catalog_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_catalog_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:ditonton/presentation/provider/catalog_detail_notifier.dart';
import 'package:ditonton/presentation/provider/catalog_list_notifier.dart';
import 'package:ditonton/presentation/provider/catalog_search_notifier.dart';
import 'package:ditonton/presentation/provider/popular_catalog_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_catalog_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_catalog_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.locator<SearchBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedCatalogBloc>()),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => di.locator<CatalogListNotifier>(),
          ),
          ChangeNotifierProvider(
            create: (_) => di.locator<CatalogDetailNotifier>(),
          ),
          ChangeNotifierProvider(
            create: (_) => di.locator<CatalogSearchNotifier>(),
          ),
          ChangeNotifierProvider(
            create: (_) => di.locator<TopRatedCatalogNotifier>(),
          ),
          ChangeNotifierProvider(
            create: (_) => di.locator<PopularCatalogNotifier>(),
          ),
          ChangeNotifierProvider(
            create: (_) => di.locator<WatchlistCatalogNotifier>(),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData.dark().copyWith(
            colorScheme: kColorScheme,
            primaryColor: kRichBlack,
            scaffoldBackgroundColor: kRichBlack,
            textTheme: kTextTheme,
            drawerTheme: kDrawerTheme,
          ),
          home: HomeCatalogPage(),
          navigatorObservers: [routeObserver],
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case '/home':
                return MaterialPageRoute(builder: (_) => HomeCatalogPage());
              case PopularCatalogPage.routeName:
                final catalog = settings.arguments as Catalog;
                return CupertinoPageRoute(
                  builder: (_) => PopularCatalogPage(catalog: catalog),
                  settings: settings,
                );
              case TopRatedCatalogPage.routeName:
                final catalog = settings.arguments as Catalog;
                return CupertinoPageRoute(
                  builder: (_) => TopRatedCatalogPage(catalog: catalog),
                  settings: settings,
                );
              case CatalogDetailPage.routeName:
                final args = settings.arguments as Map<String, dynamic>;
                final id = args['id'] as int;
                final catalog = args['catalog'] as Catalog;
                return MaterialPageRoute(
                  builder: (_) => CatalogDetailPage(id: id, catalog: catalog),
                  settings: settings,
                );
              case SearchPage.routeName:
                final catalog = settings.arguments as Catalog;
                return CupertinoPageRoute(
                  builder: (_) => SearchPage(catalog: catalog),
                  settings: settings,
                );
              case WatchlistPage.routeName:
                final catalog = settings.arguments as Catalog;
                return CupertinoPageRoute(
                  builder: (_) => WatchlistPage(catalog: catalog),
                  settings: settings,
                );
              case AboutPage.routeName:
                return MaterialPageRoute(builder: (_) => AboutPage());
              default:
                return MaterialPageRoute(
                  builder: (_) {
                    return Scaffold(
                      body: Center(child: Text('Page not found :(')),
                    );
                  },
                );
            }
          },
        ),
      ),
    );
  }
}
