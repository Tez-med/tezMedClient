import 'package:dio/dio.dart';

abstract class DioClientRepository {
  Future<Response> getData(String url, {String? token});
  Future<Response> postData(String url, dynamic data, {String? token});
  Future<Response> updateData(String url, Map<String, dynamic> data, {String? token});
  Future<Response> deleteData(String url, {String? token, Map<String, dynamic>? data});
}
