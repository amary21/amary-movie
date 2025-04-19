import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/presentation/provider/catalog_search_notifier.dart';
import 'package:ditonton/presentation/widgets/catalog_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  static const ROUTE_NAME = '/search';

  final Catalog catalog;
  const SearchPage({super.key, required this.catalog});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          Provider.of<CatalogSearchNotifier>(context, listen: false)
            ..resetData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search ${widget.catalog.name}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                Provider.of<CatalogSearchNotifier>(
                  context,
                  listen: false,
                ).fetchCatalogSearch(widget.catalog, query);
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text('Search Result', style: kHeading6),
            Consumer<CatalogSearchNotifier>(
              builder: (context, data, child) {
                if (data.state == RequestState.Loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (data.state == RequestState.Loaded) {
                  final result = data.searchResult;
                  if (result.isEmpty) {
                    return Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 80,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No results found',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Try different keywords',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final catalog = data.searchResult[index];
                        return CatalogCard(catalog, widget.catalog);
                      },
                      itemCount: result.length,
                    ),
                  );
                } else {
                  return Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search, size: 80, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Search for ${widget.catalog.name}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
