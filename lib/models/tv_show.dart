class TvShow {
  String posterPath;
  double popularity;
  int id;
  String overview;
  String backdropPath;
  double voteAverage;
  String firstAirDate;
  List<String> originCountry;
  List<int> genreIds;
  String originalLanguage;
  double voteCount;
  String name;
  String originalName;

  TvShow(
      {this.posterPath,
      this.popularity,
      this.id,
      this.overview,
      this.backdropPath,
      this.voteAverage,
      this.firstAirDate,
      this.originCountry,
      this.genreIds,
      this.originalLanguage,
      this.voteCount,
      this.name,
      this.originalName});

  TvShow.fromJson(Map<String, dynamic> json) {
    posterPath = json['poster_path'];
    popularity = json['popularity'].toDouble();
    id = json['id'];
    overview = json['overview'];
    backdropPath = json['backdrop_path'];
    voteAverage = json['vote_average'].toDouble();
    firstAirDate = json['first_air_date'];
    originCountry = json['origin_country'].cast<String>();
    genreIds = json['genre_ids'].cast<int>();
    originalLanguage = json['original_language'];
    voteCount = json['vote_count'].toDouble();
    name = json['name'];
    originalName = json['original_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['poster_path'] = this.posterPath;
    data['popularity'] = this.popularity;
    data['id'] = this.id;
    data['overview'] = this.overview;
    data['backdrop_path'] = this.backdropPath;
    data['vote_average'] = this.voteAverage;
    data['first_air_date'] = this.firstAirDate;
    data['origin_country'] = this.originCountry;
    data['genre_ids'] = this.genreIds;
    data['original_language'] = this.originalLanguage;
    data['vote_count'] = this.voteCount;
    data['name'] = this.name;
    data['original_name'] = this.originalName;
    return data;
  }
}
