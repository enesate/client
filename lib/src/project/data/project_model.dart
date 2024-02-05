import 'package:client/src/design/domain/block_model.dart';

class Project {
  final int? id1;
  final String name;
  final String description;
  final List<Block>? blocks;

  Project(
      {required this.id1,
      required this.name,
      required this.description,
      this.blocks});

  // toJson metodu
  Map<String, dynamic> toJson() {
    return {
      'id1': id1,
      'name': name,
      'description': description,
      'blocks': blocks?.map((block) => block.toJson()).toList(),
    };
  }

  // fromJson fabrika metodu
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id1: json['id1'],
      name: json['name'],
      description: json['description'],
      blocks: (json['blocks'] as List<dynamic>?)
              ?.map((blockJson) => Block.fromJson(blockJson))
              .toList() ??
          [],
    );
  }
}
