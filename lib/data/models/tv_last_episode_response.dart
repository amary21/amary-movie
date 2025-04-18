class TvLastEpisodeResponse {
  final int runtime;

  TvLastEpisodeResponse({required this.runtime});

  factory TvLastEpisodeResponse.fromJson(Map<String, dynamic> json) =>
      TvLastEpisodeResponse(runtime: json["runtime"] ?? 0);
}
