class knowPerson {
  List<double>? embdanings;
  String? id;
  String? image;
  String? name;
  String? socialNumber;
  String? gender;
  String? age;
  String? role;
  String? track_id;
  String? updated;

  knowPerson({this.embdanings, this.id, this.image, this.name, this.updated});

  knowPerson.fromJson(Map<String, dynamic> json) {
    embdanings = json['embdanings'].cast<double>();
    id = json['id'];
    image = json['image'];
    name = json['name'];
    socialNumber = json['socialnumber'];
    gender = json['gender'];
    age = json['age'];
    role = json['role'];
    track_id = json['track_id'];
    updated = json['updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['embdanings'] = this.embdanings;
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['socialnumber'] = this.socialNumber;
    data['gender'] = this.gender;
    data['age'] = this.age;
    data['role'] = this.role;
    data['updated'] = this.updated;
    return data;
  }
}
