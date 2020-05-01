import 'package:flutter/material.dart';
import 'package:form_bloc/src/utils/utils.dart' as utils;
import 'package:form_bloc/src/bloc/provider.dart';
import 'package:form_bloc/src/providers/usuario_provider.dart';

class RegistroPage extends StatelessWidget {
  //const RegistroPage({Key key}) : super(key: key);

  final usuarioProvider = new UsuarioProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _crearFondo( context ),
          _crearForm( context ),
        ],
      ),
    );
  }

  Widget _crearFondo(BuildContext context) {

    final size = MediaQuery.of(context).size;
    double alto = size.height * 0.4;

    final fondoMorado = Container(
      height: alto,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Color.fromRGBO(63, 63, 156, 1.0),
            Color.fromRGBO(90, 70, 178, 1.0)
          ] 
        )
      ),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.5)
      ),
    );

    return Stack(
      children: <Widget>[
        fondoMorado,
        Positioned(
          top: 90.0, left: 30.0, child: circulo
        ),
        Positioned(
          top: -40.0, right: -30.0, child: circulo
        ),
        Positioned(
          bottom: -50.0, right: -30.0, child: circulo
        ),
        Positioned(
          bottom: 120.0, right: 20.0, child: circulo
        ),
        Positioned(
          bottom: -50.0, left: -30.0, child: circulo
        ),

        Container(
          padding: EdgeInsets.only(top: 50.0 ),
          child: Column(
            children: <Widget>[
              Icon( Icons.person, color: Colors.white, size: 100.0),
              SizedBox( height: 10.0, 
                width: double.infinity // AL ocupar todo el ancho centra !!!
              ),
              Text('Robinson R', style: TextStyle(color: Colors.white, fontSize: 24.0))
            ],
          ),
        )
      ],
    );
  }

  Widget _crearForm( BuildContext context ) {

    final bloc = Provider.of( context );

    final size = MediaQuery.of(context).size;
    double ancho = size.width * 0.85;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[

          SafeArea(
            child: Container(
              height: 180.0,
            ) 
          ),

          Container(
            width: ancho,
            padding: EdgeInsets.symmetric(vertical: 50.0),
            margin: EdgeInsets.symmetric(vertical: 30.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular( 20.0 ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0
                )
              ]
            ),
            child: Column(
              children: <Widget>[
                Text('Registro',
                  style: TextStyle(
                    fontSize: 20.0
                  ),
                ),
                SizedBox( height: 60.0 ),

                _crearInputEmail( bloc ),

                SizedBox( height: 30.0 ),
                _crearInputPassword( bloc ),

                SizedBox( height: 30.0 ),
                _crearBoton( bloc )
              ],
            ),
          ),

          FlatButton(
            child: Text('Crear cuenta'),
            onPressed: ()=> Navigator.pushReplacementNamed(context, 'registro'), 
          ),

          SizedBox(height: 100.0 )
        ],
      ),
    );
  }

  Widget _crearInputEmail( LoginBloc bloc ) {

    return StreamBuilder(
      stream: bloc.emailStream, 
      //initialData: ,
      builder: (BuildContext contex, AsyncSnapshot snapshot ){

        if( snapshot.hasError ){
          print('Correo invalido');
        }
        else{
          print('Correo OK');
        }

        return Container(
          padding: EdgeInsets.symmetric( horizontal: 20.0 ),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon( Icons.alternate_email, color: Colors.deepPurple ),
              hintText: 'ejemplo@correo.com',
              labelText: 'E-mail',
              counterText: snapshot.data,
              errorText: snapshot.error
            ),
            onChanged: ( value ) => bloc.changeEmail( value ),
          ),
        );
      }
    );    
  }

  Widget _crearInputPassword(  LoginBloc bloc ) {

    return StreamBuilder(
      stream: bloc.passStream ,
      //initialData: initialData ,
      builder: (BuildContext context, AsyncSnapshot snapshot){


        return Container(
          padding: EdgeInsets.symmetric( horizontal: 20.0 ),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon( Icons.lock, color: Colors.deepPurple ),
              labelText: 'Contraseña',
              counterText: snapshot.data,
              errorText: snapshot.error
            ),
            onChanged: ( value ) => bloc.changePass( value ),
          ),
        );
      },
    );
  }

  Widget _crearBoton( LoginBloc bloc ) {

    return StreamBuilder(
      stream: bloc.formValidaCorreoPassBoton ,
      //initialData: initialData ,
      builder: (BuildContext context, AsyncSnapshot snapshot){

        
        return RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
          ),
          elevation: 0.0, // QUita sombra del Boton,
          color: Colors.deepPurple,
          textColor: Colors.white,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 80.0),
            child: Text('Ingresar'),
          ),
          onPressed: snapshot.hasData ? () => _registrar( bloc, context ) : null,
        );
      },
    );
  }


  _registrar( LoginBloc bloc, BuildContext context ) async {
    print('===========');
    print('Email: ${bloc.email}');
    print('Contraseña: ${bloc.contrasena}');

    Map result = await usuarioProvider.nuevoUsuario(bloc.email, bloc.contrasena);

    if( result['error'] ){
      String mensaje = result['mensaje'];
      utils.mostrarAlerta( context, mensaje);
    }
    else{
      Navigator.pushReplacementNamed(context, 'login');
    }
  }


}




