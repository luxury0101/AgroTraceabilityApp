import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthSessionController extends StateNotifier<int> {
  AuthSessionController() : super(0);

  void notifySessionExpired() {
    state++;
  }
}

final authSessionControllerProvider =
    StateNotifierProvider<AuthSessionController, int>(
      (ref) => AuthSessionController(),
    );
