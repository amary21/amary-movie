import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/tv_table.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

import 'database_helper_test.mocks.dart';

@GenerateMocks([Database])
void main() {
  late DatabaseHelper dbHelper;
  late MockDatabase mockDb;

  setUp(() {
    mockDb = MockDatabase();
    dbHelper = DatabaseHelper(mockDb);
  });

  test('should init with injected db path and openDb', () async {
    final mockDb = MockDatabase();

    final mockOpenDb = (String path, {int? version, onCreate}) async => mockDb;
    final mockGetPath = () async => '/fake/path';

    final helper = await DatabaseHelper.init(
      openDb: mockOpenDb,
      getPath: mockGetPath,
    );

    expect(helper, isA<DatabaseHelper>());
  });

  group('DatabaseHelper movie', () {
    final testMovie = MovieTable(
      id: 1,
      title: 'Test Movie',
      overview: 'Overview',
      posterPath: '/poster.png',
    );

    final tblWatchlist = 'watchlist';

    test('should insert movie to watchlist', () async {
      when(
        mockDb.insert(tblWatchlist, testMovie.toJson()),
      ).thenAnswer((_) async => 1);

      final result = await dbHelper.insertWatchlist(testMovie);

      expect(result, 1);
      verify(mockDb.insert(tblWatchlist, testMovie.toJson()));
    });

    test('should remove movie from watchlist', () async {
      when(
        mockDb.delete(
          tblWatchlist,
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
        ),
      ).thenAnswer((_) async => 1);

      final result = await dbHelper.removeWatchlist(testMovie);

      expect(result, 1);
      verify(
        mockDb.delete(tblWatchlist, where: 'id = ?', whereArgs: [testMovie.id]),
      );
    });

    test('should get movie by id', () async {
      when(
        mockDb.query(
          tblWatchlist,
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
        ),
      ).thenAnswer((_) async => [testMovie.toJson()]);

      final result = await dbHelper.getMovieById(testMovie.id);

      expect(result, testMovie.toJson());
    });

    test('should return null when movie not found', () async {
      when(
        mockDb.query(
          tblWatchlist,
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
        ),
      ).thenAnswer((_) async => []);

      final result = await dbHelper.getMovieById(testMovie.id);

      expect(result, null);
    });

    test('should return list of movie watchlist from db', () async {
      final mockResult = [
        {
          'id': 1,
          'title': 'Test Movie',
          'overview': 'Overview',
          'posterPath': '/poster.png',
        },
      ];

      when(mockDb.query('watchlist')).thenAnswer((_) async => mockResult);

      final result = await dbHelper.getWatchlistMovies();

      expect(result, mockResult);
      verify(mockDb.query('watchlist'));
    });
  });

  group('Databasehelper tv', () {
    final testTv = TvTable(
      id: 2,
      name: 'Test TV',
      overview: 'Overview',
      posterPath: '/poster.png',
    );

    final _tblTvWatchlist = 'watchlistTv';

    test('should insert tv to watchlist', () async {
      when(
        mockDb.insert(_tblTvWatchlist, testTv.toJson()),
      ).thenAnswer((_) async => 1);

      final result = await dbHelper.insertWatchlistTv(testTv);

      expect(result, 1);
      verify(mockDb.insert(_tblTvWatchlist, testTv.toJson()));
    });

    test('should remove tv from watchlist', () async {
      when(
        mockDb.delete(
          _tblTvWatchlist,
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
        ),
      ).thenAnswer((_) async => 1);

      final result = await dbHelper.removeWatchlistTv(testTv);

      expect(result, 1);
      verify(
        mockDb.delete(_tblTvWatchlist, where: 'id = ?', whereArgs: [testTv.id]),
      );
    });

    test('should get tv by id', () async {
      when(
        mockDb.query(
          _tblTvWatchlist,
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
        ),
      ).thenAnswer((_) async => [testTv.toJson()]);

      final result = await dbHelper.getTvById(testTv.id);

      expect(result, testTv.toJson());
    });

    test('should return null when tv not found', () async {
      when(
        mockDb.query(
          _tblTvWatchlist,
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
        ),
      ).thenAnswer((_) async => []);

      final result = await dbHelper.getTvById(testTv.id);

      expect(result, null);
    });

    test('should return list of TV watchlist from db', () async {
      final mockResult = [
        {
          'id': 2,
          'name': 'Test TV',
          'overview': 'Overview',
          'posterPath': '/poster.png',
        },
      ];

      when(mockDb.query('watchlistTv')).thenAnswer((_) async => mockResult);

      final result = await dbHelper.getWatchlistTvs();

      expect(result, mockResult);
      verify(mockDb.query('watchlistTv'));
    });
  });
}
