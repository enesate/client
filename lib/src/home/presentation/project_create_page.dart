import 'package:client/src/auth/data/user_model.dart';
import 'package:client/src/project/data/project_model.dart';
import 'package:client/src/project/data/project_repository.dart';
import 'package:flutter/material.dart';

class ProjectCreatePage extends StatefulWidget {
  final User user;
  final List<Project>? projects;
  const ProjectCreatePage(
      {super.key, required this.user, required this.projects});

  @override
  State<ProjectCreatePage> createState() => _ProjectCreatePageState();
}

class _ProjectCreatePageState extends State<ProjectCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  ProjectRepository projectRepository = ProjectRepository();

  void _showInvalidCredentialsDialog(String text1, String text2) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(text1),
          content: Text(text2),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Tamam"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Create Page'),
        actions: [
          BackButton(
            onPressed: () {},
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: SizedBox(
                width: 350,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextFormField(
                        controller: _projectNameController,
                        decoration: const InputDecoration(
                          labelText: 'Project Name',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your project name';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Project Description',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your project Description';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Doğrulama işlemleri başarılıysa kayıt işlemlerini gerçekleştirin
                          String projectName = _projectNameController.text;
                          String projectDescription =
                              _descriptionController.text;
                          Project project = Project(
                              id1: widget.projects!.length + 1,
                              name: projectName,
                              description: projectDescription);
                          print(project.toJson());
                          projectRepository
                              .createProject(widget.user.userName,
                                  widget.user.password, project)
                              .then((value) => _showInvalidCredentialsDialog(
                                  "Başarıyla Proje Oluşturuldu",
                                  "Başarıyla Proje Oluşturuldu"));

                          setState(() {});
                        }
                      },
                      child: const Text('Register'),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
