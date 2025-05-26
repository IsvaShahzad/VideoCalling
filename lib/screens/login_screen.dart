import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_app/screens/registered_users_screen.dart';
import 'package:video_app/screens/sign_up.dart';



class EmailLoginScreen extends StatefulWidget {
  @override
  _EmailLoginScreenState createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  Future<void> loginUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();

      // Try signing in directly
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: _passwordController.text,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Navigate to registration screen after successful login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => RegisteredUsersScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = "Login failed. Please check your credentials.";

      if (e.code == 'user-not-found') {
        message = "Email does not exist. You can create a new account.";
      } else if (e.code == 'wrong-password') {
        message = "Wrong password. Please try again.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An unexpected error occurred."),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [

          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.28,
            child: Image.asset(
              'assets/images/design1.png',
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Positioned image and back arrow button
                  Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 200), // Adjust padding for the top space
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 31,
                                  fontFamily: 'Montserrat',
                                ),


                              ),


                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Log in to existing account",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ),


                            SizedBox(height: 30),
                            // Email TextField
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3.0),
                              child: TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontFamily: 'Montserrat',
                                  fontSize: 14,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 14,
                                    fontFamily: 'Montserrat',
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2),
                                    borderSide: BorderSide(color: Colors.grey.shade400),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2),
                                    borderSide: BorderSide(color: Colors.grey.shade400),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2),
                                    borderSide: BorderSide(color: Colors.grey.shade500),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 9, horizontal: 18),
                                ),
                              ),
                            ),


                            SizedBox(height: 20),
                            // Password TextField
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3.0),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: true,
                                style: TextStyle(
                                  fontFamily: 'Montserrat', // Text input font
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                    fontFamily: 'Montserrat', // Label font
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
                                  hintStyle: TextStyle(
                                    fontFamily: 'Montserrat', // Hint font
                                    color: Colors.grey.shade400,
                                    fontSize: 14,

                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2),
                                    borderSide: BorderSide(color: Colors.grey.shade400),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2),
                                    borderSide: BorderSide(color: Colors.grey.shade400),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2),
                                    borderSide: BorderSide(color: Colors.grey.shade500),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 9, horizontal: 18),
                                ),
                              ),
                            ),
                            SizedBox(height: 70),
                            // Continue Button
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : loginUser,
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Color(0xFFF00008B),
                                  minimumSize: Size(double.infinity, 48),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                child: Text(
                                  'Continue',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'or',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontFamily: 'Montserrat',
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => EmailSignUpScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0.5,
                                foregroundColor: Colors.black87,
                                backgroundColor: Colors.white,
                                minimumSize: Size(double.infinity, 48),
                                padding: EdgeInsets.symmetric(vertical: 11),
                                side: BorderSide(color: Color(0xff7393B3)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.email_rounded,
                                      color: Color(0xFFF00008B), size: 20.0),
                                  SizedBox(width: 20),
                                  Text(
                                    'Sign up with email',
                                    style: TextStyle(
                                      color: Color(0xFFF00008B),
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}