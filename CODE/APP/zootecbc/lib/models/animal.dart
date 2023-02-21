import 'package:zootecbc/models/asset.dart';

class AnimalModel {
  String? id;
  String? race;
  String? area;
  String? from;
  String? gender;
  String? species;
  String? age;
  String? color1;
  String? color2;
  String? status;
  String? enabled;
  AssetModel? picture;

  String? created_at;
  String? updated_at;

  AnimalModel({
    this.id,
    this.race,
    this.area,
    this.from,
    this.gender,
    this.species,
    this.age,
    this.color1,
    this.color2,
    this.status,
    this.enabled,
    this.picture,
    this.created_at,
    this.updated_at,
  });

  factory AnimalModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return AnimalModel();
    return AnimalModel(
        id: (json.containsKey("_id")) ? json["_id"] : json["id"],
        race: json["race"],
        area: json["area"],
        from: json["from"],
        gender: json["gender"],
        species: json["species"],
        age: json["age"],
        color1: json["color1"],
        color2: (json.containsKey("color2")) ? json["color2"] : null,
        status: json["status"],
        enabled: json["enabled"],
        picture: (json.containsKey("picture"))
            ? AssetModel.fromJson(json["picture"])
            : json["picture"],
        created_at: json["createdAt"],
        updated_at: json["updatedAt"]);
  }

  Map<String, dynamic> toJson(AnimalModel item) {
    return {
      'id': item.id,
      'race': item.race,
      'area': item.area,
      'from': item.from,
      'gender': item.gender,
      'species': item.species,
      'age': item.age,
      'color1': item.color1,
      'color2': item.color2,
      'status': item.status,
      'enabled': item.enabled,
      'picture':
          (item.picture != null) ? AssetModel().toJson(item.picture!) : null,
      'createdAt': item.created_at,
      'updatedAt': item.updated_at,
    };
  }
}
