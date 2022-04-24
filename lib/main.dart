// ignore_for_file: avoid_print

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:window_manager/window_manager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'pages/patient.dart';
import 'pages/anamnesis.dart';
import 'pages/examination.dart';
import 'pages/scores.dart';
import 'pages/therapy.dart';
import 'pages/epikrisis.dart';
import 'pages/info.dart';
import 'pages/settings.dart';
import 'model/store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await windowManager.ensureInitialized();
  final ProgController prog = Get.put(ProgController());

  windowManager.waitUntilReadyToShow().then((_) async {
    // print('H: ${prog.height}');
    // print('W: ${prog.width}');
    // print('X: ${prog.xPos}');
    // print('Y: ${prog.yPos}');
    await windowManager.setTitleBarStyle(TitleBarStyle.hidden,
        windowButtonVisibility: false);
    await windowManager.setMinimumSize(const Size(1000, 800));
    await windowManager.setSize(Size(prog.width, prog.height));
    await windowManager.setSize(Size(prog.width, prog.height));
    await windowManager.setPosition(Offset(prog.xPos, prog.yPos));
    await windowManager.show();
    await windowManager.setPreventClose(true);
    await windowManager.setSkipTaskbar(false);
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'com.thlinde.fluentui',
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
      color: Colors.blue,
      darkTheme: ThemeData(
        fontFamily: 'Segoe',
        brightness: Brightness.dark,
        accentColor: Colors.blue,
        visualDensity: VisualDensity.compact,
        focusTheme: FocusThemeData(
          glowFactor: is10footScreen() ? 2.0 : 0.0,
        ),
      ),
      theme: ThemeData(
        fontFamily: 'Segoe',
        accentColor: Colors.blue,
        visualDensity: VisualDensity.compact,
        focusTheme: FocusThemeData(
          glowFactor: is10footScreen() ? 2.0 : 0.0,
        ),
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: NavigationPaneTheme(
            data: const NavigationPaneThemeData(
              backgroundColor: null,
            ),
            child: child!,
          ),
        );
      },
      navigatorKey: Get.key,
      navigatorObservers: [GetObserver()],
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WindowListener {
  final StoreController store = Get.put(StoreController());
  final ProgController prog = Get.find();
  final viewKey = GlobalKey();

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DragToMoveArea(
          child: Container(
            height: 60,
            color: Colors.grey[150],
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: CircleAvatar(
                        radius: 30,
                        // backgroundColor: Colors.blue.light,
                        backgroundColor: FluentTheme.of(context).accentColor.light,
                        child: IconButton(
                          icon: const Icon(
                            FluentIcons.contact,
                            size: 20,
                          ),
                          onPressed: () => print('User pressed!'),
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(right: 16)),
                    Text(
                      'Thomas Linde',
                      style: TextStyle(fontSize: 20, color: Colors.grey[20]),
                    ),
                    const Spacer(),
                    Text(
                      store.examinationDate.value.toLocal().toString(),
                      style: TextStyle(fontSize: 20, color: Colors.grey[20]),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: CircleAvatar(
                        radius: 15,
                        // backgroundColor: Colors.blue.light,
                        backgroundColor: FluentTheme.of(context).accentColor.light,
                        child: IconButton(
                          icon: const Icon(
                            FluentIcons.calendar_week,
                            size: 15,
                          ),
                          // onPressed: () => print('Date pressed!'),
                          onPressed: setExaminationDate,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        SizedBox(
                          width: 138,
                          height: 30,
                          child: WindowCaption(
                            brightness: Brightness.dark,
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        SizedBox(
                          width: 138,
                          height: 20,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: NavigationView(
            key: viewKey,
            pane: NavigationPane(
              selected: store.pageIndex.value,
              onChanged: (i) => setState(() => store.updatePageIndex(i)),
              size: const NavigationPaneSize(
                openMinWidth: 220,
                openMaxWidth: 220,
              ),
              header: Container(
                height: kTwoLineTileHeight,
                color: Colors.grey[60],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Rheuma',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: Colors.blue.darkest,
                      ),
                    ),
                    Text(
                      'Dokumentation',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        fontSize: 17,
                        color: Colors.blue.darkest,
                      ),
                    ),
                  ],
                ),
              ),
              displayMode: PaneDisplayMode.open,
              indicator: () {
                return const StickyNavigationIndicator();
              }(),
              items: [
                // It doesn't look good when resizing from compact to open
                // PaneItemHeader(header: const Text('User Interaction')),
                PaneItemSeparator(color: Colors.transparent),
                PaneItem(
                  icon: const Icon(FluentIcons.contact),
                  title: const Text('Patient'),
                ),
                PaneItem(
                  icon: const Icon(FluentIcons.history),
                  title: const Text('Anamnese'),
                ),
                PaneItem(
                  icon: const Icon(FluentIcons.history),
                  title: const Text('Untersuchung'),
                ),
                PaneItem(
                  icon: const Icon(FluentIcons.favorite_star),
                  title: const Text('Scores'),
                ),
                PaneItem(
                  icon: const Icon(FluentIcons.contact),
                  title: const Text('Therapie'),
                ),
                PaneItem(
                  icon: const Icon(FluentIcons.contact),
                  title: const Text('Epikrise'),
                ),
                PaneItemSeparator(),
              ],
              footerItems: [
                PaneItemSeparator(),
                PaneItem(
                  icon: const Icon(FluentIcons.info),
                  title: const Text('Programminformation'),
                ),
                PaneItem(
                  icon: const Icon(FluentIcons.settings),
                  title: const Text('Einstellungen'),
                ),
                PaneItemAction(
                  icon: const Icon(FluentIcons.power_button),
                  onTap: onWindowClose,
                  title: const Text(
                    'Programm beenden',
                  ),
                ),
              ],
            ),
            content: NavigationBody(index: store.pageIndex.value, children: const [
              PatientPage(),
              AnamnesisPage(),
              ExaminationPage(),
              ScoresPage(),
              TherapyPage(),
              EpikrisisPage(),
              InfoPage(),
              SettingsPage(),
            ]),
          ),
        ),
        // Container(
        //   height: 40,
        //   color: Colors.grey[140],
        // ),
      ],
    );
  }

  void setExaminationDate() async {
    final DateTime _firstDate = DateTime.now().subtract(const Duration(days: 365));
    final DateTime _lastDate = DateTime.now().add(const Duration(days: 365));

    final pickerDate = await material.showDatePicker(
      context: context,
      initialDate: store.examinationDate.value,
      firstDate: _firstDate,
      lastDate: _lastDate,
    );

    if (pickerDate != null && pickerDate != store.examinationDate.value) {
      setState(() => store.setExaminationDate(pickerDate));
    }
    // showDialog(
    //   context: context,
    //   builder: (_) {
    //     return ContentDialog(
    //       title: const Text('Untersuchungsdatum'),
    //       content: SizedBox(
    //         width: 250,
    //         child: DatePicker(
    //           header: 'Datum auswählen',
    //           selected: store.examinationDate.value,
    //           onChanged: (value) => setState(() {
    //             store.setExaminationDate(value);
    //             Navigator.pop(context);
    //           }),
    //           onCancel: () {Navigator.pop(context);},
    //         ),
    //       ),
    //       // actions: [
    //       // FilledButton(
    //       //   child: const Text('ÜBERNEHMEN'),
    //       //   onPressed: () async {
    //       //     Navigator.pop(context);
    //       //   },
    //       // ),
    //       // Button(
    //       //   child: const Text('ABBRECHEN'),
    //       //   onPressed: () {
    //       //     Navigator.pop(context);
    //       //   },
    //       // ),
    //       // ],
    //     );
    //   },
    // );
  }

  @override
  void onWindowClose() async {
    bool _isPreventClose = await windowManager.isPreventClose();
    if (_isPreventClose) {
      showDialog(
        context: context,
        builder: (_) {
          return ContentDialog(
            title: const Text('Programm beenden!'),
            content: const Text('Wollen Sie das Programm beenden?'),
            actions: [
              FilledButton(
                child: const Text('JA'),
                onPressed: () async {
                  Navigator.pop(context);
                  await saveProgSettings();
                  // print('H: ${prog.height}');
                  // print('W: ${prog.width}');
                  // print('X: ${prog.xPos}');
                  // print('Y: ${prog.yPos}');
                  windowManager.destroy();
                },
              ),
              Button(
                child: const Text('ABBRECHEN'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  saveProgSettings() async {
    final pos = await windowManager.getPosition();
    prog.setXPos(pos.dx);
    prog.setyPos(pos.dy);
    final size = await windowManager.getSize();
    prog.setHeight(size.height);
    prog.setWidth(size.width);
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = FluentTheme.of(context);

    return SizedBox(
      width: 138,
      height: 50,
      child: WindowCaption(
        brightness: theme.brightness,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
