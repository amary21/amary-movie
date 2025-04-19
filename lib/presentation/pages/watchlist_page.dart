import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/presentation/provider/watchlist_catalog_notifier.dart';
import 'package:ditonton/presentation/widgets/catalog_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-catalog';

  final Catalog catalog;

  const WatchlistPage({super.key, required this.catalog});

  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<WatchlistCatalogNotifier>(
        context,
        listen: false,
      ).fetchWatchlistMovies(widget.catalog),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    Provider.of<WatchlistCatalogNotifier>(
      context,
      listen: false,
    ).fetchWatchlistMovies(widget.catalog);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Watchlist ${widget.catalog.name}')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<WatchlistCatalogNotifier>(
          builder: (context, data, child) {
            if (data.watchlistState == RequestState.Loading) {
              return Center(child: CircularProgressIndicator());
            } else if (data.watchlistState == RequestState.Loaded) {
              if (data.watchlistCatalog.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bookmark_border, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No watchlist saved',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Add ${widget.catalog.name} to your watchlist',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemBuilder: (context, index) {
                  final catalogItem = data.watchlistCatalog[index];
                  return CatalogCard(catalogItem, widget.catalog);
                },
                itemCount: data.watchlistCatalog.length,
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

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
