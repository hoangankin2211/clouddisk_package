abstract class AuthEvent {}

class AuthenticationLoginRequest extends AuthEvent {}

class CheckingAuthenticationCondition extends AuthEvent {
  CheckingAuthenticationCondition();
}
