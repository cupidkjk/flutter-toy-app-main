// import 'package:toy_app/model/toy_detail.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toy_app/model/product.model.dart';

import 'package:toy_app/model/category_list_model.dart';
import 'package:toy_app/model/cart_model.dart';
import 'package:toy_app/helper/constant.dart';

class ProductService {
  Future<Map<String, dynamic>> getCartItems() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String _token = _prefs.getString("token") ?? '';
      var response = await http.get(
        Uri.parse("$apiEndPoint/ShoppingCart/Cart"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
          "Authorization": "Bearer $_token"
        },
      );
      var _body = jsonDecode(response.body);
      List<CartModel> cartItemList = [];
      if ((_body['items'] as List).isNotEmpty) {
        List<dynamic> _productIds =
            _body['items'].map((e) => e['product_id']).toList();
        _productIds ?? List<dynamic>.empty();
        if (_productIds.isNotEmpty) {
          String _implodeIds = _productIds.join(";");
          var _productsRes = await http.get(
            Uri.parse("$backendEndpoint/Product/GetProductsByIds/$_implodeIds"),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Access-Control-Allow-Origin': '*',
              "Authorization": "Bearer $_token"
            },
          );
          var _products = jsonDecode(_productsRes.body);
          for (var item in _products) {
            var _imageAndCategories =
                await getImageUrlsByProductId(id: item['id']);
            var _cartItem = (_body['items'] as List)
                .where((e) => e['product_id'] == item['id'])
                .toList();
            var _json = {
              'id': _cartItem[0]['id'],
              'price': item['price'],
              'quantity': _cartItem[0]['quantity'],
              'unit_price': _cartItem[0]['unit_price'],
              'sub_total': _cartItem[0]['sub_total'],
              'discount': _cartItem[0]['discount'],
              'product': item,
              'imageAndCate': _imageAndCategories
            };
            var tmp = CartModel.fromJson(_json);
            cartItemList.add(tmp);
          }
        } else {
          cartItemList = [];
        }
      } else {
        cartItemList = [];
      }

      cartItemList ?? List<ProductM>.empty();
      var orderTotalModel = await getOrderTotalModelForShoppingCart();
      return {'cartItemList': cartItemList, 'orderTotalModel': orderTotalModel};
    } catch (err) {
      rethrow;
    }
  }

  Future<String> setFavouriteItem(
      int _clientID, int productId, int quantity) async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String _token = _prefs.getString("token") ?? '';
      var cartResponse = await http.post(
        Uri.parse(
            "$backendEndpoint/ShoppingCartItem/AddToCart/$_clientID/$productId/0?shoppingCartType=Wishlist&customerEnteredPrice=0&quantity=$quantity&addRequiredProducts=true"),
        body: jsonEncode("string"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
          "Authorization": "Bearer $_token"
        },
      );

      if (cartResponse.statusCode == 200) {
        return 'success';
      } else {
        return 'failed';
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<List<CartModel>> getFavouriteItems(int _pCustomerId) async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String _token = _prefs.getString("token") ?? '';
      var response = await http.get(
        Uri.parse(
            "$backendEndpoint/ShoppingCartItem/GetShoppingCart/$_pCustomerId?shoppingCartType=Wishlist&storeId=0"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
          "Authorization": "Bearer $_token"
        },
      );
      var _body = jsonDecode(response.body);
      List<CartModel> cartItemList = [];
      if ((_body as List).isNotEmpty) {
        List<dynamic> _productIds = _body.map((e) => e['product_id']).toList();
        _productIds ?? List<dynamic>.empty();
        if (_productIds.isNotEmpty) {
          String _implodeIds = _productIds.join(";");
          var _productsRes = await http.get(
            Uri.parse("$backendEndpoint/Product/GetProductsByIds/$_implodeIds"),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Access-Control-Allow-Origin': '*',
              "Authorization": "Bearer $_token"
            },
          );
          var _products = jsonDecode(_productsRes.body);
          for (var item in _products) {
            var _imageAndCategories =
                await getImageUrlsByProductId(id: item['id']);
            var _cartItem = (_body as List)
                .where((e) => e['product_id'] == item['id'])
                .toList();
            var _json = {
              'id': _cartItem[0]['id'],
              'price': item['price'],
              'quantity': _cartItem[0]['quantity'],
              'product': item,
              'imageAndCate': _imageAndCategories
            };
            var tmp = CartModel.fromJson(_json);
            cartItemList.add(tmp);
          }
        } else {
          cartItemList = [];
        }
      } else {
        cartItemList = [];
      }

      cartItemList ?? List<ProductM>.empty();
      return cartItemList;
    } catch (err) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> applyDiscountCouponCode(
      String _pCouponCode) async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String _token = _prefs.getString("token") ?? '';
      var res = await http.post(
        Uri.parse(
            "$apiEndPoint/ShoppingCart/ApplyDiscountCoupon?discountCouponCode=$_pCouponCode"),
        body: jsonEncode({
          "checkout_attribute_1": 1,
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
          "Authorization": "Bearer $_token"
        },
      );
      var _body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        var orderTotalModel = await getOrderTotalModelForShoppingCart();
        return {
          'ok': true,
          'message': _body['discount_box']['messages'][0],
          'is_applied': _body['discount_box']['is_applied'],
          'orderTotalModel': orderTotalModel,
        };
      } else {
        return {'ok': false, 'message': "Failed", 'is_applied': false};
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getOrderTotalModelForShoppingCart() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String _token = _prefs.getString("token") ?? '';

      var res = await http.post(
        Uri.parse("$apiEndPoint/ShoppingCart/CheckoutAttributeChange"),
        body: jsonEncode({
          "checkout_attribute_1": 1,
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
          "Authorization": "Bearer $_token"
        },
      );
      var _orderTotalBody = jsonDecode(res.body);
      return {
        'ok': true,
        'sub_total': _orderTotalBody['order_totals_model']['sub_total'],
        'order_total_discount': _orderTotalBody['order_totals_model']
            ['order_total_discount'],
        'order_total': _orderTotalBody['order_totals_model']['order_total'],
        'shipping': _orderTotalBody['order_totals_model']['shipping'],
        'tax': _orderTotalBody['order_totals_model']['tax'],
      };
    } catch (e) {
      rethrow;
    }
  }

  Future<String> addCartItem(
      int productId, int quantity, int catItemId, int _clientID) async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String _token = _prefs.getString("token") ?? '';
      http.Response cartResponse;

      if (catItemId == 0) {
        // cartResponse = await http.post(
        //   Uri.parse(
        //       "$backendEndpoint/ShoppingCartItem/AddToCart/$_clientID/$productId/0?shoppingCartType=ShoppingCart&customerEnteredPrice=0&quantity=$quantity&addRequiredProducts=true"),
        //   body: jsonEncode("string"),
        //   headers: {
        //     'Content-Type': 'application/json; charset=UTF-8',
        //     'Access-Control-Allow-Origin': '*',
        //     "Authorization": "Bearer $_token"
        //   },
        // );
        cartResponse = await http.post(
          Uri.parse(
              "$apiEndPoint/ShoppingCart/AddProductToCartFromCatalog/$productId?shoppingCartType=ShoppingCart&quantity=$quantity"),
          body: jsonEncode("string"),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Access-Control-Allow-Origin': '*',
            "Authorization": "Bearer $_token"
          },
        );
        print("adding ===========");
      } else {
        // cartResponse = await http.post(
        //   Uri.parse(
        //       "$backendEndpoint/ShoppingCartItem/UpdateShoppingCartItem/$_clientID/$catItemId?customerEnteredPrice=0&quantity=$quantity&resetCheckoutData=true"),
        //   body: jsonEncode("string"),
        //   headers: {
        //     'Content-Type': 'application/json; charset=UTF-8',
        //     'Access-Control-Allow-Origin': '*',
        //     "Authorization": "Bearer $_token"
        //   },
        // );
        var putData = {
          "itemquantity$catItemId": quantity,
          "updatecart": true,
          "removefromcart": false,
          "CountryId": 0,
          "StateProvinceId": 0,
          "ZipPostalCode": "",
          "checkout_attribute_1": 1,
          "discountcouponcode": "",
          "giftcardcouponcode": ""
        };
        // var changeAttribute = {
        //   "itemquantity$catItemId": quantity,
        //   "CountryId": 0,
        //   "is_editable": 1,
        //   "StateProvinceId": 0,
        //   "ZipPostalCode": "",
        //   "checkout_attribute_1": 1,
        //   "discountcouponcode": "",
        //   "giftcardcouponcode": ""
        // };
        var _res = await http
            .get(Uri.parse("$apiEndPoint/ShoppingCart/Cart"), headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
          "Authorization": "Bearer $_token"
        });
        var _body = jsonDecode(_res.body);
        var _carts = _body['items'] as List;
        for (var item in _carts) {
          if (item['id'] != catItemId) {
            putData["itemquantity${item['id']}"] = item['quantity'];
            // changeAttribute["itemquantity${item['id']}"] = item['quantity'];
          }
        }
        // print(putData);
        cartResponse = await http.post(
          Uri.parse("$apiEndPoint/ShoppingCart/UpdateCart"),
          body: jsonEncode(putData),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Access-Control-Allow-Origin': '*',
            "Authorization": "Bearer $_token"
          },
        );
        // cartResponse = await http.post(
        //   Uri.parse("$apiEndPoint/ShoppingCart/CheckoutAttributeChange"),
        //   body: jsonEncode(changeAttribute),
        //   headers: {
        //     'Content-Type': 'application/json; charset=UTF-8',
        //     'Access-Control-Allow-Origin': '*',
        //     "Authorization": "Bearer $_token"
        //   },
        // );
      }

      if (cartResponse.statusCode == 200) {
        return 'success';
      } else {
        return 'failed';
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<String> deleteCartItem(int cartItemId) async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String _token = _prefs.getString("token") ?? '';
      print(cartItemId);
      final response = await http.delete(
        Uri.parse(
            "$backendEndpoint/ShoppingCartItem/Delete/$cartItemId?resetCheckoutData=true&ensureOnlyActiveCheckoutAttributes=false"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
          "Authorization": "Bearer $_token"
        },
      );
      // var body = jsonDecode(response.body);
      // print(body);
      if (response.statusCode == 200) {
        return 'success';
      }
      return 'failed';
    } catch (err) {
      rethrow;
    }
  }

  static Future<List<CategoryList>> getAllCategories(page, perPage) async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String _token = _prefs.getString("token") ?? '';
      print(page);
      print(perPage);
      final response = await http.get(
          Uri.parse(
              "$backendEndpoint/Category/GetAll?storeId=0&pageIndex=$page&pageSize=$perPage&showHidden=true"),
          headers: {"accept": "application/json"});
      final _body = json.decode(response.body);
      List<CategoryList> categoryProductList = [];
      if (response.statusCode == 200) {
        if ((_body['items'] as List).isEmpty) {
          categoryProductList = List<CategoryList>.empty();
        } else {
          // List referValues = ["warp"];
          // List _bodyList = (_body['items'] as List);
          // _bodyList.removeWhere(
          //     (element) => element['name'].toString().toLowerCase() == "wrap");
          for (var item in _body['items']) {
            var _tmpResult = await http.get(
                Uri.parse(
                    "$backendEndpoint/Picture/GetPictureUrl/${item['picture_id']}?targetSize=0&showDefaultPicture=true"),
                headers: {
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Access-Control-Allow-Origin': '*',
                  "Authorization": "Bearer $_token"
                });
            var _tmpBody = jsonDecode(_tmpResult.body);
            var tmp = CategoryList.fromJson(item, _tmpBody['url']);
            categoryProductList.add(tmp);
          }
          categoryProductList ?? List<ProductM>.empty();
        }
        return categoryProductList;
      } else {
        throw Exception('Failed to get products');
      }
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  // get new arrival products
  static Future<List<ProductM>> getNewArrival(page, perPage) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String _token = _prefs.getString("token") ?? '';
    var response = await http.get(
        Uri.parse("$backendEndpoint/Product/GetProductsMarkedAsNew?storeId=0"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
          "Authorization": "Bearer $_token"
        });
    var _body = jsonDecode(response.body);
    print(_body);
    List<ProductM> categoryProductList = [];
    for (var item in _body) {
      var _imageAndCategories = await getImageUrlsByProductId(id: item['id']);
      var tmp = ProductM.fromJson(item, _imageAndCategories);
      categoryProductList.add(tmp);
    }
    categoryProductList ?? List<ProductM>.empty();
    return categoryProductList;
  }

  // get recommend products
  static Future<List<ProductM>> getRecommendProduct(page, perPage) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String _token = _prefs.getString("token") ?? '';
    var response = await http.get(
        Uri.parse("$backendEndpoint/Product/GetAllProductsDisplayedOnHomepage"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
          "Authorization": "Bearer $_token"
        });
    var _body = jsonDecode(response.body);
    List<ProductM> categoryProductList = [];
    for (var item in _body) {
      var _imageAndCategories = await getImageUrlsByProductId(id: item['id']);
      var tmp = ProductM.fromJson(item, _imageAndCategories);
      categoryProductList.add(tmp);
    }
    categoryProductList ?? List<ProductM>.empty();
    return categoryProductList;
  }

  // get products by category slug name
  static Future<List<ProductM>> getProductsByCategoryId(
      page, perPage, String slug) async {
    String _slug = slug.toLowerCase();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String _token = _prefs.getString("token") ?? '';
    var response = await http.get(
        Uri.parse(
            "$backendEndpoint/Category/GetAll?categoryName=$_slug&storeId=0&pageIndex=0&pageSize=2147483647&showHidden=false"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
          "Authorization": "Bearer $_token"
        });
    var body = jsonDecode(response.body);
    List<ProductM> categoryProductList = [];
    if ((body['items'] as List).isNotEmpty) {
      int _categoryId = body['items'][0]['id'];
      var _prodcutResponse = await http.get(
          Uri.parse(
              "$backendEndpoint/Product/GetAll?pageIndex=$page&pageSize=$perPage&categoryIds=$_categoryId&storeId=0&vendorId=0&warehouseId=0&visibleIndividuallyOnly=false&excludeFeaturedProducts=false&productTagId=0&searchDescriptions=false&searchManufacturerPartNumber=true&searchSku=true&searchProductTags=false&languageId=0&showHidden=true"),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Access-Control-Allow-Origin': '*',
            "Authorization": "Bearer $_token"
          });
      var _body = jsonDecode(_prodcutResponse.body);
      for (var item in _body['items']) {
        var _imageAndCategories = await getImageUrlsByProductId(id: item['id']);
        var tmp = ProductM.fromJson(item, _imageAndCategories);
        categoryProductList.add(tmp);
      }
    }

    categoryProductList ?? List<ProductM>.empty();
    return categoryProductList;
  }

  static Future<List<ProductM>> getProductsByDirectCategoryId(
      page, perPage, int categoryId) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String _token = _prefs.getString("token") ?? '';
    List<ProductM> categoryProductList = [];
    var _prodcutResponse = await http.get(
        Uri.parse(
            "$backendEndpoint/Product/GetAll?pageIndex=$page&pageSize=$perPage&categoryIds=$categoryId&storeId=0&vendorId=0&warehouseId=0&visibleIndividuallyOnly=false&excludeFeaturedProducts=false&productTagId=0&searchDescriptions=false&searchManufacturerPartNumber=true&searchSku=true&searchProductTags=false&languageId=0&showHidden=true"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
          "Authorization": "Bearer $_token"
        });
    var _body = jsonDecode(_prodcutResponse.body);
    print(_body);
    for (var item in _body['items']) {
      var _imageAndCategories = await getImageUrlsByProductId(id: item['id']);
      var tmp = ProductM.fromJson(item, _imageAndCategories);
      categoryProductList.add(tmp);
    }

    categoryProductList ?? List<ProductM>.empty();
    return categoryProductList;
  }

  static Future<List<ProductM>> searchProductsByName(
      page, perPage, String slug) async {
    String _slug = slug.toLowerCase();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String _token = _prefs.getString("token") ?? '';

    var _prodcutResponse = await http.get(
        Uri.parse(
            "$backendEndpoint/Product/GetAll?pageIndex=$page&pageSize=$perPage&storeId=0&vendorId=0&warehouseId=0&visibleIndividuallyOnly=false&excludeFeaturedProducts=false&productTagId=0&keywords=$_slug&searchDescriptions=true&searchManufacturerPartNumber=true&searchSku=true&searchProductTags=false&languageId=0&showHidden=true"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
          "Authorization": "Bearer $_token"
        });
    var _body = jsonDecode(_prodcutResponse.body);
    List<ProductM> categoryProductList = [];
    if ((_body['items'] as List).isEmpty) {
      categoryProductList = List<ProductM>.empty();
    } else {
      for (var item in _body['items']) {
        var _imageAndCategories = await getImageUrlsByProductId(id: item['id']);
        print(_imageAndCategories);
        var tmp = ProductM.fromJson(item, _imageAndCategories);
        categoryProductList.add(tmp);
      }
      categoryProductList ?? List<ProductM>.empty();
    }

    // print(categoryProductList[0].name);
    return categoryProductList;
  }

  static Future<Map<String, dynamic>> getImageUrlsByProductId(
      {int id = 0, bool featured = false}) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String _token = _prefs.getString("token") ?? '';
    // var response = await http.get(
    //     Uri.parse(
    //         "$backendEndpoint/ProductPictures/GetProductPicturesByProductId/$_id"),
    //     headers: {
    //       'Content-Type': 'application/json; charset=UTF-8',
    //       'Access-Control-Allow-Origin': '*',
    //       "Authorization": "Bearer $_token"
    //     });
    // var body = jsonDecode(response.body);
    // List<int> _imgIds =
    //     (body as List).map((e) => e['picture_id'] as int).toList();
    // List<String> imgList = [];
    // for (int item in _imgIds) {
    //   var _tmpResult = await http.get(
    //       Uri.parse(
    //           "$backendEndpoint/Picture/GetPictureUrl/$item?targetSize=0&showDefaultPicture=true"),
    //       headers: {
    //         'Content-Type': 'application/json; charset=UTF-8',
    //         'Access-Control-Allow-Origin': '*',
    //         "Authorization": "Bearer $_token"
    //       });
    //   var _tmpBody = jsonDecode(_tmpResult.body);
    //   imgList.add(_tmpBody['url']);
    // }
    // print(imgList);
    // var _productCategoryRes = await http.get(
    //     Uri.parse(
    //         "$backendEndpoint/ProductCategory/GetProductCategoriesByProductId/$_id?showHidden=false"),
    //     headers: {
    //       'Content-Type': 'application/json; charset=UTF-8',
    //       'Access-Control-Allow-Origin': '*',
    //       "Authorization": "Bearer $_token"
    //     });
    // var _body = jsonDecode(_productCategoryRes.body);
    // int _productCategoryId = _body[0]['category_id'];
    // var _categoryDetailRes = await http.get(
    //     Uri.parse("$backendEndpoint/Category/GetById/$_productCategoryId"),
    //     headers: {
    //       'Content-Type': 'application/json; charset=UTF-8',
    //       'Access-Control-Allow-Origin': '*',
    //       "Authorization": "Bearer $_token"
    //     });
    // var _body1 = jsonDecode(_categoryDetailRes.body);

    var _productDetails = await http.get(
        Uri.parse(
            "$apiEndPoint/Product/GetProductDetails/$id?updateCartItemId=0"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
          "Authorization": "Bearer $_token"
        });
    var _detailBody = jsonDecode(_productDetails.body);
    List<String> imgList = [];
    List<String> detailImagList = [];
    if (featured) {
      for (var item in _detailBody['product_details_model']['picture_models']) {
        imgList.add(item['image_url']);
      }
    } else {
      for (var item in _detailBody['product_details_model']['picture_models']) {
        imgList.add(item['thumb_image_url']);
      }
    }
    for (var item in _detailBody['product_details_model']['picture_models']) {
      detailImagList.add(item['image_url']);
    }

    var _productCategory = {
      'id': _detailBody['product_details_model']['breadcrumb']
          ['category_breadcrumb'][0]['id'],
      'name': _detailBody['product_details_model']['breadcrumb']
          ['category_breadcrumb'][0]['name']
    };
    return {
      'images': imgList,
      'detailImages': detailImagList,
      'category': _productCategory
    };
  }

  static Future<Map<String, dynamic>> getProductDetailById(int _id) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String _token = _prefs.getString("token") ?? '';
    var _productDetails = await http.get(
        Uri.parse(
            "$apiEndPoint/Product/GetProductDetails/$_id?updateCartItemId=0"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
          "Authorization": "Bearer $_token"
        });
    var _detailBody = jsonDecode(_productDetails.body);

    return _detailBody;
  }

  Future<Map<String, dynamic>> getShoppingMiniCart(int _productId) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String _token = _prefs.getString("token") ?? '';
    var _productDetails =
        await http.get(Uri.parse("$apiEndPoint/ShoppingCart/Cart"), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Access-Control-Allow-Origin': '*',
      "Authorization": "Bearer $_token"
    });
    var _body = jsonDecode(_productDetails.body);
    var _carts = _body['items'] as List;
    var product =
        _carts.where((val) => val['product_id'] == _productId).toList();
    // var sssss = await http.post(
    //     Uri.parse(
    //         "$apiEndPoint/ShoppingCart/ApplyDiscountCoupon?discountCouponCode=123"),
    //     body: jsonEncode({
    //       "additionalProp1": "string",
    //       "additionalProp2": "string",
    //       "additionalProp3": "string"
    //     }),
    //     headers: {
    //       'Content-Type': 'application/json; charset=UTF-8',
    //       'Access-Control-Allow-Origin': '*',
    //       "Authorization": "Bearer $_token"
    //     });
    // print("==================");
    // print(sssss.body);
    if (product.isEmpty) {
      return {'quantity': 0, 'shoppingCartItemId': 0};
    } else {
      return {
        'quantity': product[0]['quantity'],
        'shoppingCartItemId': product[0]['id']
      };
    }
  }
}
