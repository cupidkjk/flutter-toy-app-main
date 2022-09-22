import 'package:shared_preferences/shared_preferences.dart';
import 'package:toy_app/helper/constant.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductM {
  int id;
  String name;
  String shortdescription;
  String fulldescription;
  double price;
  int stock;
  int approvedratingsum;
  List<String> images;
  List<String> detailImages;
  int categoryId;
  String categoryName;

  ProductM(
    this.id,
    this.name,
    this.shortdescription,
    this.fulldescription,
    this.price,
    this.stock,
    this.approvedratingsum,
    this.images,
    this.detailImages,
  );

  ProductM.fromJson(
      Map<String, dynamic> json, Map<String, dynamic> _tempValues) {
    id = json['id'];
    name = json['name'];
    shortdescription = json['short_description'] ?? "";
    fulldescription = json['full_description'] ?? "";
    price = json['price'] ?? 0.0;
    stock = json['stock_quantity'] ?? 0;
    images = _tempValues['images'] ?? [];
    detailImages = _tempValues['detailImages'] ?? [];
    approvedratingsum = json['approved_rating_sum'] ?? 0;
    categoryId = _tempValues['category']['id'];
    categoryName = _tempValues['category']['name'];
  }
}
