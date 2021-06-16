class AboutApp {
  String version;
  String githubLink;
  String playStore;
  String description;
  List<Contributors> contributors;

  AboutApp(
      {this.version,
      this.githubLink,
      this.playStore,
      this.description,
      this.contributors});

  AboutApp.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    githubLink = json['githubLink'];
    playStore = json['playStore'];
    description = json['description'];
    if (json['contributors'] != null) {
      contributors = <Contributors>[];
      json['contributors'].forEach((v) {
        contributors.add(new Contributors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['githubLink'] = this.githubLink;
    data['playStore'] = this.playStore;
    data['description'] = this.description;
    if (this.contributors != null) {
      data['contributors'] = this.contributors.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Contributors {
  String twitter;
  String name;
  String github;
  String role;

  Contributors({this.twitter, this.name, this.github, this.role});

  Contributors.fromJson(Map<String, dynamic> json) {
    twitter = json['twitter'];
    name = json['name'];
    github = json['github'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['twitter'] = this.twitter;
    data['name'] = this.name;
    data['github'] = this.github;
    data['role'] = this.role;
    return data;
  }
}
