// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SignUpUser {
  String? name;
  String? username;
  String? email;
  String? password;
  SignUpUser({
    this.name,
    this.username,
    this.email,
    this.password,
  });

  SignUpUser copyWith({
    String? name,
    String? username,
    String? email,
    String? password,
  }) {
    return SignUpUser(
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'username': username,
      'email': email,
      'password': password,
    };
  }

  factory SignUpUser.fromMap(Map<String, dynamic> map) {
    return SignUpUser(
      name: map['name'] != null ? map['name'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SignUpUser.fromJson(String source) =>
      SignUpUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SignUpUser(name: $name, username: $username, email: $email, password: $password)';
  }

  @override
  bool operator ==(covariant SignUpUser other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.username == username &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        username.hashCode ^
        email.hashCode ^
        password.hashCode;
  }
}
