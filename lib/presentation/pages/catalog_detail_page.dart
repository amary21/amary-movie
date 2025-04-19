import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/domain/entities/catalog_detail.dart';
import 'package:ditonton/domain/entities/catalog_item.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/presentation/provider/catalog_detail_notifier.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class CatalogDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail';

  final int id;
  final Catalog catalog;
  CatalogDetailPage({required this.id, required this.catalog});

  @override
  _CatalogDetailPageState createState() => _CatalogDetailPageState();
}

class _CatalogDetailPageState extends State<CatalogDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CatalogDetailNotifier>(
        context,
        listen: false,
      ).fetchDetail(widget.catalog, widget.id);
      Provider.of<CatalogDetailNotifier>(
        context,
        listen: false,
      ).loadWatchlistStatus(widget.catalog, widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CatalogDetailNotifier>(
        builder: (context, provider, child) {
          if (provider.catalogState == RequestState.Loading) {
            return Center(child: CircularProgressIndicator());
          } else if (provider.catalogState == RequestState.Loaded) {
            final movie = provider.catalog;
            return SafeArea(
              child: DetailContent(
                movie,
                provider.catalogRecommendations,
                provider.isAddedToWatchlist,
                widget.catalog,
              ),
            );
          } else {
            return Text(provider.message);
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final CatalogDetail catalogDetail;
  final List<CatalogItem> recommendations;
  final bool isAddedWatchlist;
  final Catalog catalog;

  DetailContent(
    this.catalogDetail,
    this.recommendations,
    this.isAddedWatchlist,
    this.catalog,
  );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${catalogDetail.posterPath}',
          width: screenWidth,
          placeholder:
              (context, url) => Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(catalogDetail.title, style: kHeading5),
                            FilledButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  await Provider.of<CatalogDetailNotifier>(
                                    context,
                                    listen: false,
                                  ).addWatchlist(catalog, catalogDetail);
                                } else {
                                  // TODO: implement watchlist feature
                                  // await Provider.of<CatalogDetailNotifier>(
                                  //   context,
                                  //   listen: false,
                                  // ).removeFromWatchlist(movie);
                                }

                                final message =
                                    Provider.of<CatalogDetailNotifier>(
                                      context,
                                      listen: false,
                                    ).watchlistMessage;

                                if (message ==
                                        CatalogDetailNotifier
                                            .watchlistAddSuccessMessage ||
                                    message ==
                                        CatalogDetailNotifier
                                            .watchlistRemoveSuccessMessage) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(message)),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(message),
                                      );
                                    },
                                  );
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? Icon(Icons.check)
                                      : Icon(Icons.add),
                                  Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(_showGenres(catalogDetail.genres)),
                            Text(_showDuration(catalog, catalogDetail.runtime)),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: catalogDetail.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder:
                                      (context, index) => Icon(
                                        Icons.star,
                                        color: kMikadoYellow,
                                      ),
                                  itemSize: 24,
                                ),
                                Text('${catalogDetail.voteAverage}'),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text('Overview', style: kHeading6),
                            Text(catalogDetail.overview),
                            SizedBox(height: 16),
                            Text('Recommendations', style: kHeading6),
                            Consumer<CatalogDetailNotifier>(
                              builder: (context, data, child) {
                                if (data.recommendationState ==
                                    RequestState.Loading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (data.recommendationState ==
                                    RequestState.Error) {
                                  return Text(data.message);
                                } else if (data.recommendationState ==
                                    RequestState.Loaded) {
                                  return Container(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final catalogItem = recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                CatalogDetailPage.ROUTE_NAME,
                                                arguments: {
                                                  'id': catalogItem.id,
                                                  'catalog': catalog,
                                                },
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${catalogItem.posterPath}',
                                                placeholder:
                                                    (context, url) => Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: recommendations.length,
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(Catalog catalog, int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;
    final episode = catalog == Catalog.tv ? 'Per Eps' : '';

    if (hours > 0) {
      return '${hours}h ${minutes}m $episode';
    } else {
      return '${minutes}m $episode';
    }
  }
}
