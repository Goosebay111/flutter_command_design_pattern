import 'package:flutter/material.dart';
import 'dart:math';
// Command Design Pattern
// https://medium.com/flutter-community/flutter-design-patterns-12-command-e199172e16eb

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(
          child: CommandExample(),
        ),
      ),
    );
  }
}

class CommandExample extends StatefulWidget {
  const CommandExample({Key? key}) : super(key: key);

  @override
  _CommandExampleState createState() => _CommandExampleState();
}

class _CommandExampleState extends State<CommandExample> {
  final CommandHistory _commandHistory = CommandHistory();
  final Shape _shape = Shape.initial();

  void _changeColor() {
    var command = ChangeColorCommand(_shape);
    _executeCommand(command);
  }

  void _changeHeight() {
    var command = ChangeHeightCommand(_shape);
    _executeCommand(command);
  }

  void _changeWidth() {
    var command = ChangeWidthCommand(_shape);
    _executeCommand(command);
  }

  void _executeCommand(Command command) {
    setState(() {
      command.execute();
      _commandHistory.add(command);
    });
  }

  void _undo() {
    setState(() {
      _commandHistory.undo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: <Widget>[
            Container(
              color: _shape.color,
              child: SizedBox(height: _shape.height, width: _shape.width),
            ),
            TextButton(
              child: const Text('Change Color'),
              onPressed: _changeColor,
            ),
            TextButton(
              child: const Text('Change Height'),
              onPressed: _changeHeight,
            ),
            TextButton(
              child: const Text('Change Width'),
              onPressed: _changeWidth,
            ),
            TextButton(
              child: const Text('Undo'),
              onPressed: _commandHistory.isEmpty ? () {} : _undo,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

abstract class Command {
  void execute();
  String getTitle();
  void undo();
}

class ChangeColorCommand implements Command {
  Shape shape;
  late Color previousColor;
  ChangeColorCommand(this.shape) {
    previousColor = shape.color;
  }
  @override
  void execute() {
    Random random = Random();
    shape.color = Color.fromRGBO(
        random.nextInt(255), random.nextInt(255), random.nextInt(255), 1.0);
  }

  @override
  String getTitle() {
    return 'Change color';
  }

  @override
  void undo() {
    shape.color = previousColor;
  }
}

class ChangeHeightCommand implements Command {
  Shape shape;
  late double previousHeight;
  ChangeHeightCommand(this.shape) {
    previousHeight = shape.height;
  }
  @override
  void execute() {
    Random random = Random();
    shape.height = (random.nextInt(100) + 50).toDouble();
  }

  @override
  String getTitle() {
    return 'Change height';
  }

  @override
  void undo() {
    shape.height = previousHeight;
  }
}

class ChangeWidthCommand implements Command {
  Shape shape;
  late double previousWidth;
  ChangeWidthCommand(this.shape) {
    previousWidth = shape.width;
  }
  @override
  void execute() {
    Random random = Random();
    shape.width = (random.nextInt(100) + 50).toDouble();
  }

  @override
  String getTitle() {
    return 'Change width';
  }

  @override
  void undo() {
    shape.width = previousWidth;
  }
}

class CommandHistory {
  final List<Command> _commandList = [];
  bool get isEmpty => _commandList.isEmpty;
  List<String> get commandHistoryList =>
      _commandList.map((c) => c.getTitle()).toList();
  void add(Command command) => _commandList.add(command);
  void undo() {
    if (_commandList.isNotEmpty) {
      var command = _commandList.removeLast();
      command.undo();
    }
  }
}

class Shape {
  late Color color;
  late double height;
  late double width;

  Shape.initial() {
    color = Colors.black;
    height = 150.0;
    width = 150.0;
  }
}
