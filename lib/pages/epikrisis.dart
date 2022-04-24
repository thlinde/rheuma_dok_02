// ignore_for_file: avoid_print

import 'package:fluent_ui/fluent_ui.dart';

class EpikrisisPage extends StatefulWidget {
  const EpikrisisPage({Key? key}) : super(key: key);

  @override
  _EpikrisisPageState createState() => _EpikrisisPageState();
}

class _EpikrisisPageState extends State<EpikrisisPage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Epikrise')),
      children: const [],
    );
  }
}