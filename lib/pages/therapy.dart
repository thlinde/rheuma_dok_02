// ignore_for_file: avoid_print

import 'package:fluent_ui/fluent_ui.dart';

class TherapyPage extends StatefulWidget {
  const TherapyPage({Key? key}) : super(key: key);

  @override
  _TherapyPageState createState() => _TherapyPageState();
}

class _TherapyPageState extends State<TherapyPage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Therapie')),
      children: const [],
    );
  }
}