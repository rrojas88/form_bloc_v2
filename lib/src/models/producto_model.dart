
// To parse this JSON data, do
//
//     final productoModel = productoModelFromJson(jsonString);

import 'dart:convert';

/// Funcion que recibe un JSON en un STRING y regresa la instancia del Modelo
ProductoModel productoModelFromJson(String str) => ProductoModel.fromJson(json.decode(str));

// Funcion que toma una Instancia del Modelo y lo convierte en STRING con JSON dentro
String productoModelToJson(ProductoModel data) => json.encode(data.toJson());

class ProductoModel {
    String id;
    String titulo;
    double valor;
    bool disponible;
    String url;

    ProductoModel({
        this.id,
        this.titulo = '',
        this.valor = 0.0,
        this.disponible = true,
        this.url,
    });

    factory ProductoModel.fromJson(Map<String, dynamic> json) => ProductoModel(
        id:           json["id"],
        titulo:       json["titulo"],
        valor:        json["valor"],
        disponible:   json["disponible"],
        url:          json["url"],
    );

    Map<String, dynamic> toJson() => {
        "id"          : id,
        "titulo"      : titulo,
        "valor"       : valor,
        "disponible"  : disponible,
        "url"         : url,
    };
}
