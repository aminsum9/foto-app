class PesanModel {
  final int? id;
  final String? nomor_surat;
  final String? file_surat;
  final String? satuan_kerja;
  final String? nama;
  final String? nama_project;
  final String? tanggal_awal;
  final String? waktu_awal;
  final String? tanggal_akhir;
  final String? waktu_akhir;
  final String? tempat;
  final String? acara;
  final String? fotografer;
  final String? videografer;
  final String? status;
  final String? link;
  final String? users_id;
  final String? createdAt;
  final String? updatedAt;

  PesanModel(
      {this.id,
      this.nomor_surat,
      this.file_surat,
      this.satuan_kerja,
      this.nama,
      this.nama_project,
      this.tanggal_awal,
      this.waktu_awal,
      this.tanggal_akhir,
      this.waktu_akhir,
      this.tempat,
      this.acara,
      this.fotografer,
      this.videografer,
      this.status,
      this.link,
      this.users_id,
      this.createdAt,
      this.updatedAt});

  factory PesanModel.fromJson(Map<String, dynamic> json) {
    return PesanModel(
      id: int.parse(json["id"].toString()),
      nomor_surat: json['nomor_surat'] as String?,
      file_surat: json['file_surat'] as String?,
      satuan_kerja: json['satuan_kerja'] as String?,
      nama: json['nama'] as String?,
      nama_project: json['nama_project'] as String?,
      tanggal_awal: json['tanggal_awal'] as String?,
      waktu_awal: json['waktu_awal'] as String?,
      tanggal_akhir: json['tanggal_akhir'] as String?,
      waktu_akhir: json['waktu_akhir'] as String?,
      tempat: json['tempat'] as String?,
      acara: json['acara'] as String?,
      fotografer: json['fotografer'] as String?,
      videografer: json['videografer'] as String?,
      status: json['status'] as String?,
      link: json['link'] as String?,
      users_id: json['users_id'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}
