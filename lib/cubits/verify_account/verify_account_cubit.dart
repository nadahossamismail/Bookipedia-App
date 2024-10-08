import 'package:bookipedia/app/app_strings.dart';
import 'package:bookipedia/data_layer/Api_requests/verify_account_request.dart';
import 'package:bookipedia/data_layer/models/verify_account/verify_account_response_model.dart';
import 'package:bookipedia/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'verify_account_state.dart';

class VerifyAccountCubit extends Cubit<VerifyAccountState> {
  VerifyAccountCubit() : super(VerifyAccountInitial());

  static VerifyAccountCubit get(context) => BlocProvider.of(context);

  void sendRequest(String otp) async {
    VerifyAccountResponse response;

    emit(VerifyAccountLoading());

    response = await VerifyAccountRequest(otp).send();

    if (response.status == AppStrings.success) {
      saveUserToken(response.token, response.user.name, response.user.email);
      emit(VerifyAccountCompleted());
    } else {
      emit(VerifyAccountFaliure(response.status));
    }
  }

  void saveUserToken(token, name, email) {
    preferences.setString('token', token);
    preferences.setString(AppStrings.userNameKey, name);
    preferences.setString(AppStrings.emailKey, email);
  }
}
