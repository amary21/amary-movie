import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/domain/entities/catalog_item.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/catalog_detail_page.dart';
import 'package:ditonton/presentation/pages/popular_catalog_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_catalog_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:ditonton/presentation/provider/catalog_list_notifier.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeCatalogPage extends StatefulWidget {
  const HomeCatalogPage({super.key});

  @override
  _HomeCatalogPageState createState() => _HomeCatalogPageState();
}

class _HomeCatalogPageState extends State<HomeCatalogPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CatalogListNotifier>(context, listen: false)
        ..fetchNowPlaying(Catalog.movie)
        ..fetchPopular(Catalog.movie)
        ..fetchTopRated(Catalog.movie);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
                backgroundColor: Colors.grey.shade900,
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
              decoration: BoxDecoration(color: Colors.grey.shade900),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                Provider.of<CatalogListNotifier>(context, listen: false)
                  ..fetchNowPlaying(Catalog.movie)
                  ..fetchPopular(Catalog.movie)
                  ..fetchTopRated(Catalog.movie);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.tv),
              title: Text('Tv Series'),
              onTap: () {
                Provider.of<CatalogListNotifier>(context, listen: false)
                  ..fetchNowPlaying(Catalog.tv)
                  ..fetchPopular(Catalog.tv)
                  ..fetchTopRated(Catalog.tv);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist Movies'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  WatchlistPage.routeName,
                  arguments: Catalog.movie,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist Tv Series'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  WatchlistPage.routeName,
                  arguments: Catalog.tv,
                );
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.routeName);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              final catalog =
                  Provider.of<CatalogListNotifier>(
                    context,
                    listen: false,
                  ).catalog;
              Navigator.pushNamed(
                context,
                SearchPage.routeName,
                arguments: catalog,
              );
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Now Playing', style: kHeading6),
              Consumer<CatalogListNotifier>(
                builder: (context, data, child) {
                  final state = data.nowPlayingState;
                  if (state == RequestState.Loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state == RequestState.Loaded) {
                    return CatalogList(data.nowPlaying);
                  } else {
                    return Text('Failed');
                  }
                },
              ),
              Consumer<CatalogListNotifier>(
                builder: (context, data, child) {
                  return _buildSubHeading(
                    title: 'Popular',
                    onTap:
                        () => Navigator.pushNamed(
                          context,
                          PopularCatalogPage.routeName,
                          arguments: data.catalog,
                        ),
                  );
                },
              ),
              Consumer<CatalogListNotifier>(
                builder: (context, data, child) {
                  final state = data.popularState;
                  if (state == RequestState.Loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state == RequestState.Loaded) {
                    return CatalogList(data.popular);
                  } else {
                    return Text('Failed');
                  }
                },
              ),
              Consumer<CatalogListNotifier>(
                builder: (context, data, child) {
                  return _buildSubHeading(
                    title: 'Top Rated',
                    onTap:
                        () => Navigator.pushNamed(
                          context,
                          TopRatedCatalogPage.routeName,
                          arguments: data.catalog,
                        ),
                  );
                },
              ),
              Consumer<CatalogListNotifier>(
                builder: (context, data, child) {
                  final state = data.topRatedState;
                  if (state == RequestState.Loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state == RequestState.Loaded) {
                    return CatalogList(data.topRated);
                  } else {
                    return Text('Failed');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: kHeading6),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class CatalogList extends StatelessWidget {
  final List<CatalogItem> nowPlaying;

  const CatalogList(this.nowPlaying, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final catalogItem = nowPlaying[index];
          final catalog =
              Provider.of<CatalogListNotifier>(context, listen: false).catalog;
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  CatalogDetailPage.routeName,
                  arguments: {'id': catalogItem.id, 'catalog': catalog},
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseUrlImage${catalogItem.posterPath}',
                  placeholder:
                      (context, url) =>
                          Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: nowPlaying.length,
      ),
    );
  }
}
