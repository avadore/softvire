import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'bottom_bar_navigation/animated_bottom_bar.dart';
import 'common.dart';
import 'boot_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

int theIndex = 1;
bool _isHidden = true;
int theProgress = 0;

class _MyAppState extends State<MyApp> {
  // Instance of WebView plugin
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  final List<BarItem> barItems = [
    BarItem(
      text: "Products",
      iconData: Icons.view_carousel,
      color: hexToColor("#d23b3b"),
    ),
    BarItem(
      text: "Profile",
      iconData: Icons.person_outline,
      color: hexToColor("#d23b3b"),
    ),
    BarItem(
      text: "Orders",
      iconData: Icons.shopping_basket,
      color: hexToColor("#d23b3b"),
    ),
  ];

  final _history = [];
  // On destroy stream
  StreamSubscription _onDestroy;

  StreamSubscription<WebViewHttpError> _onHttpError;
  StreamSubscription<double> _onProgressChanged;
  // StreamSubscription<double> _onScrollXChanged;
  // StreamSubscription<double> _onScrollYChanged;
  // On urlChanged stream
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  // On urlChanged stream
  StreamSubscription<String> _onUrlChanged;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _urlCtrl = TextEditingController(text: selectedUrl);

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    _onProgressChanged.cancel();

    flutterWebViewPlugin.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    flutterWebViewPlugin.close();

    _urlCtrl.addListener(() {
      selectedUrl = _urlCtrl.text;
    });

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebViewPlugin.onDestroy.listen((_) {
      if (mounted) {
        // Actions like show a info toast.
        _scaffoldKey.currentState.showSnackBar(
            const SnackBar(content: const Text('Webview Destroyed')));
      }
    });
// Add a listener to on url changed
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          _history.add('onUrlChanged: $url');
        });
        setState(() {});
        flutterWebViewPlugin.hide();
      }
      print(" the selected url is     $url");
      if (url ==
          "https://softvireaus.force.com/login?ec=302&startURL=%2Fs%2F") {
        setState(() {
          selectedBarIndex = 1;
        });
      } else if (url == "https://softvireaus.force.com/s/products") {
        setState(() {
          selectedBarIndex = 0;
        });
      } else if (url == "https://softvireaus.force.com/s/cart#") {
        setState(() {
          selectedBarIndex = 2;
        });
      } else if (url == "https://softvireaus.force.com/s/profile#") {
        setState(() {
          selectedBarIndex = 1;
        });
      }

      print('loadinggggggggggggggggggggggggg  onUrlChanged');
    });

    _onProgressChanged =
        flutterWebViewPlugin.onProgressChanged.listen((double progress) {
      if (mounted) {
        setState(() {});
      }

      print((progress * 100.0).toInt());
      theProgress = (progress * 100.0).toInt();
    });

    flutterWebViewPlugin.hide();
//        if(theProgress == 100){
//          Timer(const Duration(milliseconds: 1000), () {
//            flutterWebViewPlugin.show();
//          });
//        }

    // _onScrollYChanged =
    //     flutterWebViewPlugin.onScrollYChanged.listen((double y) {
    //   if (mounted) {
    //     setState(() {
    //       _history.add('Scroll in Y Direction: $y');
    //     });
    //   }
    // });

    // _onScrollXChanged =
    //     flutterWebViewPlugin.onScrollXChanged.listen((double x) {
    //   if (mounted) {
    //     setState(() {
    //       _history.add('Scroll in X Direction: $x');
    //     });
    //   }
    // });

    _onStateChanged =
        flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
          flutterWebViewPlugin.hide();
      if (mounted) {
        setState(() {
          _history.add('onStateChanged: ${state.type} ${state.url}');
        });

        if (state.type == WebViewState.finishLoad) {
          setState(() {});

          Timer(const Duration(milliseconds: 5000), () {
            flutterWebViewPlugin.show();
          });}




      }
    });

    _onHttpError =
        flutterWebViewPlugin.onHttpError.listen((WebViewHttpError error) {
      if (mounted) {
        setState(() {
          _history.add('onHttpError: ${error.code} ${error.url}');
//          flutterWebViewPlugin.hide();
        });
      }
      print('loadinggggggggggggggg errorrrrrr');
    });
  }

  bool istrue = false;

  int selectedBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter WebView Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (_) => const MyHomePage(title: 'Flutter WebView Demo'),
        '/widget': (_) {
          return WebviewScaffold(
            url: selectedUrl,
            javascriptChannels: jsChannels,
            mediaPlaybackRequiresUserGesture: false,
            appBar: AppBar(
              title: const Text('Widget WebView'),
              backgroundColor: hexToColor("#d23b3b"),
            ),
            withZoom: true,
            withLocalStorage: true,
            hidden: _isHidden,
            initialChild: Container(
              color: Colors.white,
              child: Center(
                child: GlowingProgressIndicator(
                  child: CircularStepProgressIndicator(
                    totalSteps: 100,
                    currentStep: theProgress,
                    stepSize: 10,
                    selectedColor: hexToColor("#d23b3b"),
                    unselectedColor: Colors.grey[200],
                    padding: 0,
                    width: 150,
                    height: 150,
                    selectedStepSize: 15,
                  ),
                ),
              ),
            ),
            bottomNavigationBar: AnimatedBottomBar(
                barItems: barItems,
                animationDuration: const Duration(milliseconds: 150),
                barStyle: BarStyle(fontSize: 20.0, iconSize: 30.0),
                onBarTap: (index) {
                  setState(() {
                    selectedBarIndex = index;
                  });
                }),
          );
        },
      },
    );
  }
}
