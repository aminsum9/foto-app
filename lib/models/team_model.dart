class TeamModel {
  final int? id;
  final String? fotografer;
  final String? videografer;
  final String? createdAt;
  final String? updatedAt;

  TeamModel(
      {this.id,
      this.fotografer,
      this.videografer,
      this.createdAt,
      this.updatedAt});

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: int.parse(json["id"].toString()),
      fotografer: json['fotografer'] as String?,
      videografer: json['videografer'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}
