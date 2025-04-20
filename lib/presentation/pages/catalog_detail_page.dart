import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/domain/entities/catalog_detail.dart';
import 'package:ditonton/domain/entities/catalog_item.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/presentation/bloc/detail/catalog_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/detail/catalog_detail_event.dart';
import 'package:ditonton/presentation/bloc/detail/catalog_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CatalogDetailPage extends StatefulWidget {
  static const routeName = '/detail';

  final int id;
  final Catalog catalog;
  const CatalogDetailPage({super.key, required this.id, required this.catalog});

  @override
  _CatalogDetailPageState createState() => _CatalogDetailPageState();
}

class _CatalogDetailPageState extends State<CatalogDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CatalogDetailBloc>().add(
        FetchCatalogDetail(widget.catalog, widget.id),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CatalogDetailBloc, CatalogDetailState>(
        listener: (context, state) {
          if (state is CatalogDetailWatchlistMessage) {
            final message = state.message;
            if (message == 'Added to Watchlist' ||
                message == 'Removed from Watchlist') {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
            } else {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(content: Text(message)),
              );
            }
          }
        },
        builder: (context, state) {
          switch (state) {
            case CatalogDetailLoading():
              return const Center(child: CircularProgressIndicator());
            case CatalogDetailHasData(
              :final catalogDetail,
              :final recommendations,
              :final isAddedToWatchlist,
            ):
              return SafeArea(
                child: DetailContent(
                  catalogDetail: catalogDetail,
                  recommendations: recommendations,
                  isAddedWatchlist: isAddedToWatchlist,
                  catalog: widget.catalog,
                ),
              );
            case CatalogDetailError(:final message):
              return Center(child: Text(message));
            default:
              return SizedBox();
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

  const DetailContent({
    super.key,
    required this.catalogDetail,
    required this.recommendations,
    required this.isAddedWatchlist,
    required this.catalog,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl:
              'https://image.tmdb.org/t/p/w500${catalogDetail.posterPath}',
          width: screenWidth,
          placeholder:
              (context, url) => Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 56),
          child: DraggableScrollableSheet(
            minChildSize: 0.25,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(catalogDetail.title, style: kHeading5),
                      FilledButton(
                        onPressed: () {
                          final bloc = context.read<CatalogDetailBloc>();
                          if (!isAddedWatchlist) {
                            bloc.add(AddToWatchlist(catalog, catalogDetail, recommendations));
                          } else {
                            bloc.add(
                              RemoveFromWatchlist(catalog, catalogDetail, recommendations),
                            );
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(isAddedWatchlist ? Icons.check : Icons.add),
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
                                (context, index) =>
                                    Icon(Icons.star, color: kMikadoYellow),
                            itemSize: 24,
                          ),
                          Text('${catalogDetail.voteAverage}'),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text('Overview', style: kHeading6),
                      Text(catalogDetail.overview),
                      SizedBox(height: 16),
                      if (catalog == Catalog.tv &&
                          (catalogDetail.numberOfSeasons > 0 ||
                              catalogDetail.numberOfEpisodes > 0))
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Seasons & Episodes', style: kHeading6),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.calendar_today, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  '${catalogDetail.numberOfSeasons} Season${catalogDetail.numberOfSeasons > 1 ? 's' : ''}',
                                ),
                                SizedBox(width: 16),
                                Icon(Icons.video_library, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  '${catalogDetail.numberOfEpisodes} Episode${catalogDetail.numberOfEpisodes > 1 ? 's' : ''}',
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                      Text('Recommendations', style: kHeading6),
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: recommendations.length,
                          itemBuilder: (context, index) {
                            final item = recommendations[index];
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    CatalogDetailPage.routeName,
                                    arguments: {
                                      'id': item.id,
                                      'catalog': catalog,
                                    },
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        'https://image.tmdb.org/t/p/w500${item.posterPath}',
                                    placeholder:
                                        (context, url) => Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                    errorWidget:
                                        (context, url, error) =>
                                            Icon(Icons.error),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    return genres.map((g) => g.name).join(', ');
  }

  String _showDuration(Catalog catalog, int runtime) {
    final hours = runtime ~/ 60;
    final minutes = runtime % 60;
    final suffix = catalog == Catalog.tv ? 'Per Eps' : '';
    return hours > 0 ? '${hours}h ${minutes}m $suffix' : '${minutes}m $suffix';
  }
}
