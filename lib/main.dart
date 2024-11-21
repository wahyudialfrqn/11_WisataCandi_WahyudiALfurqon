import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisata_candi_wahyu/screens/favorite_screen.dart';
import 'package:wisata_candi_wahyu/screens/home_screen.dart';
import 'package:wisata_candi_wahyu/screens/profile_screen.dart';
import 'package:wisata_candi_wahyu/screens/search_screen.dart';
import 'package:wisata_candi_wahyu/screens/sig_in_screeen.dart';
import 'package:wisata_candi_wahyu/screens/sign_up_screen.dart';

void main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Future.delayed(
    Duration(seconds: 2),
  );
  FlutterNativeSplash.remove();
  // Cek status login di SharedPreferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isSignedIn = prefs.getBool('isSignedIn') ?? false;

  runApp(MainApp(isSignedIn: isSignedIn));
}

class MainApp extends StatelessWidget {
  final bool isSignedIn;
  const MainApp({super.key, required this.isSignedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Wisata Candi",
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.deepPurple),
          titleTextStyle: TextStyle(
            color: Colors.deepPurple,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(
          primary: Colors.deepPurple,
          surface: Colors.deepPurple[50],
        ),
        useMaterial3: true,
      ),
      // home: DetailScreen(candi: candiList[0]), 
      // home: const ProfileScreen(),
      // home: const SignInScreen(),
      // home: const SignUpScreen(),
      // home: const SearchScreen(),
      // home: const HomeScreen(),
      // home: const MainScreen(),
      home: isSignedIn ? const MainScreen() : const SignInScreen(),
      routes: {
        '/homescreen': (context) => const HomeScreen(),
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/mainscreen' : (context) => const MainScreen()
      }
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    const HomeScreen(),
    const SearchScreen(),
    const FavoriteScreen(),
    const ProfileScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.deepPurple[50],
        ),
        child: BottomNavigationBar(
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.deepPurple[100],
          showSelectedLabels: true,
          currentIndex: _currentIndex,
          onTap: (index){
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home,
              color: Colors.deepPurple,),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search,
              color: Colors.deepPurple,),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite,
              color: Colors.deepPurple,),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person,
              color: Colors.deepPurple,),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}