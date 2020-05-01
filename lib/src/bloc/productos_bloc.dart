
import 'dart:async';
import 'dart:io';
import 'package:form_bloc/src/providers/productos_provider.dart';
import 'package:rxdart/rxdart.dart';

import 'package:form_bloc/src/bloc/validators.dart';
import 'package:form_bloc/src/models/producto_model.dart';



class ProductosBloc with Validators {

  // Se define que corre String por estos Streams:
  final _productosCtrl = BehaviorSubject<List<ProductoModel>>();
  final _cargandoCtrl = BehaviorSubject<bool>();

  // Proveedor para TODAS las peticiones
  final _prodProvider = new ProductosProvider();

  // Recuperar los datos del Stream:
  Stream<List<ProductoModel>> get productosStream => _productosCtrl.stream;
  Stream<bool> get cargandoStream => _cargandoCtrl.stream;


  // Insertar Valores al Stream
  //Function(String) get changeEmail => _emailCtrl.sink.add;
  void cargarProductos() async {

    final productos = await _prodProvider.loadProducts();
    _productosCtrl.sink.add( productos );
  }

  void agregarProducto( ProductoModel producto ) async {
    _cargandoCtrl.sink.add( true );
    await _prodProvider.createProduct(producto);
    _cargandoCtrl.sink.add( false );
  }

  Future<String> subirArchivo( File foto ) async {
    _cargandoCtrl.sink.add( true );
    final urlFoto = await _prodProvider.uploadImage( foto );
    _cargandoCtrl.sink.add( false );
    return urlFoto;
  }

  void editarProducto( ProductoModel producto ) async {
    _cargandoCtrl.sink.add( true );
    await _prodProvider.updateProduct(producto);
    _cargandoCtrl.sink.add( false );
  }

  void borrarProducto( String id ) async {
    await _prodProvider..deleteProduct( id );
  }


  // Obtener Valores Ingresados en Streams
  //String get email => _emailCtrl.value;

  dispose(){
    _productosCtrl?.close();
    _cargandoCtrl?.close();
  }

}

