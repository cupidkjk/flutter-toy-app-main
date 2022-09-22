class CategoryList {
  final int id;
  final String name;
  final String image;
  CategoryList({this.id, this.name, this.image});

  factory CategoryList.fromJson(Map<String, dynamic> json, String _pImgUrl) {
    return CategoryList(
      id: json['id'],
      name: json['name'],
      image: _pImgUrl ?? "",
    );
  }
}
