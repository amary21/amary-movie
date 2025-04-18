import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';

class TvTable extends Equatable {
  TvTable({
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.name,
  });

  int id;
  String overview;
  String posterPath;
  String name;

  factory TvTable.fromEntity(TvDetail tv) => TvTable(
        id: tv.id,
        overview: tv.overview,
        posterPath: tv.posterPath,
        name: tv.name,
      );

  factory TvTable.fromMap(Map<String, dynamic> json) => TvTable(
        id: json["id"],
        overview: json["overview"],
        posterPath: json["posterPath"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "overview": overview,
        "poster_path": posterPath,
        "name": name,
      };

  Tv toEntity() => Tv.watchlist(
        id: id,
        overview: overview,
        posterPath: posterPath,
        name: name,
      );

  @override
  List<Object?> get props => [id, overview, posterPath, name];
}
