// ignore_for_file: avoid_print

import 'package:fluent_ui/fluent_ui.dart';
// import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'pages/home.dart';
import 'pages/info.dart';
import 'pages/settings.dart';
import 'model/store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await windowManager.ensureInitialized();
  final ProgController prog = Get.put(ProgController());

  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setTitleBarStyle(TitleBarStyle.hidden,
        windowButtonVisibility: false);
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
        visualDensity: VisualDensity.standard,
        focusTheme: FocusThemeData(
          glowFactor: is10footScreen() ? 2.0 : 0.0,
        ),
      ),
      theme: ThemeData(
        fontFamily: 'Segoe',
        accentColor: Colors.blue,
        visualDensity: VisualDensity.standard,
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
                        backgroundColor: Colors.blue.light,
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
                    const SizedBox(
                      width: 138,
                      height: 50,
                      child: WindowCaption(
                        brightness: Brightness.dark,
                        backgroundColor: Colors.transparent,
                      ),
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
              selected: store.index.value,
              onChanged: (i) => setState(() => store.updateIndex(i)),
              size: const NavigationPaneSize(
                openMinWidth: 250,
                openMaxWidth: 250,
              ),
              header: Container(
                height: kOneLineTileHeight,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: const FlutterLogo(
                  style: FlutterLogoStyle.horizontal,
                  size: 100,
                ),
              ),
              displayMode: PaneDisplayMode.open,
              indicator: () {
                return const StickyNavigationIndicator();
              }(),
              items: [
                // It doesn't look good when resizing from compact to open
                // PaneItemHeader(header: const Text('User Interaction')),
                PaneItem(
                  icon: const Icon(FluentIcons.home),
                  title: const Text('Home'),
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
              ],
            ),
            content: NavigationBody(index: store.index.value, children: const [
              HomePage(),
              InfoPage(),
              SettingsPage(),
            ]),
          ),
        ),
        Container(
          height: 40,
          color: Colors.grey[140],
        ),
      ],
    );

    // return NavigationView(
    //   key: viewKey,
    //   appBar: NavigationAppBar(
    //     title: () {
    //       return DragToMoveArea(
    //         child: Align(
    //           alignment: AlignmentDirectional.centerStart,
    //           child: Padding(
    //             padding: const EdgeInsets.only(left: 8.0),
    //             // child: Text(
    //             //   'thlinde',
    //             //   style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
    //             // ),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 SizedBox(
    //                   height: 40,
    //                   width: 40,
    //                   child: IconButton(
    //                     icon: const Icon(
    //                       FluentIcons.contact,
    //                       size: 20,
    //                     ),
    //                     onPressed: () => print('User pressed!'),
    //                     iconButtonMode: IconButtonMode.large,
    //                   ),
    //                 ),
    //                 Text(
    //                   'eins',
    //                   style: TextStyle(fontSize: 20),
    //                 ),
    //                 Text('zwei'),
    //                 Text('drei'),
    //               ],
    //             ),
    //           ),
    //         ),
    //       );
    //     }(),
    //     actions: DragToMoveArea(
    //       child: Row(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: const [Spacer(), WindowButtons()],
    //       ),
    //     ),
    //     automaticallyImplyLeading: false,
    //   ),
    //   pane: NavigationPane(
    //     selected: store.index.value,
    //     onChanged: (i) => setState(() => store.updateIndex(i)),
    //     size: const NavigationPaneSize(
    //       openMinWidth: 250,
    //       openMaxWidth: 250,
    //     ),
    //     header: Container(
    //       height: kOneLineTileHeight,
    //       padding: const EdgeInsets.symmetric(horizontal: 10.0),
    //       child: const FlutterLogo(
    //         style: FlutterLogoStyle.horizontal,
    //         size: 100,
    //       ),
    //     ),
    //     displayMode: PaneDisplayMode.open,
    //     indicator: () {
    //       return const StickyNavigationIndicator();
    //     }(),
    //     items: [
    //       // It doesn't look good when resizing from compact to open
    //       // PaneItemHeader(header: const Text('User Interaction')),
    //       PaneItem(
    //         icon: const Icon(FluentIcons.home),
    //         title: const Text('Home'),
    //       ),
    //       PaneItemSeparator(),
    //     ],
    //     footerItems: [
    //       PaneItemSeparator(),
    //       PaneItem(
    //         icon: const Icon(FluentIcons.info),
    //         title: const Text('Programminformation'),
    //       ),
    //       PaneItem(
    //         icon: const Icon(FluentIcons.settings),
    //         title: const Text('Einstellungen'),
    //       ),
    //     ],
    //   ),
    //   content: NavigationBody(index: store.index.value, children: const [
    //     HomePage(),
    //     InfoPage(),
    //     SettingsPage(),
    //   ]),
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
            title: const Text('Bestätigung notwendig!'),
            content: const Text('Wollen Sie das Programm beenden?'),
            actions: [
              FilledButton(
                child: const Text('JA'),
                onPressed: () async {
                  Navigator.pop(context);
                  await saveProgSettings();
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
