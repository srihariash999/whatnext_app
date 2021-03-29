class Feed {
  String addedOn;
  int id;
  String name;
  String poster;
  String status;
  String type;
  String userName;

  Feed(
      {this.addedOn,
      this.id,
      this.name,
      this.poster,
      this.status,
      this.type,
      this.userName});

  Feed.fromJson(Map<String, dynamic> json) {
    addedOn = json['addedOn'];
    id = json['id'];
    name = json['name'];
    poster = json['poster'];
    status = json['status'];
    type = json['type'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addedOn'] = this.addedOn;
    data['id'] = this.id;
    data['name'] = this.name;
    data['poster'] = this.poster;
    data['status'] = this.status;
    data['type'] = this.type;
    data['userName'] = this.userName;
    return data;
  }
}