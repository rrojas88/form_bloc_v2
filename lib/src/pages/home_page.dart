import 'package:flutter/material.dart';

import 'package:form_bloc/src/bloc/provider.dart';
import 'package:form_bloc/src/models/producto_model.dart';
import 'package:form_bloc/src/providers/productos_provider.dart';

class Home extends StatelessWidget {
  //const Home({Key key}) : super(key: key);

  final productosProvider = new ProductosProvider(); 

  @override
  Widget build(BuildContext context) {

    final bloc = Provider.of( context );

    return Scaffold(
      appBar: AppBar(
        title: Text('Home '),
      ),
      body: _crearListado(),
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

  Widget _crearListado() {

    return FutureBuilder(
      //initialData: InitialData,
      future: productosProvider.loadProducts(),

      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        
        if( snapshot.hasData ){

          final productos = snapshot.data;

          return ListView.builder
          (
            itemCount: productos.length,
            itemBuilder: (context, i) => _crearItem( context, productos[ i ] )
          );

        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

      },
    );
  }

  Widget _crearItem(BuildContext context, ProductoModel producto) {

    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: ( direccion ){
        print('Borrara ID = ${producto.id}');
        productosProvider.deleteProduct( producto.id );
      },

      child: Card(
        child: Column(
          children: <Widget>[
            ( producto.url == null )
              ? Image( image: AssetImage( 'assets/no-image.png' ), 
              height: 180.0,
              width: double.infinity,
              fit: BoxFit.cover
            )
            : FadeInImage(
                image: NetworkImage( producto.url ),
                placeholder: AssetImage('assets/jar-loading.gif'),
                height: 180.0,
                width: double.infinity,
                fit: BoxFit.cover,
            ),

            ListTile(
              title: Text('${producto.titulo} - ${producto.valor}'),
              subtitle: Text('${producto.id}'),
              onTap: () => Navigator.pushNamed(context, 'producto', arguments: producto ),
            )
          ],
        ),
      ),
    );
  }

/*

*/

}