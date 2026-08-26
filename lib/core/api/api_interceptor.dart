import 'package:dio/dio.dart';

import 'package:go_router/go_router.dart';
import 'package:islamic_app/core/constant/app_constant.dart';
import 'package:islamic_app/core/helper/cache_helper.dart';
import 'package:islamic_app/core/routing/app_router.dart';
import 'package:islamic_app/core/routing/routes.dart';


class ApiInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';

    final String? token = CacheHelper.getData(key: AppConstants.tokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await CacheHelper.removeData(key: AppConstants.tokenKey);

      if (AppRouter.navigatorKey.currentContext != null) {
        AppRouter.navigatorKey.currentContext!.go(Routes.splashScreen);
      }
    }

    super.onError(err, handler);
  }
}