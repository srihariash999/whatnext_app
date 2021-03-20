class Picture {
  double aspectRatio;
  String filePath;
  int height;
  double voteAverage;
  int voteCount;
  int width;

  Picture(
      {this.aspectRatio,
      this.filePath,
      this.height,
      this.voteAverage,
      this.voteCount,
      this.width});

  Picture.fromJson(Map<String, dynamic> json) {
    aspectRatio = json['aspect_ratio'];
    filePath = json['file_path'];
    height = json['height'];

    voteAverage = json['vote_average'];
    voteCount = json['vote_count'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aspect_ratio'] = this.aspectRatio;
    data['file_path'] = this.filePath;
    data['height'] = this.height;

    data['vote_average'] = this.voteAverage;
    data['vote_count'] = this.voteCount;
    data['width'] = this.width;
    return data;
  }
}
