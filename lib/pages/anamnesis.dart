// ignore_for_file: avoid_print

import 'package:fluent_ui/fluent_ui.dart';

class AnamnesisPage extends StatefulWidget {
  const AnamnesisPage({Key? key}) : super(key: key);

  @override
  _AnamnesisPageState createState() => _AnamnesisPageState();
}

class _AnamnesisPageState extends State<AnamnesisPage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Anamnese')),
      children: const [],
    );
  }
}