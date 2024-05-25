class DocumentModel {
  final int? id;
  final String? pembuat;
  final String? foto;
  final String? tanggal;
  final String? judul;
  final String? ringkasan;
  final int? kategori;
  final String? foto1;
  final String? foto2;
  final String? foto3;
  final String? foto4;
  final String? foto5;
  final String? foto6;
  final String? link;
  final String? createdAt;
  final String? updatedAt;

  DocumentModel(
      {this.id,
      this.pembuat,
      this.foto,
      this.tanggal,
      this.judul,
      this.ringkasan,
      this.kategori,
      this.foto1,
      this.foto2,
      this.foto3,
      this.foto4,
      this.foto5,
      this.foto6,
      this.link,
      this.createdAt,
      this.updatedAt});

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: int.parse(json["id"].toString()),
      pembuat: json['pembuat'] as String?,
      foto: json['foto'] as String?,
      tanggal: json['tanggal'] as String?,
      judul: json['judul'] as String?,
      ringkasan: json['ringkasan'] as String?,
      kategori: int.parse(json["kategori"].toString()),
      foto1: json['foto1'] as String?,
      foto2: json['foto2'] as String?,
      foto3: json['foto3'] as String?,
      foto4: json['foto4'] as String?,
      foto5: json['foto5'] as String?,
      foto6: json['foto6'] as String?,
      link: json['link'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}
