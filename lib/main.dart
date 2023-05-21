import 'package:flutter/material.dart';
import 'package:flutter_app/pages/HomeScreenforPhoneMode.dart';
import 'package:flutter_app/pages/HomeScreenforTabletModeV2.dart';
import 'package:flutter_app/style.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'pages/HomeScreenforTabletMode.dart';
import 'firebase_options.dart';
import 'pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/NewUserPage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:device_info/device_info.dart';

//import 'package:sizer/sizer.dart';
const String COLOR_CODE = "#F44336"; // color code for the scanner
const String CANCEL_BUTTON_TEXT = "Cancel"; // text for the cancel button
const bool isShowFlashIcon = true; // whether to show the flash icon or not
const ScanMode scanMode = ScanMode.BARCODE; // the

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

DatabaseReference usersRef =
    FirebaseDatabase.instance.reference().child("users");

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (_) => LoginScreen(),
        '/NewUser': (_) => NewUserScreen(),
        '/tabletHome': (_) => Scene2(),
        '/phoneHome': (_) => PhoneScene(),
      },
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
