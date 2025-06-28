class cameraClass {
  String? created;
  String? id;
  String? ip;
  bool? isRtsp;
  String? name;
  String? port;
  String? rtspName;
  String? rtspUrl;
  String? updated;
  String? gate;
  String? username;
  String? password;

  cameraClass(
      {this.created,
      this.id,
      this.ip,
      this.isRtsp,
      this.name,
      this.port,
      this.rtspName,
      this.rtspUrl,
      this.gate,
      this.username,
      this.password,
      this.updated});

  cameraClass.fromJson(Map<String, dynamic> json) {
    created = json['created'];
    id = json['id'];
    ip = json['ip'];
    isRtsp = json['isRtsp'];
    name = json['name'];
    port = json['port'];
    rtspName = json['rtspName'];
    rtspUrl = json['rtspUrl'];
    updated = json['updated'];
    gate=json['gate'];
    username=json['username'];
    password=json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created'] = this.created;
    data['id'] = this.id;
    data['ip'] = this.ip;
    data['isRtsp'] = this.isRtsp;
    data['name'] = this.name;
    data['port'] = this.port;
    data['rtspName'] = this.rtspName;
    data['rtspUrl'] = this.rtspUrl;
    data['updated'] = this.updated;
    data['gate']=this.gate;
    data['username']=this.updated;
    data['password']=this.password;
    return data;
  }
}
