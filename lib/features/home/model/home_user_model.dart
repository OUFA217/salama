// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class HomeUserModel {
  String? name;
  String? id;
  HomeUserModel({
    this.name,
    this.id,
  });

  HomeUserModel copyWith({
    String? name,
    String? id,
  }) {
    return HomeUserModel(
      name: name ?? this.name,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
    };
  }

  factory HomeUserModel.fromMap(Map<String, dynamic> map) {
    return HomeUserModel(
      name: map['name'] != null ? map['name'] as String : null,
      id: map['id'] != null ? map['id'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory HomeUserModel.fromJson(String source) =>
      HomeUserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'HomeUserModel(name: $name, id: $id)';

  @override
  bool operator ==(covariant HomeUserModel other) {
    if (identical(this, other)) return true;

    return other.name == name && other.id == id;
  }

  @override
  int get hashCode => name.hashCode ^ id.hashCode;
}
