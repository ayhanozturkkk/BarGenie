import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthState {
  final bool isAuthenticated;
  final String? nickname;

  AuthState({this.isAuthenticated = false, this.nickname});

  AuthState copyWith({bool? isAuthenticated, String? nickname}) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      nickname: nickname ?? this.nickname,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  void register(String nickname) {
    state = state.copyWith(isAuthenticated: true, nickname: nickname);
  }

  void logout() {
    state = AuthState();
  }
}
