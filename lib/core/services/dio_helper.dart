import 'package:dio/dio.dart';
import 'package:salama/core/endpoint/api_endpoints.dart';

class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: apiUrl,
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response>? postData({
    String? url,
    Map<String, dynamic>? query,
    dynamic data,
    String? token,
    String lang = 'ar',
    void Function(int, int)? onSendProgress,
  }) async {
    return await dio!.post(url!,
        queryParameters: query, data: data, onSendProgress: onSendProgress);
  }
}
