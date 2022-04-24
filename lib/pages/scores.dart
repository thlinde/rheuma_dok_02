// ignore_for_file: avoid_print

import 'package:fluent_ui/fluent_ui.dart';

class ScoresPage extends StatefulWidget {
  const ScoresPage({Key? key}) : super(key: key);

  @override
  _ScoresPageState createState() => _ScoresPageState();
}

class _ScoresPageState extends State<ScoresPage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Scores')),
      children: const [],
    );
  }
}