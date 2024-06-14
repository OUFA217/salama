// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:salama/features/home/model/home_user_model.dart';

class HomeModel {
  HomeUserModel? user;
  HomeUserModel? aiUser;
  HomeModel({
    this.user,
    this.aiUser,
  });

  HomeModel copyWith({
    HomeUserModel? user,
    HomeUserModel? aiUser,
  }) {
    return HomeModel(
      user: user ?? this.user,
      aiUser: aiUser ?? this.aiUser,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user?.toMap(),
      'aiUser': aiUser?.toMap(),
    };
  }

  factory HomeModel.fromMap(Map<String, dynamic> map) {
    return HomeModel(
      user: map['user'] != null
          ? HomeUserModel.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      aiUser: map['aiUser'] != null
          ? HomeUserModel.fromMap(map['aiUser'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory HomeModel.fromJson(String source) =>
      HomeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'HomeModel(user: $user, aiUser: $aiUser)';

  @override
  bool operator ==(covariant HomeModel other) {
    if (identical(this, other)) return true;

    return other.user == user && other.aiUser == aiUser;
  }

  @override
  int get hashCode => user.hashCode ^ aiUser.hashCode;
}
