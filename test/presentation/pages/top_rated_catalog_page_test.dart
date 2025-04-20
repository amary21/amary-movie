import 'package:domain/domain.dart';
import 'package:ditonton/presentation/bloc/top_rated/top_rated_catalog_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated/top_rated_catalog_state.dart';
import 'package:ditonton/presentation/pages/top_rated_catalog_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'top_rated_catalog_page_test.mocks.dart';

@GenerateNiceMocks([MockSpec<TopRatedCatalogBloc>()])
void main() {
  late MockTopRatedCatalogBloc mockBloc;

  setUp(() {
    mockBloc = MockTopRatedCatalogBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<TopRatedCatalogBloc>.value(
        value: mockBloc,
        child: body,
      ),
    );
  }

  testWidgets('should show CircularProgressIndicator when loading', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(TopRatedCatalogLoading());
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(
      makeTestableWidget(TopRatedCatalogPage(catalog: Catalog.movie)),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    when(
      mockBloc.state,
    ).thenReturn(TopRatedCatalogHasData(testCatalogItemList));
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(
      makeTestableWidget(TopRatedCatalogPage(catalog: Catalog.movie)),
    );

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('should show error message when error occurs', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(TopRatedCatalogError('Error message'));
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(
      makeTestableWidget(TopRatedCatalogPage(catalog: Catalog.movie)),
    );

    expect(find.byKey(Key('error_message')), findsOneWidget);
    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('should show empty Container when state is not handled', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(TopRatedCatalogEmpty());
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(
      makeTestableWidget(TopRatedCatalogPage(catalog: Catalog.movie)),
    );

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(ListView), findsNothing);
    expect(find.byKey(Key('error_message')), findsNothing);
  });
}
