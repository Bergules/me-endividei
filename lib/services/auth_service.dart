import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  static GoogleSignInAccount? _currentUser;
  static bool _isGuest = false;

  static GoogleSignInAccount? get currentUser => _currentUser;
  static bool get isGuest => _isGuest;
  static bool get isLoggedIn => _currentUser != null || _isGuest;

  static String get displayName {
    if (_currentUser != null) return _currentUser!.displayName ?? 'Usuario';
    return 'Visitante';
  }

  static String get email {
    if (_currentUser != null) return _currentUser!.email;
    return '';
  }

  static String? get photoUrl {
    if (_currentUser != null) return _currentUser!.photoUrl;
    return null;
  }

  static Future<bool> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        _currentUser = account;
        _isGuest = false;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static void continueAsGuest() {
    _isGuest = true;
    _currentUser = null;
  }

  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    _currentUser = null;
    _isGuest = false;
  }
}
