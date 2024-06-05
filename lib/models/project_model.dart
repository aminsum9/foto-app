class ProjectModel {
  final String? id;
  final String? gambar;
  final String? nama;
  final String? fotografer;
  final String? videografer;
  final String? createdAt;
  final String? updatedAt;

  ProjectModel(
      {this.id,
      this.gambar,
      this.nama,
      this.fotografer,
      this.videografer,
      this.createdAt,
      this.updatedAt});

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String?,
      gambar: json['gambar'] as String?,
      nama: json['nama'] as String?,
      fotografer: json['fotografer'] as String?,
      videografer: json['videografer'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}
