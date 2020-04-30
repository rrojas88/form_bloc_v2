import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_bloc/src/providers/productos_provider.dart';
import 'package:form_bloc/src/utils/utils.dart' as utils;
import 'package:form_bloc/src/models/producto_model.dart';
import 'package:image_picker/image_picker.dart';

class ProductoPage extends StatefulWidget {
  //const ProductoPage({Key key}) : super(key: key);

  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _guardando = false;

  final productoProvider = new ProductosProvider();
  ProductoModel producto = new ProductoModel();

  File foto;


  @override
  Widget build(BuildContext context) {


    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;
    if( prodData != null ){
      producto = prodData;
    }

    return Scaffold(
      key: scaffoldKey,

      appBar: AppBar(
        title: Text('Info Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual ), 
            onPressed: () => _seleccionarFoto()
          ),
          IconButton(
            icon: Icon(Icons.camera_alt ), 
            onPressed: () => _tomarFoto()
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,

            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _creaNombre(),
                _creaPrecio(),
                _creaSwitchDisponible(),
                _creaBoton(),
              ],
            ) 
          ),
        ),
      ),
    );
  }

  Widget _creaNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto'
      ),
      validator: ( value ){
        if( value.length < 3 ){
          return 'Ingrese el nombre del producto';
        }
      },
      onSaved: (value) => producto.titulo = value
    );
  }

  Widget _creaPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      //keyboardType: TextInputType.number,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio'
      ),
      validator: ( value ){
        if( utils.isNumeric(value) ){
          return null;
        }else{
          return 'Solo numeros';
        }
      },
      onSaved: (value) => producto.valor = double.parse( value )
    );
  }

  Widget _creaSwitchDisponible() {

    return SwitchListTile(
      value: producto.disponible, 
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState((){
        producto.disponible = value;
      })
    );
  }


  Widget _creaBoton() {
    return RaisedButton.icon(
      icon: Icon( Icons.save ),
      label: Text('Guardar'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
      onPressed: ( _guardando ) ? null : _submit
    );
  }

  void _submit()  async {

    bool respForm = formKey.currentState.validate();

    if( ! respForm ) return;
    print('Todo Ok... continuar!');

    formKey.currentState.save();

    setState(() {
      _guardando = true;
    });
    print('Prod: ${producto.titulo}');
    print('Valor: ${producto.valor}');

    /// Subir Imagen
    if( foto != null ){
      producto.url = await productoProvider.uploadImage( foto );

    }

    if( producto.id == null )
      productoProvider.createProduct(producto);
    else
      productoProvider.updateProduct(producto);

    setState(() {
      // _guardando = false;
    });

    mostrarSnackbar( 'Registro guardado' );

    Navigator.pop(context);
  }


  void mostrarSnackbar( String mensaje ){

    final snackbar = SnackBar(
      content: Text( mensaje ),
      duration: Duration( milliseconds: 1500 ),
    );

    scaffoldKey.currentState.showSnackBar( snackbar );
  }


  Widget _mostrarFoto(){
    if( producto.url != null ){
      return FadeInImage(
          image: NetworkImage( producto.url ),
          placeholder: AssetImage('assets/jar-loading.gif'),
          height: 300.0,
          width: double.infinity,
          fit: BoxFit.cover,
      );
    }
    else {
      return Image(
        image: AssetImage(foto?.path ?? 'assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }


  void _seleccionarFoto() async {
    _processarImagen( ImageSource.gallery );
  }
  void _tomarFoto() async {
    _processarImagen( ImageSource.camera );
  }

  void _processarImagen( ImageSource origen ) async {

    foto = await ImagePicker.pickImage(
      source: origen
    );
    if( foto != null ){
      // Limpiar
      producto.url = null;
    }
    setState(() {  });
  }
  





}