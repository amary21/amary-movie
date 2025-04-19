import 'package:ditonton/main.dart' as app;
import 'package:ditonton/domain/entities/catalog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Test', () {
    testWidgets('Verify empty watchlist message', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Open drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Navigate to watchlist page for movies
      await tester.tap(find.text('Watchlist Movies'));
      await tester.pumpAndSettle();

      // Verify empty watchlist message is displayed
      expect(find.text('No watchlist saved'), findsOneWidget);
      expect(find.text('Add Movies to your watchlist'), findsOneWidget);

      // Go back
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
    });

    testWidgets('Verify empty search results message', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Tap on search icon for movies
      await tester.tap(find.byIcon(Icons.search).first);
      await tester.pumpAndSettle();

      // Enter a search query that will likely not return results
      await tester.enterText(find.byType(TextField), 'xyznonexistentmovie');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      // Verify empty search results message is displayed
      expect(find.text('No results found'), findsOneWidget);
      expect(find.text('Try different keywords'), findsOneWidget);
    });

    testWidgets('Verify TV series detail shows season and episode info', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Navigate to TV series tab
      await tester.tap(find.text('TV Series'));
      await tester.pumpAndSettle();

      // Tap on the first TV series
      await tester.tap(find.byType(Card).first);
      await tester.pumpAndSettle();

      // Verify season and episode information is displayed
      // Note: This might not always pass if the API doesn't return season/episode info
      // or if the first TV series doesn't have this information
      expect(find.text('Seasons & Episodes'), findsOneWidget);
    });

    testWidgets('Test overall app navigation', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify home page is displayed
      expect(find.text('Movies'), findsOneWidget);
      expect(find.text('TV Series'), findsOneWidget);

      // Navigate to TV Series tab
      await tester.tap(find.text('TV Series'));
      await tester.pumpAndSettle();

      // Open drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Navigate to About page
      await tester.tap(find.text('About'));
      await tester.pumpAndSettle();

      // Verify About page is displayed
      expect(find.text('About'), findsOneWidget);

      // Go back to home
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
    });
  });
}