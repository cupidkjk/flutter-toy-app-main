// import 'package:toy_app/model/toy_detail.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:toy_app/model/product_model.dart';
import 'package:toy_app/model/category_model.dart';
import 'package:toy_app/model/manufacture_model.dart';
import 'package:toy_app/model/manufacture_mapping.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
  // var url = Uri.http('192.168.116.40:5000/', '/api/products', {'q': '{http}'});
  String url =
      "http://23.21.117.81:5000/api/products?Fields=id%2Cname%2Cshort_description%2Cfull_description%2Cprice%2Capproved_rating_sum%2Cimages&PublishedStatus=true";
  String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOiIxNjQzMjc2Mzc3IiwiZXhwIjoiMTY0MzM2Mjc3NyIsIkN1c3RvbWVySWQiOiIxIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiJhMDMxOTkzNS1kNzM0LTRiOTQtYTYwZi0xYzVlZGQ4OTEzMzciLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJkZXZ2YWxlcmlhQHByb3Rvbm1haWwuY29tIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZSI6ImRldnZhbGVyaWFAcHJvdG9ubWFpbC5jb20ifQ.wYppA8xSJBz240_B_CQB_62GwjgqS20gh2tz39i8zy8";
  Future<List<Product>> getCategory(String name) async {
    try {
      final categoryResponse = await http.get(
        Uri.parse("http://23.21.117.81:5000/api/categories?Fields=id%2Cname"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (categoryResponse.statusCode != 200) {
        throw Exception('Failed to get products');
      }
      final body = json.decode(categoryResponse.body);
      List<Category> categories = (body['categories'] as List)
          .map((p) => Category.fromJson(p))
          .toList();
      categories = categories.where((element) => element.name == name).toList();
      int categoryId = categories[0].id;
      final response = await http.get(
        Uri.parse("$url&CategoryId=$categoryId"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      final productBody = json.decode(response.body);
      if (response.statusCode == 200) {
        return ((productBody['products'] as List)
            .map((p) => Product.fromJson(p))
            .toList());
      } else {
        throw Exception('Failed to get products');
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<List<Product>> getall() async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      final body = json.decode(response.body);
      if (response.statusCode == 200) {
        // if (body["jwt_token"] != null) {
        //   String token = body["jwt_token"];
        //   SharedPreferences prefs = await SharedPreferences.getInstance();
        //   await prefs.setString('jwt_token', token);
        //   return "success";
        // } else {
        //   return body["status"][0];
        // }
        return ((body['products'] as List)
            .map((p) => Product.fromJson(p))
            .toList());
      } else {
        throw Exception('Failed to get products');
      }
    } catch (err) {
      rethrow;
    }
  }
}
