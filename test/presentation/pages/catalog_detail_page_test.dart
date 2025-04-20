import 'package:domain/domain.dart';
import 'package:ditonton/presentation/bloc/detail/catalog_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/detail/catalog_detail_state.dart';
import 'package:ditonton/presentation/pages/catalog_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'catalog_detail_page_test.mocks.dart';

@GenerateNiceMocks([MockSpec<CatalogDetailBloc>()])
void main() {
  late MockCatalogDetailBloc mockBloc;

  setUp(() {
    mockBloc = MockCatalogDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<CatalogDetailBloc>.value(value: mockBloc, child: body),
    );
  }

  testWidgets(
    'Watchlist button should display add icon when movie not added to watchlist',
    (WidgetTester tester) async {
      when(mockBloc.state).thenReturn(
        CatalogDetailHasData(
          catalogDetail: testCatalogDetail,
          recommendations: testCatalogItemList,
          isAddedToWatchlist: false,
          message: '',
        ),
      );
      when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

      final watchlistButtonIcon = find.byIcon(Icons.add);

      await tester.pumpWidget(
        makeTestableWidget(CatalogDetailPage(id: 1, catalog: Catalog.movie)),
      );

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should dispay check icon when movie is added to wathclist',
    (WidgetTester tester) async {
      when(mockBloc.state).thenReturn(
        CatalogDetailHasData(
          catalogDetail: testCatalogDetail,
          recommendations: testCatalogItemList,
          isAddedToWatchlist: true,
          message: '',
        ),
      );
      when(mockBloc.stream).thenAnswer((_) => const Stream.empty());
      final watchlistButtonIcon = find.byIcon(Icons.check);

      await tester.pumpWidget(
        makeTestableWidget(CatalogDetailPage(id: 1, catalog: Catalog.movie)),
      );

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display Snackbar when added to watchlist',
    (WidgetTester tester) async {
      when(mockBloc.state).thenReturn(
        CatalogDetailHasData(
          catalogDetail: testCatalogDetail,
          recommendations: testCatalogItemList,
          isAddedToWatchlist: false,
          message: '',
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          const CatalogDetailWatchlistMessage('Added to Watchlist'),
        ]),
      );

      final watchlistButton = find.byType(FilledButton);

      await tester.pumpWidget(
        makeTestableWidget(CatalogDetailPage(id: 1, catalog: Catalog.movie)),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Added to Watchlist'), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display AlertDialog when add to watchlist failed',
    (WidgetTester tester) async {
      when(mockBloc.state).thenReturn(
        CatalogDetailHasData(
          catalogDetail: testCatalogDetail,
          recommendations: testCatalogItemList,
          isAddedToWatchlist: false,
          message: '',
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([CatalogDetailWatchlistMessage('Failed')]),
      );

      final watchlistButton = find.byType(FilledButton);

      await tester.pumpWidget(
        makeTestableWidget(CatalogDetailPage(id: 1, catalog: Catalog.movie)),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton, warnIfMissed: false);
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
    },
  );
}
