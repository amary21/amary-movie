import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/presentation/provider/popular_catalog_notifier.dart';
import 'package:ditonton/presentation/widgets/catalog_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopularCatalogPage extends StatefulWidget {
  static const routeName = '/popular-catalog';

  final Catalog catalog;
  const PopularCatalogPage({super.key, required this.catalog});

  @override
  _PopularCatalogPageState createState() => _PopularCatalogPageState();
}

class _PopularCatalogPageState extends State<PopularCatalogPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<PopularCatalogNotifier>(
        context,
        listen: false,
      ).fetchPopular(widget.catalog),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Popular ${widget.catalog.name}')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<PopularCatalogNotifier>(
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
