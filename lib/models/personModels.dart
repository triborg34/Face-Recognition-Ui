import 'dart:typed_data';

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
  double? score;
  String? time;
  String? trackId;
  String? role;
  String? humancrop;
  Uint8List? tempFrame;

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
      this.role,
      this.humancrop,
      this.tempFrame,
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
    role=json['role'];
    humancrop=json['humancrop'];
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
    data['role']=this.role;
    data['humancrop']=this.role;
    return data;
  }
}