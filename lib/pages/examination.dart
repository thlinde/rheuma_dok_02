// ignore_for_file: avoid_print

import 'package:fluent_ui/fluent_ui.dart';

class ExaminationPage extends StatefulWidget {
  const ExaminationPage({Key? key}) : super(key: key);

  @override
  _ExaminationPageState createState() => _ExaminationPageState();
}

class _ExaminationPageState extends State<ExaminationPage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Untersuchung')),
      children: const [],
    );
  }
}