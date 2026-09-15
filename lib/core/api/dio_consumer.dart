import 'package:dio/dio.dart';

import 'package:islamic_app/core/api/api_interceptor.dart';
import 'package:islamic_app/core/errors/server_exceptions.dart';
import 'api_consumer.dart';
import 'end_points.dart';

import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;
  final String cachePath;

  DioConsumer({required this.dio, required this.cachePath}) {
    dio.options.baseUrl = EndPoints.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 15);
    dio.options.receiveTimeout = const Duration(seconds: 15);
    
    dio.interceptors.add(ApiInterceptors());

    // إعداد الكاش عشان يخزن البيانات ويسرع التطبيق
    final cacheOptions = CacheOptions(
      store: HiveCacheStore(cachePath), // المسار اللي هنحفظ فيه
      policy: CachePolicy.forceCache,   // هيرجع الداتا المحفوظة الأول لو موجودة
      hitCacheOnErrorExcept: [401, 403], // لو مفيش نت أو السيرفر بطيء هيرجع من الكاش
      maxStale: const Duration(days: 7), // هيحتفظ بالبيانات لمدة 7 أيام
      priority: CachePriority.normal,
    );
    dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));
    
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }

  @override
  Future get(String path, {Object? data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get(path, data: data, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
    
  }

  @override
  Future post(String path, {Object? data, Map<String, dynamic>? queryParameters, bool isFormData = false}) async {
    try {
      final response = await dio.post(
        path,
        data: isFormData ? FormData.fromMap(data as Map<String, dynamic>) : data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future patch(String path, {Object? data, Map<String, dynamic>? queryParameters, bool isFormData = false}) async {
    try {
      final response = await dio.patch(
        path,
        data: isFormData ? FormData.fromMap(data as Map<String, dynamic>) : data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future delete(String path, {Object? data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.delete(path, data: data, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }
}