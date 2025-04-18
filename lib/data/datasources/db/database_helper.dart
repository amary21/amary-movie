import 'dart:async';
import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/tv_table.dart';
import 'package:sqflite/sqflite.dart';

typedef OpenDbFn = Future<Database> Function(String path,
    {int version, OnDatabaseCreateFn? onCreate});

typedef GetDbPathFn = Future<String> Function();

class DatabaseHelper {
  final Database _db;

  DatabaseHelper(this._db);

  static const String _tblWatchlist = 'watchlist';
  static const String _tblTvWatchlist = 'watchlistTv';

  static Future<DatabaseHelper> init({
    OpenDbFn openDb = openDatabase,
    GetDbPathFn getPath = getDatabasesPath,
  }) async {
    final path = await getPath();
    final dbPath = '$path/ditonton.db';

    final db = await openDb(
      dbPath,
      version: 1,
      onCreate: _onCreate,
    );

    return DatabaseHelper(db);
  }

  static void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tblWatchlist (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE $_tblTvWatchlist (
        id INTEGER PRIMARY KEY,
        name TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
  }

  Future<int> insertWatchlist(MovieTable movie) async {
    return await _db.insert(_tblWatchlist, movie.toJson());
  }

  Future<int> insertWatchlistTv(TvTable tv) async {
    return await _db.insert(_tblTvWatchlist, tv.toJson());
  }

  Future<int> removeWatchlist(MovieTable movie) async {
    return await _db.delete(
      _tblWatchlist,
      where: 'id = ?',
      whereArgs: [movie.id],
    );
  }

  Future<int> removeWatchlistTv(TvTable tv) async {
    return await _db.delete(
      _tblTvWatchlist,
      where: 'id = ?',
      whereArgs: [tv.id],
    );
  }

  Future<Map<String, dynamic>?> getMovieById(int id) async {
    final results = await _db.query(
      _tblWatchlist,
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<Map<String, dynamic>?> getTvById(int id) async {
    final results = await _db.query(
      _tblTvWatchlist,
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<List<Map<String, dynamic>>> getWatchlistMovies() async {
    return await _db.query(_tblWatchlist);
  }

  Future<List<Map<String, dynamic>>> getWatchlistTvs() async {
    return await _db.query(_tblTvWatchlist);
  }
}
