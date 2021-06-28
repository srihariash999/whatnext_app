class Message {
  String message;
  String addedOn;
  String from;
  String to;

  Message({ this.message, this.addedOn, this.from, this.to});

  Message.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    addedOn = json['addedOn'];
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['addedOn'] = this.addedOn;
    data['from'] = this.from;
    data['to'] = this.to;
    return data;
  }
}