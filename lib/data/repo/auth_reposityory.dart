import 'package:flutter/material.dart';
import 'package:seven_learn_nick/data/auth_info.dart';
import 'package:seven_learn_nick/data/common/http_client.dart';
import 'package:seven_learn_nick/data/source/auth_data_soruce.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authRepository = AuthRepository(AuthRemoteDataSource(httpClient));

abstract class IAuthRepository {
  Future<void> login(String username, String password);
  Future<void> signUp(String username, String password);
  Future<void> refreshToken();
}

class AuthRepository implements IAuthRepository {
  static final ValueNotifier<AuthInfo?> authChangeNotifier =
      ValueNotifier(null);
  final IAuthDataSource dataSource;

  AuthRepository(this.dataSource);

  @override
  Future<void> login(String username, String password) async {
    final AuthInfo authInfo = await dataSource.login(username, password);
    _persistAuthTokens(authInfo);
    debugPrint("access token is: " + authInfo.accessToken);
  }

  Future<void> signUp(String username, String password) async {
    try {
      final AuthInfo authInfo = await dataSource.signUp(username, password);
      debugPrint("access token is: " + authInfo.accessToken);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<void> refreshToken() async {
    final AuthInfo authInfo = await dataSource.refreshToken(
      "def502001c118658d3b86a9fef5424ef6690439358fd22a88b68d2322339e8554b45f838069c65d36da4600d2719c33f00a5dd82e926fc4b7ec430e7cc5140a72b86c43418c8160860e1e400777751568040a404f77c7fac96089f04c5fef53317d901dafea1205a96480fb1419241697fc5095d77b2eda25942d585d64875551a5dd7ea554e4ef8e744dbcc871d52c604a95ea6b05058c22d511cef2cb01e9484b10fe360ffa6fdd91eb783c526df5a5396b1ab339913cf0f10f576c43b6f786d7506427a113cca85be58f96383d0847e36ad42f86783859cb12ddebec4cf48fb01f4257bd861f08cd5deb1591e08df574b699f5ba9bb5277c45b7f822721b614956c296956712acd5f4972364d00bab332acb782f7b8381484fe46a1f48fe55bfc938728d5dbe8859c0abc85068cf37bd6eb8ae164d2290a5f4a7c4db7ef3b052acd80297c17d8d431d416b3fb4fa5b992bf7483caea51bca856b039f46571",
    );
    _persistAuthTokens(authInfo);
  }

  Future<void> _persistAuthTokens(AuthInfo authInfo) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString("access_token", authInfo.accessToken);
    sharedPreferences.setString("refresh_token", authInfo.accessToken);
  }

  Future<void> loadAuthInfo() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    final String accessToken =
        sharedPreferences.getString("access_token") ?? '';

    final String refreshToken =
        sharedPreferences.getString("refresh_token") ?? '';

    if (accessToken.isNotEmpty && refreshToken.isNotEmpty) {
      authChangeNotifier.value = AuthInfo(accessToken, refreshToken);
    }
  }
}
