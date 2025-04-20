import 'package:domain/domain.dart';
import 'package:ditonton/presentation/bloc/popular/popular_catalog_bloc.dart';
import 'package:ditonton/presentation/bloc/popular/popular_catalog_state.dart';
import 'package:ditonton/presentation/pages/popular_catalog_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'popular_catalog_page_test.mocks.dart';

@GenerateNiceMocks([MockSpec<PopularCatalogBloc>()])
void main() {
  late MockPopularCatalogBloc mockBloc;

  setUp(() {
    mockBloc = MockPopularCatalogBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<PopularCatalogBloc>.value(
        value: mockBloc,
        child: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(PopularCatalogLoading());
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(
      PopularCatalogPage(catalog: Catalog.movie),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(Center), findsWidgets);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {

    when(mockBloc.state).thenReturn(PopularCatalogHasData(testCatalogItemList));
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(
      PopularCatalogPage(catalog: Catalog.movie),
    ));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display error message when error',
      (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(PopularCatalogError('Error message'));
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(
      PopularCatalogPage(catalog: Catalog.tv),
    ));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text('Error message'), findsOneWidget);
  });
}
