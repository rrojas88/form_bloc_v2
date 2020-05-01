import 'package:flutter/material.dart';

import 'package:form_bloc/src/providers/preferences_user.dart';
import 'package:form_bloc/src/bloc/provider.dart';

import 'package:form_bloc/src/pages/home_page.dart';
import 'package:form_bloc/src/pages/login_page.dart';
import 'package:form_bloc/src/pages/producto_page.dart';
import 'package:form_bloc/src/pages/registro_page.dart';
 
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Provider(
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.deepPurple
        ),
        //home: Text('Cuerpo')
        initialRoute: 'login',
        routes: {
          'login'     : (BuildContext context ) => LoginPage(),
          'home'      : (BuildContext context ) => Home(),
          'producto'  : (BuildContext context ) => ProductoPage(),
          'registro'  : (BuildContext context ) => RegistroPage(),
        },
      )
    );

  }
}