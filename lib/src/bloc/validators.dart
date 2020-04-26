



import 'dart:async';

class Validators {


  final validaCorreo = StreamTransformer<String, String>.fromHandlers(
    handleData: ( correo, sink ) {
      
      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp   = new RegExp(pattern);

      if( regExp.hasMatch( correo ) ){
        sink.add( correo );
      }
      else{
        sink.addError('Debe ingresar un correo válido');
      }
    }
  );

  // <String, String> => <TipoDatoQueEntra,  TipoDatoQueSale> 
  final validaLongitudPass = StreamTransformer<String, String>.fromHandlers(
    handleData: ( password, sink ) {
      if( password.length >= 6 ){
        sink.add( password );
      }
      else{
        sink.addError('La contraseña debe ser de más de 6 caracteres');
      }
    }
  );

}





