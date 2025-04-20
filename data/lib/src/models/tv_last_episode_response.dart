import 'package:equatable/equatable.dart';

class TvLastEpisodeResponse extends Equatable {
  final int runtime;

  const TvLastEpisodeResponse({required this.runtime});

  factory TvLastEpisodeResponse.fromJson(Map<String, dynamic> json) =>
      TvLastEpisodeResponse(runtime: json["runtime"] ?? 0);

  @override
  List<Object?> get props => [runtime];
}
