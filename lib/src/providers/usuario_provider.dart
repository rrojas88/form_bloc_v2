
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:form_bloc/src/providers/preferences_user.dart';

import 'package:form_bloc/src/providers/config.dart';


class UsuarioProvider {

  
  final String firebaseToken = Config.firebaseToken;
  final urlBaseNuevo = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=';
  final urlBaseAcceder = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=';

  final _prefs = new PreferenciasUsuario();


  Future<Map<String, dynamic>> login( String email, String contrasena ) async {

    final authData = {
      'email'             : email,
      'password'          : contrasena,
      'returnSecureToken' : true
    };

    final resp = await http.post( '$urlBaseAcceder$firebaseToken', 
      body: json.encode( authData )
    );

    Map<String, dynamic> decodedResp = json.decode( resp.body );
    print('*.* *  *.* * *.*');
    print( decodedResp );

    if( decodedResp.containsKey('idToken') ) {
      // Almacenar token !
      _prefs.token = decodedResp['idToken'];

      return { 'error': false, 'token': decodedResp['idToken'] };
    }
    else{
      return { 'error': true, 'mensaje': decodedResp['error']['message'] };
    }
  }


  Future<Map<String, dynamic>> nuevoUsuario( String email, String contrasena ) async {

    final authData = {
      'email'             : email,
      'password'          : contrasena,
      'returnSecureToken' : true
    };

    final resp = await http.post( '$urlBaseNuevo$firebaseToken', 
      body: json.encode( authData )
    );

    Map<String, dynamic> decodedResp = json.decode( resp.body );
    print('* * *  ** * *');
    print( decodedResp );

    if( decodedResp.containsKey('idToken') ) {
      // Almacenar token !
      _prefs.token = decodedResp['idToken'];

      return { 'error': false, 'token': decodedResp['idToken'] };
    }
    else{
      return { 'error': true, 'mensaje': decodedResp['error']['message'] };
    }
  }




}