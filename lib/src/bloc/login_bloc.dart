
import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:form_bloc/src/bloc/validators.dart';



class LoginBloc with Validators {

  // Se define que corre String por estos Streams:
  //final _emailCtrl = StreamController<String>.broadcast();
  //final _passCtrl = StreamController<String>.broadcast();
  final _emailCtrl = BehaviorSubject<String>();
  final _passCtrl = BehaviorSubject<String>();

  // Recuperar los datos del Stream:
  Stream<String> get emailStream => _emailCtrl.stream.transform( validaCorreo );
  Stream<String> get passStream => _passCtrl.stream.transform( validaLongitudPass );


  // Insertar Valores al Stream
  Function(String) get changeEmail => _emailCtrl.sink.add;
  Function(String) get changePass => _passCtrl.sink.add;

  // Poner el boton Habilitado
  //Stream<bool> get formValidaCorreoPass_Boton => Observable.combineLatest2(emailStream, passStream, (respCorreo, respPass) => true );
  Stream<bool> get formValidaCorreoPassBoton => 
    CombineLatestStream.combine2(emailStream, passStream, (respCorreo, respPass) => true );

  // Obtener Valores Ingresados en Streams
  String get email => _emailCtrl.value;
  String get contrasena => _passCtrl.value;


  dispose(){
    _emailCtrl?.close();
    _passCtrl?.close();
  }

}

