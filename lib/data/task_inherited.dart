import 'package:flutter/material.dart';
import 'package:primeiro_projeto/components/task.dart';

class TaskInherited extends InheritedWidget {
  TaskInherited({
    super.key,
    required Widget child,
  }) : super(child: child);

  final List<Task> taskList = [
    Task('Aprender Flutter', 'assets/images/dash.png', 3, 0),
    Task('Ler', 'assets/images/book.jpg', 4, 0),
    Task('Correr', 'assets/images/run.jpg', 5, 0),
    Task('Jogar', 'assets/images/game.jpg', 1, 0),
    Task('Ver série', 'assets/images/series.jpg', 2, 0),
  ];

  void newTask (String name, String photo, int difficulty, int level){
    taskList.add(Task(name, photo, difficulty, level));
  }

  static TaskInherited of(BuildContext context) {
    final TaskInherited? result = context.dependOnInheritedWidgetOfExactType<TaskInherited>();
    assert(result != null, 'No TaskInherited found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(TaskInherited oldWidget) {
    return oldWidget.taskList.length != taskList.length;
  }
}
