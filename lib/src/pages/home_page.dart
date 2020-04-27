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
      body: Container(

      ),
      floatingActionButton: _btnNavegaNuevoProducto( context ),
    );
  }


  Widget _btnNavegaNuevoProducto(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add ),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, 'producto') 
    );
  }



}