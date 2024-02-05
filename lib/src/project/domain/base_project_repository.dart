import 'package:client/src/design/domain/block_model.dart';
import 'package:client/src/project/data/project_model.dart';

abstract class BaseProjectRepository {
  Future<List<Project>> getAllProjectsWithUser(
      String userName, String password);
  Future<Project> createProject(
      String userName, String password, Project project);
  Future<void> updateProject(Project project);
  Future<void> getOneProject(int projectId);
  Future<Project> getOneProjectWithBlocks(int projectId);
  Future<Project> saveBlocks(int projectId, List<Block> blocks);
  Future<void> deleteBlocks(int projectId);
}
