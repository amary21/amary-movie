import 'package:ditonton/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Test', () {
    testWidgets('Verify empty watchlist message', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.byType(IconButton).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Watchlist Movies'));
      await tester.pumpAndSettle();

      expect(find.text('No watchlist saved'), findsOneWidget);
      expect(find.text('Add Movies to your watchlist'), findsOneWidget);

      await tester.tap(find.byType(IconButton).first);
      await tester.pumpAndSettle();
    });

    testWidgets('Verify empty search results message', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.byType(IconButton).last);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'xyznonexistentmovie');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      expect(find.text('No results found'), findsOneWidget);
      expect(find.text('Try different keywords'), findsOneWidget);
    });

    testWidgets('Verify TV series detail shows season and episode info', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.byType(IconButton).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tv Series'));
      await tester.pumpAndSettle();

      if (find.byType(Card).evaluate().isEmpty) {
        return;
      }

      await tester.tap(find.byType(Card).first);
      await tester.pumpAndSettle();

      expect(find.text('Seasons & Episodes'), findsOneWidget);
    });

    testWidgets('Test overall app navigation', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.byType(IconButton).first);
      await tester.pumpAndSettle();

      expect(find.text('Movies'), findsOneWidget);
      expect(find.text('Tv Series'), findsOneWidget);

      await tester.tap(find.text('Tv Series'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(IconButton).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('About'));
      await tester.pumpAndSettle();

      expect(
        find.text('Ditonton merupakan sebuah aplikasi katalog film yang dikembangkan oleh Dicoding Indonesia sebagai contoh proyek aplikasi untuk kelas Menjadi Flutter Developer Expert.'),
        findsOneWidget,
        reason: "About page content should be present",
      );

      await tester.tap(find.byType(IconButton).first);
      await tester.pumpAndSettle();
    });
  });
}
