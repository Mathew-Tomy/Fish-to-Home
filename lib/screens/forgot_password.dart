import 'dart:convert';
import 'package:fishtohome/colors/Colors.dart';
import 'package:fishtohome/screens/signup_screen.dart';
import 'package:fishtohome/widgets/back_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fishtohome/restAPI/API.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({Key? key}) : super(key: key);

  @override
  _ForgotpasswordState createState() => _ForgotpasswordState();

}

class _ForgotpasswordState extends State<Forgotpassword> {


  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading  =  false;
  String? email, password, confirm;


  // Submit Form and Call API
  void _submit() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      _savePassword();
    }
  }



  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    formWidget(context),
                    SizedBox(height: 20),
                    continueWidget(context),
                    SizedBox(height: 20),
                    accountWidget(context),
                  ],
                ),
              ),
            ),
    );
  }

  // Email, Password, Confirm Password Form
  Widget formWidget(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          inputField(
            label: "Email",
            hintText: "Enter your email",
            icon: Icons.email_outlined,
            onSaved: (value) => email = value,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter email address';
              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
          SizedBox(height: 15),
          inputField(
            label: "Password",
            hintText: "Enter new password",
            icon: Icons.lock_outline,
            isPassword: true,
            onSaved: (value) => password = value,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter a password';
              } else if (value.length < 6) {
                return 'Password must be at least 6 characters long';
              }
              return null;
            },
          ),
          SizedBox(height: 15),
          inputField(
            label: "Confirm Password",
            hintText: "Re-enter your password",
            icon: Icons.lock_outline,
            isPassword: true,
            onSaved: (value) => confirm = value,
            validator: (value) {
              // if (value!.isEmpty) {
              //   return 'Confirm your password';
              // } else if (value != password) {
              //   return 'Passwords do not matchs';
              // }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // Input Field Widget
  Widget inputField({
    required String label,
    required String hintText,
    required IconData icon,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
    bool isPassword = false,
  }) {
    return TextFormField(
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey),
        hintText: hintText,
        suffixIcon: Icon(icon, color: Colors.grey),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      onSaved: onSaved,
      validator: validator,
    );
  }

  // Submit Button
  Widget continueWidget(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            'Reset Password',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
      onTap: () => _submit(),
    );
  }

  // Signup Navigation Widget
  Widget accountWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Don’t have an account? '),
        GestureDetector(
          child: Text(
            'SIGN UP',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => Signupscreen()),
            );
          },
        ),
      ],
    );
  }

  // Submit Form and Call API


  // API Call
  Future<void> _savePassword() async {
    setState(() {
      isLoading = true;
    });

    String url = ApiUrl.forgotPassword;
    try {
      Response response = await post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          'email': email!,
          'password': password!,
          'confirm':confirm,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['status'] == true) {
        showSnackbar('Password reset successful! Please log in with your new password.');
      } else {
        showSnackbar(responseData['message'] ?? 'Something went wrong. Please try again.');
      }
    } catch (e) {
      showSnackbar('Failed to connect to the server. Please try again later.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Snackbar Helper
  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

