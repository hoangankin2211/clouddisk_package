import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constant/api_info.dart';
import '../../../utils/dio_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required String? hmail_key, required String? session})
      : super(AuthState.init(hmail_key: hmail_key, session: session)) {
    on<CheckingAuthenticationCondition>(checkingAuthenticationCondition);
  }

  void checkingAuthenticationCondition(
      CheckingAuthenticationCondition event, Emitter<AuthState> emit) async {
    if (state.session != null && state.hmail_key != null) {
      Api.header.addAll({
        "Cookie": "HANBIRO_GW=${state.session}; hmail_key=${state.hmail_key}",
      });
      return emit(AuthState.authenticated(
          hmail_key: state.hmail_key!, session: state.session!));
    }
    return emit(AuthState.unauthenticated());
  }
}
