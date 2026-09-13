class knowPerson {
  List<double>? embdanings;
  String? id;
  String? image;
  String? faceCrop;
  String? name;
  String? socialNumber;
  String? gender;
  String? age;
  String? description;
  String? role;
  String? track_id;
  String? updated;
  String? userwhom;
  int? embeddingCount;

  knowPerson(
      {this.embdanings,
      this.id,
      this.image,
      this.faceCrop,
      this.name,
      this.socialNumber,
      this.gender,
      this.age,
      this.description,
      this.role,
      this.track_id,
      this.updated,
      this.userwhom,
      this.embeddingCount});

  knowPerson.fromJson(Map<String, dynamic> json) {
    embdanings = (json['embdanings'] as List?)?.cast<double>();
    id = json['id'];
    image = json['image'];
    faceCrop = json['face_crop'];
    name = json['name'];
    socialNumber = json['socialnumber'];
    gender = json['gender'];
    age = json['age'];
    role = json['role'];
    track_id = json['track_id'];
    updated = json['updated'];
    description = json['description'];
    userwhom = json['userwhom'];
    embeddingCount = json['embedding_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['embdanings'] = embdanings;
    data['id'] = id;
    data['image'] = image;
    data['face_crop'] = faceCrop;
    data['name'] = name;
    data['socialnumber'] = socialNumber;
    data['gender'] = gender;
    data['age'] = age;
    data['role'] = role;
    data['track_id'] = track_id;
    data['updated'] = updated;
    data['description'] = description;
    data['userwhom'] = userwhom;
    data['embedding_count'] = embeddingCount;
    return data;
  }
}
