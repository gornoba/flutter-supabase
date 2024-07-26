class UserModel {
  int? id;
  String uid;
  String name;
  String email;
  String introduce;
  String? profileUrl;
  DateTime? createdAt;

  UserModel({
    this.id,
    required this.uid,
    required this.name,
    required this.email,
    required this.introduce,
    this.profileUrl,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'introduce': introduce,
      'profile_url': profileUrl,
    };
  }

  factory UserModel.fromJson(Map<dynamic, dynamic> json) {
    return UserModel(
      id: json['id'],
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      introduce: json['introduce'],
      profileUrl: json['profile_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
