import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:patterns/services/log_service.dart';

import '../models/post_model.dart';

class Network {
  static String BASE = 'jsonplaceholder.typicode.com';
  static Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8'
  };

  /* HTTP APIS*/

  static String API_LIST = "/posts";
  static String API_CREATE = "/posts";
  static String API_UPDATE = "/posts/"; // {id}
  static String API_DEL = "/posts/"; // {id}

  /*  */

  static Future<String?> GET(String api, Map<String, String> params) async {
    var uri = Uri.https(BASE, api, params);
    var response = await get(uri, headers: headers);
    LogService.d(response.body);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  static Future<String?> POST(String api, Map<String, dynamic> params) async {
    var uri = Uri.https(
      BASE,
      api,
    );
    var response = await post(uri, headers: headers, body: jsonEncode(params));
    LogService.d(response.body);
    if (response.statusCode == 200 || response.statusCode ==201) {
      return response.body;
    } else {
      return null;
    }
  }

  static Future<String?> PUT(String api, Map<String, dynamic> params) async {
    var uri = Uri.https(BASE, api,);
    var response = await put(uri, headers: headers, body: jsonEncode(params));
    LogService.d(response.body);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  static Future<String?> DEL(String api, Map<String, String> params) async {
    var uri = Uri.https(BASE, api, params);
    var response = await delete(
      uri,
      headers: headers,
    );
    LogService.d(response.body);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  /* HTTP params*/
  static Map<String, String> paramsEmpty() {
    Map<String, String> params = {};
    return params;
  }

  static Map<String, String> paramsCreate(Post post) {
    Map<String, String> params = {};
    params.addAll({
      'title': post.title.toString(),
      'body': post.body.toString(),
      'userId': post.userId.toString(),
    });
    return params;
  }

  static Map<String, dynamic> paramsUpdate(Post post) {
    Map<String, String> params = {};
    params.addAll({
      "id": post.id.toString(),
      'title': post.title.toString(),
      'body': post.body.toString(),
      'userId': post.userId.toString(),
    });
    return params;
  }

  /* HTTP parsing*/

  static List<Post> parsePostList(String response) {
    dynamic json = jsonDecode(response);
    var data = List<Post>.from(json.map((x) => Post.fromJson(x)));
    return data;
  }

  static List<Post> parsePost(String response) {
    final List<dynamic> jsonList = jsonDecode(response);
    final List<Post> posts = [];

    for (var json in jsonList) {
      posts.add(Post.fromJson(json));
    }

    return posts;
  }
}
