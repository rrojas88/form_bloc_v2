
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:mime_type/mime_type.dart';

import 'package:form_bloc/src/providers/config.dart';
import 'package:form_bloc/src/models/producto_model.dart';

class ProductosProvider {

  final _urlBase = Config.urlBase;


  Future<bool> createProduct( ProductoModel producto ) async {

    final url = '$_urlBase/productos.json';

    final resp = await http.post(url, body: productoModelToJson(producto) );

    final decodedData = json.decode( resp.body );

    print('=======');
    print(decodedData);
    return true;
  }


  Future<List<ProductoModel>> loadProducts () async {

    final url = '$_urlBase/productos.json';
    final resp = await http.get(url  );

    /// Decodifico el STRING a Objeto JSON en DART
    final Map<String, dynamic> decodedData = json.decode( resp.body );
    print('decodedData => get => loadProducts() ');
    //print(decodedData);

    final List<ProductoModel> productos = new List();
    
    if( decodedData == null ) return [];

    /// Transformando a Instancias de Producto los registros separados (llegados desde Firebase)
    decodedData.forEach((id, prod ){

      final prodTemp = ProductoModel.fromJson( prod );
      prodTemp.id = id;

      productos.add( prodTemp );

    });

    return productos;
  }

  Future<int> deleteProduct( String id ) async {

    final url = '$_urlBase/productos/$id.json';
    final resp = await http.delete( url );

    //final decodedData = json.decode( resp.body );
    print('=======> deleteProduct() ');
    print( resp.body );
    return 1;
  }

  Future<bool> updateProduct( ProductoModel producto ) async {

    final url = '$_urlBase/productos/${ producto.id }.json';
    final resp = await http.put(url, body: productoModelToJson(producto) );

    final decodedData = json.decode( resp.body );

    print('=======> updateProduct() ');
    print(decodedData);
    return true;
  }


  Future<String> uploadImage( File imagen ) async {

    final String upload_preset = Config.upload_preset;
    final String key_uploadFiles = Config.key_uploadFiles;

    //final URL2 = 'https://res.cloudinary.com/dssyk8id3/image/upload/v1588037544/xo4s4czou1ydru6p9poq.png';
    final url = Uri.parse('https://api.cloudinary.com/v1_1/$key_uploadFiles/image/upload?upload_preset=$upload_preset');

    // Tipo de Imagen:
    final mimeType = mime( imagen.path ).split('/'); // Ejemplo: image/png

    // Solicitud para hacer la Subida
    final imageUploadImage = http.MultipartRequest(
      'POST',
      url
    );

    // Info del Archivo/Imagen
    final file = await http.MultipartFile.fromPath(
      'file',
      imagen.path,
      contentType: MediaType( mimeType[0], mimeType[1] )
    );

    // Adjunto el Archivo:
    imageUploadImage.files.add( file );

    // Disparar la Peticion:
    final streamResponse = await imageUploadImage.send();
    // Obtener Respuesta de la Peticion
    final resp = await http.Response.fromStream( streamResponse );

    if( resp.statusCode != 200 && resp.statusCode != 201 ){
      print('Algo salio mal al intentar subir la Imagen');
      print( resp.body );
      return null;
    }
   
    final respDecode = json.decode( resp.body );

    return respDecode['secure_url'];
  }

}

