import 'package:bookipedia/app/app_strings.dart';
import 'package:bookipedia/data_layer/Api_requests/login_request.dart';
import 'package:bookipedia/data_layer/models/login/login_request_model.dart';
import 'package:bookipedia/data_layer/models/login/login_response_model.dart';
import 'package:bookipedia/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  void sendRequest(LoginRequestBody userData) async {
    LoginResponse response;

    emit(LoginLoading());

    response = await LoginRequest(userData).send();

    if (response.status == AppStrings.success) {
      if (response.user.authenticated) {
        saveToken(response.token, response.user.name, response.user.email);
        emit(LoginCompleted());
      } else {
        emit(LoginToVerify(response.user.email));
      }
    } else {
      emit(LoginFailure(response.status));
    }
  }

  void saveToken(token, name, email) {
    preferences.setString('token', token);
    preferences.setString(AppStrings.userNameKey, name);
    preferences.setString(AppStrings.emailKey, email);
  }
}
