import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvModel = TvModel(
    adult : false,
    backdropPath : 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originCountry : ['originCountry'],
    originalLanguage : 'originalLanguage',
    originalName : 'originalName',
    overview : 'overview',
    popularity : 1,
    posterPath : 'posterPath',
    firstAirDate : "2023-10-01",
    name : 'name',
    voteAverage : 1,
    voteCount : 1,
  );

  final tTv = Tv(
    adult : false,
    backdropPath : 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originCountry : ['originCountry'],
    originalLanguage : 'originalLanguage',
    originalName : 'originalName',
    overview : 'overview',
    popularity : 1,
    posterPath : 'posterPath',
    firstAirDate : "2023-10-01",
    name : 'name',
    voteAverage : 1,
    voteCount : 1,
  );

  test('should be a subclass of Tv entity', () async {
    final result = tTvModel.toEntity();
    expect(result, tTv);
  });
}
