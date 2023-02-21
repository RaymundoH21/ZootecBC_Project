import 'dart:convert';

import 'package:zootecbc/constants/globals.dart';
import 'package:zootecbc/helpers/helpers.dart';
import 'package:zootecbc/models/animal.dart';
import 'package:zootecbc/models/asset.dart';

import 'package:zootecbc/models/user.dart';
import 'package:zootecbc/providers/app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class WebService {
  Dio dio = Dio();
  BuildContext context;
  WebService(this.context) {
    dio = Dio();
  }

  Future<UserModel> signUp(
      String email, String name, String password, String rol) async {
    dio.options.headers["Content-type"] = "application/json";
    dio.options.headers["Accept"] = "application/json";
    String baseURL = apiUrl + "auth/signup";
    try {
      dynamic response = await dio.post(baseURL,
          data: jsonEncode({
            "email": email,
            "name": name,
            "password": password,
            "rol": rol
          }));
      if (response.statusCode == 200) {
        dynamic userJson = response.data["user"];
        userJson["token"] = response.data["token"];
        return UserModel.fromJson(userJson);
      } else {
        return Future.error(checkErrors(response.data));
      }
    } catch (e) {
      if (e is DioError)
        return Future.error(checkErrors((e as DioError).response));
      return Future.error(['Ocurrió un error desconocido, intenté de nuevo.']);
    }
  }

  Future<UserModel> signIn(String email, String password) async {
    dio.options.headers["Content-type"] = "application/json";
    dio.options.headers["Accept"] = "application/json";
    String baseURL = apiUrl + "auth/signin";
    try {
      dynamic response = await dio.post(baseURL,
          data: jsonEncode({"email": email, "password": password}));
      if (response.statusCode == 200) {
        dynamic userJson = response.data["user"];
        userJson["token"] = response.data["token"];
        return UserModel.fromJson(userJson);
      } else {
        return Future.error(checkErrors(response.data));
      }
    } catch (e) {
      print("error login");
      print(e);
      if (e is DioError)
        return Future.error(checkErrors((e as DioError).response));
      return Future.error(['Ocurrió un error desconocido, intenté de nuevo.']);
    }
  }

  Future<String> sendPasswordResetLink(String email) async {
    dio.options.headers["Content-type"] = "application/json";
    dio.options.headers["Accept"] = "application/json";
    String baseURL = apiUrl + "auth/send-password-reset-link";
    try {
      dynamic response =
          await dio.post(baseURL, data: jsonEncode({"email": email}));
      if (response.statusCode == 200) {
        return response.data["message"];
      } else {
        return Future.error(checkErrors(response.data));
      }
    } catch (e) {
      if (e is DioError)
        return Future.error(checkErrors((e as DioError).response));
      return Future.error(['Ocurrió un error desconocido, intenté de nuevo.']);
    }
  }

  Future<AssetModel> uploadAsset(
      String type, dynamic asset, String token) async {
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["x-access-token"] = token;
    String baseURL = apiUrl + "asset/upload-image";
    if (type == "image") baseURL = apiUrl + "asset/upload-image";
    try {
      FormData formData = new FormData.fromMap({});
      formData.files.add(MapEntry(
          "asset",
          await MultipartFile.fromFile(asset.path,
              filename: asset.path.split('/').last)));
      dio.options.extra = {"path_file": asset.path};
      final response = await dio.post(baseURL, data: formData);

      if (response.statusCode == 200) {
        return AssetModel.fromJson(response.data);
      } else {
        return Future.error(checkErrors(response.data));
      }
    } catch (e) {
      print(e);
      if (e is DioError)
        return Future.error(checkErrors((e as DioError).response));
      return Future.error(['Ocurrió un error desconocido, intenté de nuevo.']);
    }
  }

  Future<AnimalModel> addAnimal(
    String race,
    String area,
    String from,
    String gender,
    String species,
    String age,
    String color1,
    String color2,
    String picture,
    String status,
    String enabled,
    String token,
  ) async {
    dio.options.headers["Content-type"] = "application/json";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["x-access-token"] = token;
    String baseURL = apiUrl + "animal";
    try {
      dynamic response = await dio.post(baseURL,
          data: jsonEncode({
            "race": race,
            "area": area,
            "from": from,
            "gender": gender,
            "species": species,
            "age": age,
            "color1": color1,
            "color2": color2,
            "picture": picture,
            "status": "in_adoption",
            "enabled": "enabled"
          }));
      if (response.statusCode == 200) {
        dynamic json = response.data["animal"];
        return AnimalModel.fromJson(json);
      } else {
        return Future.error(checkErrors(response.data));
      }
    } catch (e) {
      if (e is DioError)
        return Future.error(checkErrors((e as DioError).response));
      return Future.error(['Ocurrió un error desconocido, intenté de nuevo.']);
    }
  }

  Future<AnimalModel> editAnimal(
    String id,
    String race,
    String area,
    String from,
    String gender,
    String species,
    String age,
    String color1,
    String color2,
    String picture,
    String status,
    String enabled,
    String token,
  ) async {
    dio.options.headers["Content-type"] = "application/json";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["x-access-token"] = token;
    String baseURL = apiUrl + "animal";
    try {
      dynamic response = await dio.put(baseURL,
          data: jsonEncode({
            "id_animal": id,
            "race": race,
            "area": area,
            "from": from,
            "gender": gender,
            "species": species,
            "age": age,
            "color1": color1,
            "color2": color2,
            "picture": picture,
            "status": status,
            "enabled": "enabled"
          }));
      if (response.statusCode == 200) {
        dynamic json = response.data["animal"];
        return AnimalModel.fromJson(json);
      } else {
        return Future.error(checkErrors(response.data));
      }
    } catch (e) {
      if (e is DioError)
        return Future.error(checkErrors((e as DioError).response));
      return Future.error(['Ocurrió un error desconocido, intenté de nuevo.']);
    }
  }

  //users
  Future<List<UserModel>> getUsers(
      num limit, num skip, BuildContext context, String token,
      {String search = "", String filter_rol = ""}) async {
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["x-access-token"] = token;
    String baseURL = apiUrl + "user";

    try {
      final response = await dio.get(baseURL, queryParameters: {
        "limit": limit,
        "skip": skip,
        "search": search,
        "filter_rol": filter_rol
      });

      if (response.statusCode == 200) {
        final provider = Provider.of<AppProvider>(context, listen: false);

        return response.data["users"].map<UserModel>((user) {
          return UserModel.fromJson(user);
        }).toList();
      } else {
        return Future.error(checkErrors(response.data));
      }
    } catch (e) {
      print("error en getUsers ");
      print(e);
      if (e is DioError)
        return Future.error(checkErrors((e as DioError).response));
      return Future.error(['Ocurrió un error desconocido, intenté de nuevo.']);
    }
  }

  Future<UserModel> addUser(
    String name,
    String email,
    String password,
    String confirm_password,
    String rol,
    String picture,
    String enabled,
    String token,
  ) async {
    dio.options.headers["Content-type"] = "application/json";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["x-access-token"] = token;
    String baseURL = apiUrl + "user";
    try {
      dynamic response = await dio.post(baseURL,
          data: jsonEncode({
            "name": name,
            "email": email,
            "password": password,
            "confirm_password": confirm_password,
            "rol": rol,
            "picture": picture,
            "enabled": enabled
          }));
      if (response.statusCode == 200) {
        dynamic json = response.data["user"];
        return UserModel.fromJson(json);
      } else {
        return Future.error(checkErrors(response.data));
      }
    } catch (e) {
      if (e is DioError)
        return Future.error(checkErrors((e as DioError).response));
      return Future.error(['Ocurrió un error desconocido, intenté de nuevo.']);
    }
  }

  Future<UserModel> updateUserAdmin(
    String id_user,
    String email,
    String name,
    String picture,
    String rol,
    String password,
    String confirm_password,
    String enabled,
    String token,
  ) async {
    dio.options.headers["Content-type"] = "application/json";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["x-access-token"] = token;
    String baseURL = apiUrl + "user/update-by-admin";
    try {
      dynamic response = await dio.post(baseURL,
          data: jsonEncode({
            "id_user": id_user,
            "email": email,
            "name": name,
            "picture": picture,
            "rol": rol,
            "password": password,
            "confirm_password": confirm_password,
            "enabled": enabled,
          }));
      if (response.statusCode == 200) {
        dynamic userJson = response.data["user"];
        return UserModel.fromJson(userJson);
      } else {
        return Future.error(checkErrors(response.data));
      }
    } catch (e) {
      if (e is DioError)
        return Future.error(checkErrors((e as DioError).response));
      return Future.error(['Ocurrió un error desconocido, intenté de nuevo.']);
    }
  }

  Future<bool> deleteUser(String token, String id) async {
    dio.options.headers["Content-type"] = "application/json";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["x-access-token"] = token;
    String baseURL = apiUrl + "user/by-admin";
    try {
      dynamic response =
          await dio.delete(baseURL, data: jsonEncode({"id": id}));
      if (response.statusCode == 200) {
        return true;
      } else {
        return Future.error(checkErrors(response.data));
      }
    } catch (e) {
      print(e);
      if (e is DioError)
        return Future.error(checkErrors((e as DioError).response));
      return Future.error(['Ocurrió un error desconocido, intenté de nuevo.']);
    }
  }

  //animalss
  Future<List<AnimalModel>> getAnimals(
      num limit, num skip, BuildContext context, String token,
      {String search = "", String filter_area = ""}) async {
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["x-access-token"] = token;
    String baseURL = apiUrl + "animal";

    try {
      final response = await dio.get(baseURL, queryParameters: {
        "limit": limit,
        "skip": skip,
        "search": search,
        "filter_area": filter_area
      });

      if (response.statusCode == 200) {
        final provider = Provider.of<AppProvider>(context, listen: false);

        return response.data["animals"].map<AnimalModel>((anim) {
          return AnimalModel.fromJson(anim);
        }).toList();
      } else {
        return Future.error(checkErrors(response.data));
      }
    } catch (e) {
      print("error en getAnimals");
      print(e);
      if (e is DioError)
        return Future.error(checkErrors((e as DioError).response));
      return Future.error(['Ocurrió un error desconocido, intenté de nuevo.']);
    }
  }

  Future<bool> deleteAnimal(String token, String id) async {
    dio.options.headers["Content-type"] = "application/json";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["x-access-token"] = token;
    String baseURL = apiUrl + "animal";
    try {
      dynamic response =
          await dio.delete(baseURL, data: jsonEncode({"id": id}));
      if (response.statusCode == 200) {
        return true;
      } else {
        return Future.error(checkErrors(response.data));
      }
    } catch (e) {
      print(e);
      if (e is DioError)
        return Future.error(checkErrors((e as DioError).response));
      return Future.error(['Ocurrió un error desconocido, intenté de nuevo.']);
    }
  }

  Future<UserModel> setPassword(String password, String token) async {
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["x-access-token"] = token;
    String baseURL = apiUrl + "user/set-password";
    try {
      dynamic response =
          await dio.put(baseURL, data: jsonEncode({"password": password}));
      if (response.statusCode == 200) {
        dynamic userJson = response.data["user"];
        userJson["token"] = response.data["token"];
        return UserModel.fromJson(userJson);
      } else {
        return Future.error(checkErrors(response.data));
      }
    } catch (e) {
      if (e is DioError)
        return Future.error(checkErrors((e as DioError).response));
      return Future.error(['Ocurrió un error desconocido, intenté de nuevo.']);
    }
  }

  Future<UserModel> changePassword(
      String newPassword, String currentPassword, String token) async {
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["x-access-token"] = token;
    String baseURL = apiUrl + "user/change-password";
    try {
      dynamic response = await dio.put(baseURL,
          data: jsonEncode({
            "new_password": newPassword,
            "current_password": currentPassword
          }));
      if (response.statusCode == 200) {
        dynamic userJson = response.data["user"];
        userJson["token"] = response.data["token"];
        return UserModel.fromJson(userJson);
      } else {
        return Future.error(checkErrors(response.data));
      }
    } catch (e) {
      if (e is DioError)
        return Future.error(checkErrors((e as DioError).response));
      return Future.error(['Ocurrió un error desconocido, intenté de nuevo.']);
    }
  }

  Future<bool> getHasPassword(String token) async {
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["x-access-token"] = token;
    String baseURL = apiUrl + "user/check-has-password";

    try {
      final response = await dio.get(baseURL, queryParameters: {});
      if (response.statusCode == 200) {
        return response.data["hasPassword"];
      } else {
        return Future.error(checkErrors(response.data));
      }
    } catch (e) {
      print(e);
      if (e is DioError)
        return Future.error(checkErrors((e as DioError).response));
      return Future.error(['Ocurrió un error desconocido, intenté de nuevo.']);
    }
  }

  Future<UserModel> updateUser(
    String id,
    String email,
    String name,
    String picture,
    String role,
    String token,
  ) async {
    dio.options.headers["Content-type"] = "application/json";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["x-access-token"] = token;
    String baseURL = apiUrl + "user/update";
    try {
      dynamic response = await dio.post(baseURL,
          data: jsonEncode({
            "id": id,
            "email": email,
            "name": name,
            "picture": picture,
            "rol": role,
          }));
      if (response.statusCode == 200) {
        dynamic userJson = response.data["user"];
        userJson["token"] = response.data["token"];
        return UserModel.fromJson(userJson);
      } else {
        print("error en updateUser1");

        return Future.error(checkErrors(response.data));
      }
    } catch (e) {
      print("error en updateUser2");
      print(e);
      if (e is DioError)
        return Future.error(checkErrors((e as DioError).response));
      return Future.error(['Ocurrió un error desconocido, intenté de nuevo.']);
    }
  }
}
