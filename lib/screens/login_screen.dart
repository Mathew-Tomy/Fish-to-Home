import 'dart:convert';
import 'package:fishtohome/colors/Colors.dart';
import 'package:fishtohome/data/sharedpreferences.dart';
import 'package:fishtohome/modals/User_modal.dart';
import 'package:fishtohome/restAPI/API.dart';
import 'package:fishtohome/screens/signup_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'forgot_password.dart';
import 'package:google_sign_in/google_sign_in.dart';


class Loginscreen extends StatefulWidget {
  const Loginscreen({Key? key}) : super(key: key);

  @override
  _LoginscreenState createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {


  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading  =  false;
  String ?email;
  String ?password;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();

  // final GoogleSignIn _googleSignIn = GoogleSignIn(
  //   clientId: '449772119504-6otlqrf344phacoe2ah92d5nhbia03un.apps.googleusercontent.com',
  // );

  void _submit() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    formKey.currentState!.save();
    await _login();
  }

  void showSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      padding: EdgeInsets.all(10),
      backgroundColor: CustomColor.primaryColor,
      content: Text(
        msg,
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      duration: const Duration(seconds: 4),
    ));
  }

  Future<void> _login() async {
    String url = ApiUrl.login;

    try {
      // Send the request with proper JSON encoding for the body
      Response response = await post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          'email': email!,
          'password': password!,
        }),
      );

      // Check the response status code
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Check for success
        if (responseData['success'] == 'Login successful') {
          dynamic apiTokenData = responseData['api_token'];
          String? token;

          if (apiTokenData is String) {
            token = apiTokenData;
          } else if (apiTokenData is Map<String, dynamic>) {
            token = apiTokenData['id'].toString();
          }

          if (token != null) {
            // Save the token and address
            await Userpreferences().saveToken(token);
            if (responseData.containsKey('address')) {
              Address address = Address.fromJson(responseData['address']);
              await Userpreferences().saveUser(address);
            }

            // Navigate to the dashboard
            Navigator.pushReplacementNamed(context, "/dashboard");
          } else {
            showSnackbar('Invalid API session: Token missing');
          }
        } else {
          showSnackbar('Invalid email or password');
        }
      } else {
        showSnackbar('Invalid email or password');
      }
    } catch (e) {
      print('Error during login: $e');
      showSnackbar('An error occurred. Please try again later.');
    } finally {
      // Stop the loading spinner regardless of the result
      setState(() {
        isLoading = false;
      });
    }
  }

  // Future<void> _handleGoogleSignIn() async {
  //   try {
  //     final GoogleSignInAccount? account = await _googleSignIn.signIn();
  //     if (account != null) {
  //       final GoogleSignInAuthentication auth = await account.authentication;
  //       final String? idToken = auth.idToken;
  //       final String authorizationHeader = idToken ?? '';
  //       // Provide a default value if idToken is null
  //       String url = ApiUrl.google;
  //       final Response response = await post(
  //         Uri.parse(url),
  //         headers: {'Authorization': authorizationHeader},
  //         body: {'email': email}, // Include any other necessary data in the body
  //       );

  //       if (response.statusCode == 200) {
  //         final Map<String, dynamic> responseData = json.decode(response.body);
  //         if (responseData.containsKey('success') && responseData['success'] == 'Login successful') {
  //           // Extract and save the token
  //           if (responseData.containsKey('api_token')) {
  //             dynamic apiTokenData = responseData['api_token'];
  //             String? token;
  //             if (apiTokenData is String) {
  //               // Token is directly available
  //               token = apiTokenData;
  //             } else if (apiTokenData is Map<String, dynamic>) {
  //               // Token needs further extraction
  //               token = apiTokenData['id'].toString();
  //             }
  //             if (token != null) {
  //               Userpreferences().saveToken(token);

  //               // Handle user data and navigation
  //               if (responseData.containsKey('address')) {
  //                 Address address = Address.fromJson(responseData['address']);
  //                 Userpreferences().saveUser(address);
  //                 Navigator.pushReplacementNamed(context, "/dashboard");
  //               } else {
  //                 showSnackbar('Invalid user details');
  //               }
  //             } else {
  //               showSnackbar('Invalid API session');
  //             }
  //           } else {
  //             showSnackbar('Invalid API session');
  //           }
  //         } else {
  //           showSnackbar('Invalid API session');
  //         }
  //       } else {
  //         showSnackbar('Failed to connect to server');
  //       }


  //     } else {
  //       // Sign-in canceled by user
  //       showSnackbar('Google sign-in canceled');
  //     }
  //   } catch (error) {
  //     // Handle sign-in errors
  //     print('Google sign-in error: $error');
  //     showSnackbar('Failed to sign in with Google. Please try again.');
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 100,
                    height: 100,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              'Sign In',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black, fontSize: 25, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 7.5,),
            Text(
              'Sign in with your email and password \n or continue with social media',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black38, fontSize: 18),
            ),
            SizedBox(height: 25,),
            Padding(
              padding: const EdgeInsets.only(left:10.0,right: 10),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.grey),
                  hintText: 'Enter your email',
                  suffixIcon: Icon(Icons.email_outlined,color: Colors.grey,),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                onSaved: (value) {
                  email = value;
                },
                validator: (String? value){
                  if(value!.isEmpty){
                    return 'Enter email address';
                  }else{
                    return null;
                  }
                },
              ),
            ),
            SizedBox(height: 25,),
            Padding(
              padding: const EdgeInsets.only(left:10.0,right: 10),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color: Colors.grey),
                  hintText: 'Enter your password',
                  suffixIcon: Icon(Icons.lock_outline,color: Colors.grey,),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                onSaved: (value) {
                  password = value;
                },
                validator: (String? value){
                  if(value!.isEmpty){
                    return 'Enter your password';
                  }else{
                    return null;
                  }
                },
              ),
            ),
            SizedBox(height: 25,),
            InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: Text('Forgot Password',style: TextStyle(
                      fontSize: 15,
                      decoration: TextDecoration.underline,
                    ),),
                  )
                ],
              ),
              onTap: () => {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Forgotpassword()))
              },
            ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 12.0,right: 12),
              child: isLoading ? Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(CustomColor.accentColor),
                ),
              ) : GestureDetector(
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: CustomColor.primaryColor,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Center(
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,

                      ),
                    ),
                  ),
                ),
                onTap: () {
                  if (!isLoading) {
                    _submit();
                  }
                },
              ),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don`t have an account? ',
                ),
                SizedBox(width: 5,),
                GestureDetector(
                  child: Text(
                    'SIGN UP',
                    style: TextStyle(
                      color: CustomColor.primaryColor,
                      fontWeight: FontWeight.bold,

                    ),
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => Signupscreen()));

                  },
                )

              ],
            ),
            SizedBox(height: 25,),
            // Padding(
            //   padding: const EdgeInsets.only(left: 12.0, right: 12),
            //   child: isLoading
            //       ? Center(
            //     child: CircularProgressIndicator(
            //       valueColor: AlwaysStoppedAnimation<Color>(CustomColor.accentColor),
            //     ),
            //   )
            //       : GestureDetector(
            //     onTap: _handleGoogleSignIn,
            //     child: Container(
            //       height: 50,
            //       width: MediaQuery.of(context).size.width,
            //       decoration: BoxDecoration(
            //         color: Colors.red,
            //         borderRadius: BorderRadius.circular(20),
            //       ),
            //       child: Center(
            //         child: Text(
            //           'Sign in with Google',
            //           style: TextStyle(
            //             color: Colors.white,
            //             fontSize: 18,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),


            // Add Google login button

          ],
        ),
      ),
    );
  }
}





