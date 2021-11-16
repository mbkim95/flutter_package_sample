import 'package:dio/dio.dart';
import 'package:kakao_auth/access_token_interceptor.dart';
import 'package:kakao_auth/auth_api.dart';
import 'package:kakao_auth/required_scopes_interceptor.dart';
import 'package:kakao_common/kakao_context.dart';

extension ApiFactory on Dio {
  /// [Dio] instance for token-based Kakao API.
  static final Dio authApi = _authApiInstance();

  static _authApiInstance() {
    var dio = Dio();
    dio.options.baseUrl = "https://${KakaoContext.hosts.kapi}";
    dio.options.contentType = "application/x-www-form-urlencoded";
    var tokenInterceptor = AccessTokenInterceptor(dio, AuthApi.instance);
    var scopeInterceptor = RequiredScopesInterceptor(dio);
    dio.interceptors
        .addAll([tokenInterceptor, scopeInterceptor, kaInterceptor]);
    return dio;
  }

  /// DIO interceptor for all Kakao API that requires KA header.
  static Interceptor kaInterceptor = InterceptorsWrapper(onRequest:
      (RequestOptions options, RequestInterceptorHandler handler) async {
    var kaHeader = await KakaoContext.kaHeader;
    options.headers["KA"] = kaHeader;
    handler.next(options);
  });
}
