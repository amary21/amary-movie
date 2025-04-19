import 'package:ditonton/presentation/bloc/home/catalog_list_event.dart';
import 'package:ditonton/presentation/bloc/home/catalog_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/domain/entities/catalog_item.dart';
import 'package:ditonton/presentation/bloc/home/catalog_list_bloc.dart';
import 'package:ditonton/presentation/bloc/home/catalog_category_state.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/catalog_detail_page.dart';
import 'package:ditonton/presentation/pages/popular_catalog_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_catalog_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';

class HomeCatalogPage extends StatefulWidget {
  const HomeCatalogPage({super.key});

  @override
  State<HomeCatalogPage> createState() => _HomeCatalogPageState();
}

class _HomeCatalogPageState extends State<HomeCatalogPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CatalogListBloc>().add(FetchCatalogList(Catalog.movie));
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
                context.read<CatalogListBloc>().add(
                  FetchCatalogList(Catalog.movie),
                );
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.tv),
              title: Text('Tv Series'),
              onTap: () {
                context.read<CatalogListBloc>().add(
                  FetchCatalogList(Catalog.tv),
                );
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
              final catalog = context.read<CatalogListBloc>().state.catalog;
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
        child: BlocBuilder<CatalogListBloc, CatalogListState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Now Playing', style: kHeading6),
                  _buildSection(state.nowPlaying),
                  _buildSubHeading(
                    title: 'Popular',
                    onTap:
                        () => Navigator.pushNamed(
                          context,
                          PopularCatalogPage.routeName,
                          arguments: state.catalog,
                        ),
                  ),
                  _buildSection(state.popular),
                  _buildSubHeading(
                    title: 'Top Rated',
                    onTap:
                        () => Navigator.pushNamed(
                          context,
                          TopRatedCatalogPage.routeName,
                          arguments: state.catalog,
                        ),
                  ),
                  _buildSection(state.topRated),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSection(CatalogCategoryState categoryState) {
    switch (categoryState) {
      case CatalogCategoryLoading():
        return const Center(child: CircularProgressIndicator());
      case CatalogCategoryLoaded(:final items):
        return CatalogList(items);
      case CatalogCategoryError(:final message):
        return Center(child: Text(message));
      default:
        return const SizedBox();
    }
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
    final catalog = context.read<CatalogListBloc>().state.catalog;
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: nowPlaying.length,
        itemBuilder: (context, index) {
          final catalogItem = nowPlaying[index];
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
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: '$baseUrlImage${catalogItem.posterPath}',
                  placeholder:
                      (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
