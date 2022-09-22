class CustomImage {
  final int id;
  final int pictureid;
  final int position;
  final String src;
  CustomImage({
    this.id,
    this.pictureid,
    this.position,
    this.src,
  });
  factory CustomImage.fromJson(Map<String, dynamic> json) {
    return CustomImage(
      id: json['id'],
      pictureid: json['picture_id'],
      position: json['position'],
      src: json['src'],
    );
  }
}
