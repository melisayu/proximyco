class User {
  final String id;
  final String nickname;
  final String postalCode;
  final int rootMinutes;

  User({
    required this.id,
    required this.nickname,
    required this.postalCode,
    required this.rootMinutes,
  });

  User copyWith({
    String? id,
    String? nickname,
    String? postalCode,
    int? rootMinutes,
  }) {
    return User(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      postalCode: postalCode ?? this.postalCode,
      rootMinutes: rootMinutes ?? this.rootMinutes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'postalCode': postalCode,
      'rootMinutes': rootMinutes,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      postalCode: json['postalCode'] as String,
      rootMinutes: json['rootMinutes'] as int,
    );
  }
}
