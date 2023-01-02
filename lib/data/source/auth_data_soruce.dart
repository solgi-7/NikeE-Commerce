import 'package:dio/dio.dart';
import 'package:seven_learn_nick/common/constanst.dart';
import 'package:seven_learn_nick/data/auth_info.dart';
import 'package:seven_learn_nick/data/common/http_respose_validator.dart';

abstract class IAuthDataSource {
  Future<AuthInfo> login(String username, String password);
  Future<AuthInfo> signUp(String username, String password);
  Future<AuthInfo> refreshToken(String token);
}

class AuthRemoteDataSource with HttpResponseValidator implements IAuthDataSource {
  final Dio httpClient;

  AuthRemoteDataSource(this.httpClient);
  @override
  Future<AuthInfo> login(String username, String password) async {
    final response = await httpClient.post("auth/token", data: {
      "grant_type": "password",
      "client_id": 2,
      "client_secret": Constants.clientSecret,
      "username": username,
      "password": password,
    });
    validateRespose(response);

    return AuthInfo(
      response.data["access_token"],
      response.data["refresh_token"],
      username,
    );
  }

  @override
  Future<AuthInfo> refreshToken(String token) async {
    final response = await httpClient.post("auth/token", data: {
      "grant_type": "refresh_token",
      "refresh_token": token,
      "client_id": 2,
      "client_secret": Constants.clientSecret,
    });

    validateRespose(response);

    return AuthInfo(
      response.data["access_token"],
      response.data["refresh_token"],'',
    );
  }

  @override
  Future<AuthInfo> signUp(String username, String password) async {
    final response = await httpClient.post("user/register", data: {
      "email": username,
      "password": password,
    });
    validateRespose(response);

    return login(username, password);
  }
}
