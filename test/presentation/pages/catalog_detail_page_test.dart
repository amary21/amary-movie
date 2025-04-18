import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/catalog.dart';
import 'package:ditonton/domain/entities/catalog_item.dart';
import 'package:ditonton/presentation/pages/catalog_detail_page.dart';
import 'package:ditonton/presentation/provider/catalog_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'catalog_detail_page_test.mocks.dart';

@GenerateMocks([CatalogDetailNotifier])
void main() {
  late MockCatalogDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockCatalogDetailNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<CatalogDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(mockNotifier.catalogState).thenReturn(RequestState.Loaded);
    when(mockNotifier.catalog).thenReturn(testCatalogDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.catalogRecommendations).thenReturn(<CatalogItem>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(CatalogDetailPage(id: 1, catalog: Catalog.movie)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(mockNotifier.catalogState).thenReturn(RequestState.Loaded);
    when(mockNotifier.catalog).thenReturn(testCatalogDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.catalogRecommendations).thenReturn(<CatalogItem>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(true);

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(CatalogDetailPage(id: 1, catalog: Catalog.movie)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  //TODO: fixing
  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(mockNotifier.catalogState).thenReturn(RequestState.Loaded);
    when(mockNotifier.catalog).thenReturn(testCatalogDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.catalogRecommendations).thenReturn(<CatalogItem>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockNotifier.watchlistMessage).thenReturn('Added to Watchlist');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(CatalogDetailPage(id: 1, catalog: Catalog.movie)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  //TODO: fixing
  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    when(mockNotifier.catalogState).thenReturn(RequestState.Loaded);
    when(mockNotifier.catalog).thenReturn(testCatalogDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.catalogRecommendations).thenReturn(<CatalogItem>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockNotifier.watchlistMessage).thenReturn('Failed');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(CatalogDetailPage(id: 1, catalog: Catalog.movie)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
