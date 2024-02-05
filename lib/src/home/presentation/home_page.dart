// home_page.dart

import 'package:client/src/auth/data/user_model.dart';
import 'package:client/src/auth/presentation/register/register_page.dart';
import 'package:client/src/design/presentation/design_page.dart';
import 'package:client/src/home/presentation/project_card.dart';
import 'package:client/src/home/presentation/project_create_page.dart';
import 'package:client/src/project/data/project_model.dart';
import 'package:client/src/project/data/project_repository.dart';
import 'package:client/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Project> projects = [];
  ProjectRepository projectRepository = ProjectRepository();

  //User a ait projeleri db den çekiyoruz
  Future<void> _fetchdata() async {
    projects = await projectRepository.getAllProjectsWithUser(
        widget.user.userName, widget.user.password);
    if (projects.isEmpty) {
      projects = [];
    }
    setState(() {});
  }

  @override
  void initState() {
    _fetchdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _fetchdata();
    final projectProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Welcome, ${widget.user.userName}', // Kullanıcı adını göster
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => RegisterPage(
                                  user: widget.user,
                                )));
                  },
                  child: const Text('Update'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  'Your Projects:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 50,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ProjectCreatePage(
                                  user: widget.user,
                                  projects: projects,
                                )));
                  },
                  child: const Text('Create Project'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  return ProjectCard(
                    projectName: projects[index].name,
                    projectDescription: projects[index].description,
                    onTap: () async {
                      Provider.of<DataProvider>(context, listen: false)
                          .setrunBtn(0);
                      ProjectRepository projectRepository = ProjectRepository();
                      Project project = await projectRepository
                          .getOneProjectWithBlocks(projects[index].id1!);
                      projectProvider.setProject(project);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => DesignPage(
                                    project: projects[index],
                                  )));
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
