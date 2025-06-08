class personClass {
  String? age;
  String? camera;
  String? collectionId;
  String? collectionName;
  String? croppedFrame;
  String? date;
  String? frame;
  String? gender;
  String? id;
  String? name;
  int? score;
  String? time;
  String? trackId;

  personClass(
      {this.age,
      this.camera,
      this.collectionId,
      this.collectionName,
      this.croppedFrame,
      this.date,
      this.frame,
      this.gender,
      this.id,
      this.name,
      this.score,
      this.time,
      this.trackId});

  personClass.fromJson(Map<String, dynamic> json) {
    age = json['age'];
    camera = json['camera'];
    collectionId = json['collectionId'];
    collectionName = json['collectionName'];
    croppedFrame = json['cropped_frame'];
    date = json['date'];
    frame = json['frame'];
    gender = json['gender'];
    id = json['id'];
    name = json['name'];
    score = json['score'];
    time = json['time'];
    trackId = json['track_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age'] = this.age;
    data['camera'] = this.camera;
    data['collectionId'] = this.collectionId;
    data['collectionName'] = this.collectionName;
    data['cropped_frame'] = this.croppedFrame;
    data['date'] = this.date;
    data['frame'] = this.frame;
    data['gender'] = this.gender;
    data['id'] = this.id;
    data['name'] = this.name;
    data['score'] = this.score;
    data['time'] = this.time;
    data['track_id'] = this.trackId;
    return data;
  }
}