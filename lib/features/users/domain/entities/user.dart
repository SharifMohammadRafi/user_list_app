import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  String get fullName => '$firstName $lastName';

  String get phone => '555-01${id.toString().padLeft(2, '0')}0';

  @override
  List<Object?> get props => [id, email, firstName, lastName, avatar];
}
