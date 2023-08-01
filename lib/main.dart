import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'View_files.dart';
import 'admin_upload.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Widget> _screens = [LoginPage(), LoginPage2()];
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Library')),
        body: GestureDetector(
          onHorizontalDragEnd: _onHorizontalDragEnd,
          child: PageView(
            children: _screens,
            physics: NeverScrollableScrollPhysics(), // Prevent manual swiping
            controller: _pageController,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Admin'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'User'),
          ],
          currentIndex: _currentIndex,
          onTap: _onNavBarItemTapped,
        ),
      ),
    );
  }

  void _onNavBarItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity! < 0) {
      // Swiped left
      if (_currentIndex < _screens.length - 1) {
        setState(() {
          _currentIndex++;
          _pageController.nextPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      }
    } else if (details.primaryVelocity! > 0) {
      // Swiped right
      if (_currentIndex > 0) {
        setState(() {
          _currentIndex--;
          _pageController.previousPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      }
    }
  }
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Map<String, String> userCredentials = {
    "admin@test.com": "12345678",
    "another_user@example.com": "secure_password",
    "test_user@example.com": "test123",
  };

  String email = "";
  String password = "";

  void _login() {
    if (userCredentials.containsKey(email) && userCredentials[email] == password) {
      // Successful login logic (Navigate to home screen, show a success dialog, etc.)
      Navigator.push(context, MaterialPageRoute(builder: (context) => admin_upload(),));
    } else {
      // Invalid credentials logic (Show an error message, clear fields, etc.)
      print("Invalid email or password.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                onChanged: (value) => setState(() => email = value),
                decoration: InputDecoration(
                  labelText: 'Admin Email',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                onChanged: (value) => setState(() => password = value),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage2(),
    );
  }
}

class LoginPage2 extends StatefulWidget {
  @override
  _LoginPageState2 createState() => _LoginPageState2();
}

class _LoginPageState2 extends State<LoginPage2> {
  final Map<String, String> userCredentials = {
    "user@test.com": "12345678",
    "another_user@example.com": "secure_password",
    "test_user@example.com": "test123",
  };

  String email = "";
  String password = "";

  void _login() {
    if (userCredentials.containsKey(email) && userCredentials[email] == password) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => view_files(),));
    } else {
      // Invalid credentials logic (Show an error message, clear fields, etc.)
      print("Invalid email or password.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                onChanged: (value) => setState(() => email = value),
                decoration: InputDecoration(
                  labelText: 'User Email',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                onChanged: (value) => setState(() => password = value),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}