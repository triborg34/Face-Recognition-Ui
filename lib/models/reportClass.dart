import 'dart:typed_data';

class reportClass {
  String? age;
  String? camera;
  String? collectionId;
  String? collectionName;
  String? created;
  String? croppedFrame;
  String? date;
  String? frame;
  String? gender;
  String? id;
  String? name;
  int? score;
  String? time;
  String? trackId;
  String? updated;
  Uint8List? imageByte;
  String? role;

  reportClass(
      {this.age,
      this.camera,
      this.collectionId,
      this.collectionName,
      this.created,
      this.croppedFrame,
      this.date,
      this.frame,
      this.gender,
      this.id,
      this.name,
      this.score,
      this.time,
      this.trackId,
      this.updated,this.imageByte,this.role});

  reportClass.fromJson(Map<String, dynamic> json) {
    age = json['age'];
    camera = json['camera'];
    collectionId = json['collectionId'];
    collectionName = json['collectionName'];
    created = json['created'];
    croppedFrame = json['cropped_frame'];
    date = json['date'];
    frame = json['frame'];
    gender = json['gender'];
    id = json['id'];
    name = json['name'];
    score = json['score'];
    time = json['time'];
    trackId = json['track_id'];
    updated = json['updated'];
    role=json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age'] = this.age;
    data['camera'] = this.camera;
    data['collectionId'] = this.collectionId;
    data['collectionName'] = this.collectionName;
    data['created'] = this.created;
    data['cropped_frame'] = this.croppedFrame;
    data['date'] = this.date;
    data['frame'] = this.frame;
    data['gender'] = this.gender;
    data['id'] = this.id;
    data['name'] = this.name;
    data['score'] = this.score;
    data['time'] = this.time;
    data['track_id'] = this.trackId;
    data['updated'] = this.updated;
    data['role']=this.role;
    return data;
  }
}
