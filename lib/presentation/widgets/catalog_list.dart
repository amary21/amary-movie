import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/domain/entities/catalog_item.dart';
import 'package:ditonton/presentation/pages/catalog_detail_page.dart';
import 'package:flutter/material.dart';

class CatalogList extends StatelessWidget {
  final List<CatalogItem> nowPlaying;
  final Catalog catalog;
  
  const CatalogList(this.nowPlaying, this.catalog, {super.key});

  @override
  Widget build(BuildContext context) {
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
