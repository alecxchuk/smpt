import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthApi {
  static final _googleSignIn =
      GoogleSignIn(scopes: ['https://mail.google.com/']);

  static Future<GoogleSignInAccount?> signIn() async {
    var isUserSignedIn = await _googleSignIn.isSignedIn();

    if (isUserSignedIn) {
      return _googleSignIn.currentUser;
    } else {
      return await _googleSignIn.signIn();
    }
  }

  static Future signOut() => _googleSignIn.signOut();
}
