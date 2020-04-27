import 'package:flutter/material.dart';
import 'package:form_bloc/src/utils/utils.dart' as utils;
import 'package:form_bloc/src/models/producto_model.dart';

class ProductoPage extends StatefulWidget {
  //const ProductoPage({Key key}) : super(key: key);

  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {

  final formKey = GlobalKey<FormState>();

  ProductoModel producto = new ProductoModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Info Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual ), 
            onPressed: (){

            }
          ),
          IconButton(
            icon: Icon(Icons.camera_alt ), 
            onPressed: (){

            }
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
      onPressed: _submit
    );
  }

  void _submit() {

    bool respForm = formKey.currentState.validate();

    if( ! respForm ) return;
    print('Todo Ok... continuar!');

    formKey.currentState.save();

    print('Prod: ${producto.titulo}');
    print('Valor: ${producto.valor}');

  }



  





}