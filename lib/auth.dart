import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/auth/login_controller.dart';
import 'package:wakeuphoney/auth/login_tabscreen.dart';

class LoginAuth extends ChangeNotifier {
  bool _signedIn = true;

  /// Whether user has signed in.
  bool get signedIn => _signedIn;

  /// Signs out the current user.
  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // Sign out.
    _signedIn = false;
    notifyListeners();
  }

  /// Signs in a user.
  Future<bool> signIn(String username, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    // Sign in. Allow any password.
    _signedIn = true;
    notifyListeners();
    return _signedIn;
  }

  String? guard(BuildContext context, GoRouterState state) {
    final bool signedIn = this.signedIn;
    final bool signingIn = state.matchedLocation == '/logintabs';

    // Go to /signin if the user is not signed in
    if (!signedIn && !signingIn) {
      return '/logintabs';
    }
    // Go to /books if the user is signed in and tries to go to /signin.
    else if (signedIn && signingIn) {
      return '/';
    }

    // no redirect
    return null;
  }
}

/// An inherited notifier to host [LoginAuth] for the subtree.
class LoginAuthScope extends InheritedNotifier<LoginAuth> {
  /// Creates a [LoginAuthScope].
  const LoginAuthScope({
    required LoginAuth super.notifier,
    required super.child,
    super.key,
  });

  /// Gets the [LoginAuth] above the context.
  static LoginAuth of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<LoginAuthScope>()!.notifier!;
}

final authLoginProvider = StateProvider<LoginAuth>((ref) {
  return LoginAuth();
});

class LoginAuthRiverpodScope extends ConsumerWidget {
  final LoginController loginController;
  final Widget child;

  const LoginAuthRiverpodScope({
    Key? key,
    required this.loginController,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(loginControllerProvider.notifier).signedIn
        ? child
        : Navigator(
            onGenerateRoute: (routeSettings) => MaterialPageRoute(
              settings: routeSettings,
              builder: (context) => const LoginNewScreen(), // Replace with your login screen
            ),
          );
  }

  // static LoginAuthScope of(BuildContext context) {

  //   final scope = ProviderScope.containerOf(context, listen: false).read<LoginAuthScope>(); // Use the 'containerOf' method instead of 'nearestAncestorWidget'
  //   if (scope == null) {
  //     throw Exception("LoginAuthScope not found in the widget tree");
  //   }
  //   return scope;
  // }
  static LoginAuthScope of(BuildContext context) {
    final scope = context.findAncestorWidgetOfExactType<LoginAuthScope>();
    if (scope == null) {
      throw Exception("LoginAuthScope not found in the widget tree");
    }
    return scope;
  }
}
