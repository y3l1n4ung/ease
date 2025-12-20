import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String email;
  final String username;
  final Name name;
  final String phone;

  const User({
    required this.id,
    required this.email,
    required this.username,
    required this.name,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Name {
  final String firstname;
  final String lastname;

  const Name({required this.firstname, required this.lastname});

  String get fullName => '$firstname $lastname';

  factory Name.fromJson(Map<String, dynamic> json) => _$NameFromJson(json);

  Map<String, dynamic> toJson() => _$NameToJson(this);
}
