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
Future<void> initFirebase() async {
  // If default app already exists, do nothing.
  if (Firebase.apps.any((a) => a.name == '[DEFAULT]')) return;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await initFirebase();
  } catch (_) {
    // keep logs minimal to avoid leaking config
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const colorScheme = ColorScheme.dark(
      primary: Color(0xFF60A5FA),     // כחול עדין
      secondary: Color(0xFF3B82F6),   // כחול מודגש
      surface: Color(0xFF111827),     // צבע כרטיסים
      onSurface: Colors.white,
      error: Colors.redAccent,
      onError: Colors.white,
    );

    return MaterialApp(
      title: 'החתמת ציוד',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: Color(0xFF0F172A), // רקע כהה נעים
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
          titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.white),
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFF111827),
          elevation: 10,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
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
    double height_padding = MediaQuery.of(context).size.width * 0.25;
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
              SizedBox(height: height_padding),
              Hero(tag: "add storage eq",
                  child: _buildNavigationButton(context, 'הוספת ציוד לאחסון', goToFirstPage)),
              const SizedBox(height: 53),
              Hero(tag: "loan equipment",
                  child: _buildNavigationButton(context, 'החתמת/זיכוי ציוד', goToLoanPage)),
              const SizedBox(height: 53),
              Hero(tag: 'loan tables', child:
              _buildNavigationButton(context, 'חתימות', goToShowPage)),
              const SizedBox(height: 53),
              Hero(tag: 'equipment state', child:
              _buildNavigationButton(context, 'מציבת ציוד', goToEquipSumPage)),
              const SizedBox(height: 53),
              Hero(tag: 'past commits', child:
              _buildNavigationButton(context, 'החתמות עבר', goToPastCommits)),
              SizedBox(height: height_padding),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton(
      BuildContext context, String text, VoidCallback onTap) {
    double width = MediaQuery.of(context).size.width * 0.75;
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),

        // ★ עיצוב 1 — כחול מודרני ונקי
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E3A8A),
            Color(0xFF3B82F6),
          ],
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],

        border: Border.all(
          color: Colors.white24,
          width: 1,
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Text(
            text,
            style: labelTextStyle.copyWith(
              color: Colors.white,        // טקסט ברור
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

}
