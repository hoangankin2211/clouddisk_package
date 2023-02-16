import '../../../model/item.dart';

enum AuthStatus {
  authenticated,
  unauthenticated,
  unknown;
}

class AuthState {
  AuthState({this.session, this.hmail_key, this.status = AuthStatus.unknown});
  final String? session;
  final String? hmail_key;
  final AuthStatus status;

  AuthState.init({required String hmail_key, required String session})
      : this(
            hmail_key: hmail_key, session: session, status: AuthStatus.unknown);

  AuthState.authenticated({required String hmail_key, required String session})
      : this(
          hmail_key: hmail_key,
          session: session,
          status: AuthStatus.authenticated,
        );

  AuthState.unauthenticated()
      : this(
          hmail_key: null,
          session: null,
          status: AuthStatus.unauthenticated,
        );
}
