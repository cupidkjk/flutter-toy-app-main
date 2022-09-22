import 'package:toy_app/model/product_model.dart';

class SearchData {
  final String searchText;
  final Future<List<Product>> products;
  SearchData(this.searchText, this.products);
}
