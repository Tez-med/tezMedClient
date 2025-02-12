import 'package:dio/dio.dart';
import '../../../domain/dio_client/repository/dio_client_repository.dart';
import '../source/dio_client_source.dart';

class DioClientRepositoryImpl implements DioClientRepository {
  final DioClient _dioClient;

  DioClientRepositoryImpl(this._dioClient);

  @override
  Future<Response> getData(String url, {String? token}) =>
      _dioClient.get(url, token: token);

  @override
  Future<Response> postData(String url, dynamic data,
          {String? token}) =>
      _dioClient.post(url, data: data, token: token);

  @override
  Future<Response> updateData(String url, Map<String, dynamic> data,
          {String? token}) =>
      _dioClient.put(url, data: data, token: token);

  @override
  Future<Response> deleteData(String url,
          {String? token, Map<String, dynamic>? data}) =>
      _dioClient.delete(url, data: data, token: token);
}
