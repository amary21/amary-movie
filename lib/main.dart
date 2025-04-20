import 'package:about/about.dart';
import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:ditonton/firebase_options.dart';
import 'package:ditonton/presentation/bloc/detail/catalog_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/home/catalog_list_bloc.dart';
import 'package:ditonton/presentation/bloc/popular/popular_catalog_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated/top_rated_catalog_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist/watchlist_bloc.dart';
import 'package:ditonton/presentation/pages/catalog_detail_page.dart';
import 'package:ditonton/presentation/pages/home_catalog_page.dart';
import 'package:ditonton/presentation/pages/popular_catalog_page.dart';
import 'package:ditonton/presentation/pages/top_rated_catalog_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:search/search.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        BlocProvider(create: (_) => di.locator<PopularCatalogBloc>()),
        BlocProvider(create: (_) => di.locator<CatalogListBloc>()),
        BlocProvider(create: (_) => di.locator<CatalogDetailBloc>()),
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
              case SearchRoute.routeName:
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
              case AboutRoute.routeName:
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
    );
  }
}
