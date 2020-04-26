import 'package:flutter/material.dart';
import 'package:form_bloc/src/bloc/provider.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final bloc = Provider.of( context );

    return Scaffold(
      appBar: AppBar(
        title: Text('Home '),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('INFORMACION DEL USER',
              style: TextStyle( fontWeight: FontWeight.bold ),   
            ),
            SizedBox(height: 20.0),
            Text('Correo: ${ bloc.email }'),
            Text('Contraseña: ${ bloc.contrasena }')
          ],
        ),
      ),
    );
  }
}