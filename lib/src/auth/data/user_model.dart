import 'package:client/src/project/data/project_model.dart';

class User {
  String userName;
  String password;
  String firstName;
  String lastName;
  String company;
  List<Project>? projects;

  User({
    required this.userName,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.company,
    this.projects,
  });

  // toJson metodu
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'company': company,
      'projects': projects != null
          ? projects!.map((project) => project.toJson()).toList()
          : null,
    };
  }

  // fromJson fabrika metodu
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userName: json['userName'],
      password: json['password'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      company: json['company'],
      projects: json['projects'] != null
          ? (json['projects'] as List<dynamic>)
              .map((projectJson) => Project.fromJson(projectJson))
              .toList()
          : null,
    );
  }
}
