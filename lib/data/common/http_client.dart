import 'package:seven_learn_nick/data/repo/auth_reposityory.dart';
import 'package:dio/dio.dart';

final httpClient = Dio(
  BaseOptions(baseUrl: 'http://expertdevelopers.ir/api/v1/'),
)..interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final authInfo = AuthRepository.authChangeNotifier.value;
        if (authInfo != null && authInfo.accessToken.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer ${authInfo.accessToken}';
        }
        handler.next(options);
      },
    ),
  );
