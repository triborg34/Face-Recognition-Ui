class UsersClass {
  String? collectionId;
  String? collectionName;
  String? id;
  String? nickname;
  String? username;
  String? password;
  String? email;
  String? role;
  String? created;
  String? updated;

  UsersClass(
      {this.collectionId,
      this.collectionName,
      this.id,
      this.nickname,
      this.username,
      this.password,
      this.email,
      this.role,
      this.created,
      this.updated});

  UsersClass.fromJson(Map<String, dynamic> json) {
    collectionId = json['collectionId'];
    collectionName = json['collectionName'];
    id = json['id'];
    nickname = json['nickname'];
    username = json['username'];
    password = json['password'];
    email = json['email'];
    role = json['role'];
    created = json['created'];
    updated = json['updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['collectionId'] = this.collectionId;
    data['collectionName'] = this.collectionName;
    data['id'] = this.id;
    data['nickname'] = this.nickname;
    data['username'] = this.username;
    data['password'] = this.password;
    data['email'] = this.email;
    data['role'] = this.role;
    data['created'] = this.created;
    data['updated'] = this.updated;
    return data;
  }
}