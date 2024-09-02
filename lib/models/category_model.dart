class CategoryModel {
  final int? id;
  final String? kategori;
  final String? createdAt;
  final String? updatedAt;

  CategoryModel({this.id, this.kategori, this.createdAt, this.updatedAt});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: int.parse(json["id"].toString()),
      kategori: json['kategori'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}
