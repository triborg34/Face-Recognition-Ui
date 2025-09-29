class SettingClass {
  String? collectionId;
  String? collectionName;
  String? id;
  double? score;
  double? hScore;
  int? padding;
  double? quality;
  String? ip;
  String? port;
  bool? isRfid;
  String? rfidip;
  int? rfidport;
  bool? rl1;
  bool? rl2;
  bool? rfconnect;
  bool? isAlarm;
  String? created;
  String? updated;
  bool? isregion;

  SettingClass(
      {this.collectionId,
      this.collectionName,
      this.id,
      this.score,
      this.padding,
      this.quality,
      this.hScore,
      this.ip,
      this.port,
      this.isRfid,
      this.rfidip,
      this.rfidport,
      this.rl1,
      this.rl2,
      this.rfconnect,
      this.isAlarm,
      this.created,
      this.isregion,
      this.updated});

  SettingClass.fromJson(Map<String, dynamic> json) {
    collectionId = json['collectionId'];
    collectionName = json['collectionName'];
    id = json['id'];
    score = json['score'];
    padding = json['padding'];
    quality = json['quality'];
    ip = json['ip'];
    port = json['port'];
    isRfid = json['isRfid'];
    rfidip = json['rfidip'];
    rfidport = json['rfidport'];
    rl1 = json['rl1'];
    rl2 = json['rl2'];
    rfconnect = json['rfconnect'];
    isAlarm = json['isAlarm'];
    created = json['created'];
    updated = json['updated'];
    hScore=json['hscore'];
    isregion=json['isregion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['collectionId'] = this.collectionId;
    data['collectionName'] = this.collectionName;
    data['id'] = this.id;
    data['score'] = this.score;
    data['padding'] = this.padding;
    data['quality'] = this.quality;
    data['ip'] = this.ip;
    data['port'] = this.port;
    data['isRfid'] = this.isRfid;
    data['rfidip'] = this.rfidip;
    data['rfidport'] = this.rfidport;
    data['rl1'] = this.rl1;
    data['rl2'] = this.rl2;
    data['rfconnect'] = this.rfconnect;
    data['isAlarm'] = this.isAlarm;
    data['created'] = this.created;
    data['updated'] = this.updated;
    data['hscore']=this.hScore;
    data['isregion']=this.isregion;
    return data;
  }
}