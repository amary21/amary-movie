import 'dart:convert';

import 'package:data/data.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/json_reader.dart';

void main() {
  final tTvModel = TvModel(
      adult: false,
      backdropPath: '/gMMnf8VRg3Z98WaFmOLr9Jk8pIs.jpg',
      genreIds: [35, 10767],
      id: 63770,
      originCountry: ['US'],
      originalLanguage: 'en',
      originalName: 'The Late Show with Stephen Colbert',
      overview:
          'Stephen Colbert brings his signature satire and comedy to The Late Show with Stephen Colbert, the #1 show in late night, where he talks with an eclectic mix of guests about what is new and relevant in the worlds of politics, entertainment, business, music, technology, and more. Featuring bandleader Jon Batiste with his band Stay Human, the Emmy Award-nominated show is broadcast from the historic Ed Sullivan Theater. Stephen Colbert, Chris Licht, Tom Purcell, and Jon Stewart are executive producers. Barry Julien and Denise Rehrig serve as co-executive producers.must watch',
      popularity: 469.0656,
      posterPath: '/9jkThAGYj2yp8jsS6Nriy5mzKFT.jpg',
      firstAirDate: "2015-09-08",
      name: 'The Late Show with Stephen Colbert',
      voteAverage: 6.403,
      voteCount: 300);
  final tTvResponseModel = TvResponse(tvList: <TvModel>[tTvModel]);
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('src/helpers/now_playing_tv.json'));
      // act
      final result = TvResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTvResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "adult": false,
            "backdrop_path": "/gMMnf8VRg3Z98WaFmOLr9Jk8pIs.jpg",
            "genre_ids": [35, 10767],
            "id": 63770,
            "origin_country": ["US"],
            "original_language": "en",
            "original_name": "The Late Show with Stephen Colbert",
            "overview":
                "Stephen Colbert brings his signature satire and comedy to The Late Show with Stephen Colbert, the #1 show in late night, where he talks with an eclectic mix of guests about what is new and relevant in the worlds of politics, entertainment, business, music, technology, and more. Featuring bandleader Jon Batiste with his band Stay Human, the Emmy Award-nominated show is broadcast from the historic Ed Sullivan Theater. Stephen Colbert, Chris Licht, Tom Purcell, and Jon Stewart are executive producers. Barry Julien and Denise Rehrig serve as co-executive producers.must watch",
            "popularity": 469.0656,
            "poster_path": "/9jkThAGYj2yp8jsS6Nriy5mzKFT.jpg",
            "first_air_date": "2015-09-08",
            "name": "The Late Show with Stephen Colbert",
            "vote_average": 6.403,
            "vote_count": 300
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
