import 'package:domain/domain.dart';
import 'package:ditonton/presentation/bloc/top_rated/top_rated_catalog_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated/top_rated_catalog_event.dart';
import 'package:ditonton/presentation/bloc/top_rated/top_rated_catalog_state.dart';
import 'package:ditonton/presentation/widgets/catalog_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TopRatedCatalogBloc>().add(
        FetchTopRatedCatalog(widget.catalog),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Top Rated Movies')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedCatalogBloc, TopRatedCatalogState>(
          builder: (context, state) {
            switch (state) {
              case TopRatedCatalogLoading():
                return Center(child: CircularProgressIndicator());
              case TopRatedCatalogHasData(:final catalogItems):
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final movie = catalogItems[index];
                    return CatalogCard(movie, widget.catalog);
                  },
                  itemCount: catalogItems.length,
                );
              case TopRatedCatalogError(:final message):
                return Center(key: Key('error_message'), child: Text(message));
              default:
                return Center(child: Text('No data'));
            }
          },
        ),
      ),
    );
  }
}
