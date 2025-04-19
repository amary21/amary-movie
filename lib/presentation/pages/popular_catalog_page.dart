import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/presentation/bloc/popular/popular_catalog_bloc.dart';
import 'package:ditonton/presentation/bloc/popular/popular_catalog_event.dart';
import 'package:ditonton/presentation/bloc/popular/popular_catalog_state.dart';
import 'package:ditonton/presentation/widgets/catalog_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PopularCatalogBloc>().add(
        FetchPopularCatalog(widget.catalog),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Popular ${widget.catalog.name}')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularCatalogBloc, PopularCatalogState>(
          builder: (context, state) {
            switch (state) {
              case PopularCatalogLoading():
                return const Center(child: CircularProgressIndicator());
              case PopularCatalogHasData(:final items):
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final catalogItem = items[index];
                    return CatalogCard(catalogItem, widget.catalog);
                  },
                );
              case PopularCatalogError(:final message):
                return Center(
                  key: const Key('error_message'),
                  child: Text(message),
                );
              default:
                return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
