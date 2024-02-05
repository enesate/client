import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  final String projectName;
  final String projectDescription;
  final Function() onTap;

  const ProjectCard(
      {super.key,
      required this.projectName,
      required this.projectDescription,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap: onTap,
        title: Text(projectName),
        subtitle: Text(projectDescription),
      ),
    );
  }
}
