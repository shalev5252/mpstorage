import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mpstorage/past_commits_page.dart';
import 'package:mpstorage/users_equipments.dart';
import 'First_page.dart';
import 'design_features.dart';
import 'equipment_summary_page.dart';
import 'firebase_options.dart';
import 'loan_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBY4MekHfjETMr3LFeYDip2BqQMLwEYh_c",
            authDomain: "mpstorageaplication.firebaseapp.com",
            projectId: "mpstorageaplication",
            storageBucket: "mpstorageaplication.appspot.com",
            messagingSenderId: "523833171591",
            appId: "1:523833171591:web:4549bf16a30e1da4d9e222"
        ),
      );
    } else {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    runApp(const MyApp());
  } catch (e, stackTrace) {
    print('Error initializing Firebase: $e');
    print(stackTrace);
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'החתמת ציוד',
      theme: ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: Colors.blueAccent),
          colorScheme: ColorScheme.dark(
            primary: Colors.grey,
            onPrimary: Colors.grey,
            secondary: Colors.grey,
            onSecondary: Colors.grey,
            surface: Color.fromRGBO(80, 80, 80, 1),
            onSurface: Colors.white,
            error: Colors.red,
            onError: Colors.white,
            brightness: Brightness.light,
          ),
      ),
      home: const MyHomePage(title: ''),
      initialRoute: '/',
      routes: {
        '/first': (context) => const FirstPage(),
        '/second': (context) => const LoanPage(),
        '/third': (context) => const EquipSumPage(),
        '/fourth': (context) => const UserEquipmentPage(),
        '/fifth': (context) => const PastCommitPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchController = TextEditingController();

  void goToFirstPage() {
    Navigator.pushNamed(context, '/first');
  }

  void goToLoanPage() {
    Navigator.pushNamed(context, '/second');
  }

  void goToEquipSumPage() {
    Navigator.pushNamed(context, '/third');
  }

  void goToShowPage() {
    Navigator.pushNamed(context, '/fourth');
  }

  void goToPastCommits() {
    Navigator.pushNamed(context, '/fifth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: Text(widget.title, style: labelTextStyle,),
      // ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // buildSearchBar(controller: _searchController, onSearch: _handleSearch),
              const SizedBox(height: 70),
              Hero(tag: "add storage eq",
                  child: _buildNavigationButton(context, 'הוספת ציוד לאחסון', goToFirstPage)),
              const SizedBox(height: 53),
              Hero(tag: "loan equipment",
                  child: _buildNavigationButton(context, 'החתמת/זיכוי ציוד', goToLoanPage)),
              const SizedBox(height: 53),
              Hero(tag: 'loan tables', child:
              _buildNavigationButton(context, 'חתימות חיילים', goToShowPage)),
              const SizedBox(height: 53),
              Hero(tag: 'equipment state', child:
              _buildNavigationButton(context, 'מציבת ציוד', goToEquipSumPage)),
              const SizedBox(height: 53),
              Hero(tag: 'past commits', child:
              _buildNavigationButton(context, 'החתמות עבר', goToPastCommits)),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton(BuildContext context, String text, VoidCallback onTap) {
    return Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(10),
          color: buttonsAppbarColors,
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Center(child: Text(
            text,
            style: labelTextStyle,
          ),
          ),
        ));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

}
