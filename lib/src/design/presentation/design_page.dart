import 'package:client/src/design/presentation/blocklist.dart';
import 'package:client/src/design/presentation/designarea.dart';
import 'package:client/src/project/data/project_model.dart';
import 'package:flutter/material.dart';

class DesignPage extends StatefulWidget {
  final Project project;

  const DesignPage({super.key, required this.project});

  @override
  State<DesignPage> createState() => _DesignPageState();
}

class _DesignPageState extends State<DesignPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Design Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Project bilgisi
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    'Project Name: ${widget.project.name}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    'Project Description: ${widget.project.description}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ),
            const BlockList(),
            DesignArea(project: widget.project),
          ],
        ),
      ),
    );
  }
}
