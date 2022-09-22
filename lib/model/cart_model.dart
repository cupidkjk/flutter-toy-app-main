import 'package:toy_app/model/product.model.dart';

class CartModel {
  int id;
  double price;
  int quantity;
  ProductM product;
  String unitPrice;
  String subTotal;
  String discount;
  CartModel({
    this.id,
    this.price,
    this.quantity,
    this.product,
    this.unitPrice,
    this.subTotal,
    this.discount,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    ProductM _product =
        ProductM.fromJson(json['product'], json['imageAndCate']);
    double _price = double.parse(json['price'].toString());
    return CartModel(
      id: json['id'],
      price: _price,
      quantity: json['quantity'],
      product: _product,
      unitPrice: json['unit_price'],
      subTotal: json['sub_total'],
      discount: json['discount'],
    );
  }
}
