import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/search.dart';

class SearchPage extends StatefulWidget {
  static const routeName = '/search';

  final Catalog catalog;
  const SearchPage({super.key, required this.catalog});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchBloc>().add(OnResetSearch());
    });
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
                context.read<SearchBloc>().add(
                  OnQueryChanged(query, widget.catalog),
                );
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
            BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                switch (state) {
                  case SearchLoading():
                    return const Center(child: CircularProgressIndicator());

                  case SearchHasData(:final result):
                    if (result.isEmpty) {
                      return Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
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
                        itemCount: result.length,
                        itemBuilder: (context, index) {
                          final catalog = result[index];
                          // return CatalogCard(catalog, widget.catalog);
                          return SizedBox();
                        },
                      ),
                    );

                  case SearchError(:final message):
                    return Expanded(child: Center(child: Text(message)));

                  default:
                    return Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.search,
                              size: 80,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Search for ${widget.catalog.name}',
                              style: const TextStyle(fontSize: 16),
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
