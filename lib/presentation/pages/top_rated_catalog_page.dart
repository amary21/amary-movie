import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/presentation/provider/top_rated_catalog_notifier.dart';
import 'package:ditonton/presentation/widgets/catalog_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopRatedCatalogPage extends StatefulWidget {
  static const routeName = '/top-rated-movie';

  final Catalog catalog;
  const TopRatedCatalogPage({super.key, required this.catalog});

  @override
  _TopRatedCatalogPageState createState() => _TopRatedCatalogPageState();
}

class _TopRatedCatalogPageState extends State<TopRatedCatalogPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<TopRatedCatalogNotifier>(
        context,
        listen: false,
      ).fetchTopRated(widget.catalog),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Top Rated Movies')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TopRatedCatalogNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.Loading) {
              return Center(child: CircularProgressIndicator());
            } else if (data.state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = data.catalogItem[index];
                  return CatalogCard(movie, widget.catalog);
                },
                itemCount: data.catalogItem.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
