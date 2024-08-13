class FavoriteModel {
  int? id;
  DateTime? createdAt;
  final String favoriteUid;
  final int foodStoreId;

  FavoriteModel({
    this.id,
    this.createdAt,
    required this.favoriteUid,
    required this.foodStoreId,
  });

  // JSON 데이터를 Dart 객체로 변환하기 위한 팩토리 메서드
  factory FavoriteModel.fromJson(Map<dynamic, dynamic> json) {
    return FavoriteModel(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      favoriteUid: json['favorite_uid'],
      foodStoreId: json['food_store_id'],
    );
  }

  // Dart 객체를 JSON 데이터로 변환하기 위한 메서드
  Map<String, dynamic> toMap() {
    return {
      'favorite_uid': favoriteUid,
      'food_store_id': foodStoreId,
    };
  }
}
