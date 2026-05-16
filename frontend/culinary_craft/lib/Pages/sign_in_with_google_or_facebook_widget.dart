import 'package:culinary_craft_wireframe/Services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInWithGoogleOrFacebookWidget extends StatefulWidget {
  const SignInWithGoogleOrFacebookWidget({super.key});

  @override
  State<SignInWithGoogleOrFacebookWidget> createState() =>
      _SignInWithGoogleOrFacebookWidgetState();
}

class _SignInWithGoogleOrFacebookWidgetState
    extends State<SignInWithGoogleOrFacebookWidget> {

  // User? user;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   auth.authStateChanges().listen((event) {
  //     setState(() {
  //       user = event;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Sau orice culoare dorești
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Align(
                alignment: AlignmentDirectional(0, 0),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/icon2.png',
                          width: 208,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                        child: ElevatedButton(
                          onPressed: () async {
                            // Handle continue with Google
                            _handleGoogleSignIn();
                          },
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(
                              Size(double.infinity, 50),
                            ),
                            backgroundColor:
                            MaterialStateProperty.all(Color(0xFF90E0EF)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.google,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Continue with Google',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                        child: ElevatedButton(
                          onPressed: () async {
                            // Handle continue with Facebook
                            // print("Facebook signed in successfully!");
                            _handleFacebookSignIn();
                          },
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(
                              Size(double.infinity, 50),
                            ),
                            backgroundColor:
                            MaterialStateProperty.all(Color(0xFF90E0EF)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.facebook,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Continue with Facebook',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                HapticFeedback.lightImpact();
                                Navigator.of(context).pushNamed('/signin');
                              },
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                  Size(170, 50),
                                ),
                                backgroundColor:
                                MaterialStateProperty.all(Color(0xFF0077B6)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ),
                              child: Text(
                                'Sign In',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.of(context).pushNamed('/signup');
                              },
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                  Size(170, 50),
                                ),
                                backgroundColor:
                                MaterialStateProperty.all(Color(0xFF0077B6)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ),
                              child: Text(
                                'Sign Up',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _handleGoogleSignIn() async {
    try {
      await GoogleSignIn.instance.initialize();
      final GoogleSignInAccount account =
      await GoogleSignIn.instance.authenticate();
      final String username =
      (account.displayName != null && account.displayName!.trim().isNotEmpty)
          ? account.displayName!.trim()
          : account.email.split('@').first;

      final String? errorMessage =
      await AuthService.signInWithGoogle(context, username, account.email);
      if (errorMessage != null) {
        _showError(errorMessage);
      }
    } on GoogleSignInException catch (e) {
      _showError(e.description ?? "Google Sign-In failed.");
    } catch (_) {
      _showError("Google Sign-In failed. Please try again.");
    }
  }

  _handleFacebookSignIn() async {
    final LoginResult loginResult = await FacebookAuth.instance.login(
      permissions: ['public_profile', 'email'],
    );

    if (loginResult.status == LoginStatus.success) {
      final Map<String, dynamic> userData = await FacebookAuth.instance.getUserData(
        fields: "name,email",
      );
      final String? email = userData['email']?.toString();
      if (email == null || email.isEmpty) {
        _showError("Facebook account did not return an email address.");
        return;
      }

      final String username = userData['name']?.toString().trim().isNotEmpty == true
          ? userData['name'].toString().trim()
          : email.split('@').first;

      final String? errorMessage =
      await AuthService.signInWithFacebook(context, username, email);
      if (errorMessage != null) {
        _showError(errorMessage);
      }
      return;
    }

    if (loginResult.status == LoginStatus.cancelled) {
      _showError("Facebook Sign-In cancelled.");
      return;
    }

    _showError(loginResult.message ?? "Facebook Sign-In failed.");
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
