import 'package:dio/dio.dart';
import 'package:seven_learn_nick/common/exceptions.dart';

mixin HttpResposeValidator {
  validateRespose(Response response) {
    if (response.statusCode != 200) {
      throw AppException();
    }
  }
}
