import 'package:zootecbc/models/asset.dart';
import 'package:zootecbc/models/role.dart';

class UserModel {
  String? id;
  String? email;
  String? name;
  AssetModel? picture;
  String? enabled;
  String? status;
  String? token;
  List<RoleModel> roles;

  String? created_at;
  String? updated_at;

  UserModel({
    this.id,
    this.email,
    this.name,
    this.picture,
    this.enabled,
    this.status,
    this.token,
    required this.roles,
    this.created_at,
    this.updated_at,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return UserModel(roles: []);
    return UserModel(
        id: (json.containsKey("_id")) ? json["_id"] : json["id"],
        email: json["email"],
        name: json["name"],
        picture: (json.containsKey("picture"))
            ? AssetModel.fromJson(json["picture"])
            : null,
        enabled: json["enabled"],
        status: json["status"],
        token: json["token"],
        roles: (json.containsKey("roles"))
            ? (json["roles"] as List<dynamic>)
                .map((e) => RoleModel.fromJson(e))
                .toList()
            : [],
        created_at: json["createdAt"],
        updated_at: json["updatedAt"]);
  }

  Map<String, dynamic> toJson(UserModel item) {
    return {
      'id': item.id,
      'email': item.email,
      'name': item.name,
      'picture':
          (item.picture != null) ? AssetModel().toJson(item.picture!) : null,
      'enabled': item.enabled,
      'status': item.status,
      'token': item.token,
      'roles': item.roles.map((e) => RoleModel().toJson(e)).toList(),
      'createdAt': item.created_at,
      'updatedAt': item.updated_at,
    };
  }
}
