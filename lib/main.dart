import 'package:flutter/material.dart';
import 'package:flutter_app/views/home.page.dart';
import 'package:flutter_app/views/login.page.dart';
import 'package:flutter_app/views/user_form.page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        accentColor: Colors.blueGrey[700],
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(
            onSecondary: Colors.grey[700]!, onSurface: Colors.white),
      ),
      darkTheme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        accentColor: Colors.blueGrey[700],
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
            onSecondary: Colors.grey[300]!, onSurface: Colors.white),
      ),
      themeMode: ThemeMode.light,
      initialRoute: '/login',
      routes: {
        '/login': (_) => LoginPage(title: 'Login'),
        '/home': (_) => MyHomePage(title: 'Bem vindo à Lista de usuários'),
        '/form': (_) => UserFormPage(
              title: 'Novo',
            ),
      },
    );
  }
}
