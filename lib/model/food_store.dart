class Store {
  int? id;
  String? storeImgUrl;
  final String storeAddr;
  final String uid;
  final String storeName;
  final String comment;
  final double latitude;
  final double longitude;
  DateTime? createdAt;

  Store({
    this.id,
    this.storeImgUrl,
    required this.storeAddr,
    required this.uid,
    required this.storeName,
    required this.comment,
    required this.latitude,
    required this.longitude,
    this.createdAt,
  });

  // JSON 데이터를 Dart 객체로 변환하기 위한 팩토리 메서드
  factory Store.fromJson(Map<dynamic, dynamic> json) {
    return Store(
      id: json['id'],
      storeImgUrl: json['store_img_url'],
      storeAddr: json['store_addr'],
      uid: json['uid'],
      storeName: json['store_name'],
      comment: json['comment'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // Dart 객체를 JSON 데이터로 변환하기 위한 메서드
  Map<String, dynamic> toMap() {
    return {
      'store_img_url': storeImgUrl,
      'store_addr': storeAddr,
      'uid': uid,
      'store_name': storeName,
      'comment': comment,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
