import 'dart:convert';
import 'package:glitzy/colors/Colors.dart';
import 'package:glitzy/screens/signup_screen.dart';
import 'package:glitzy/widgets/back_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glitzy/restAPI/API.dart';
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
  String ?email;


  void _submit() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    } else {
      setState(() {
        isLoading = true;
      });
    }
    formKey.currentState!.save();
    // Call function to save password
    await _savePassword();
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.white,
          child: ListView(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              BackWidget( title: 'Forgot Password'),
              SizedBox(height: 40,),
              headingWidget(context),
              SizedBox(height: 35,),
              formWidget(context),
              SizedBox(height: 25,),
              continueWidget(context),
              SizedBox(height: 25,),
              accountWidget(context),
            ],
          ),
        ),
      ),
    );
  }


  headingWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          'Forgot Password',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 7.5,),
        Text(
          'Please enter your email and we will send \n  you a link to return to your account',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black38, fontSize: 15),
        ),
      ],
    );
  }

  formWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:  [
        Form(
          key: formKey,
          child: Padding(
            padding:  EdgeInsets.only(left:10.0,right: 10),
            child: TextFormField(

              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(color: Colors.grey),
                hintText: 'Enter your email',
                suffixIcon: Icon(Icons.email_outlined,color: Colors.grey,),
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
        ),

      ],
    );
  }

  continueWidget(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(left: 12.0,right: 12),
      child: GestureDetector(
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
        onTap: () => {
          _submit()
        },
      ),
    );
  }

  accountWidget(BuildContext context){
    return Row(
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
    );
  }
  _savePassword() async {
    String url =  ApiUrl.forgotPassword;

    Response response = await post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body:{

          'email':email
        }
    );
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      showSnackbar('We Have Sent a Link To Your Account!. Please Check Your Email');
    } else {
      print('Contact admin');
    }

  }

  showSnackbar(msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      padding: EdgeInsets.all(10),
      backgroundColor: CustomColor.primaryColor,
      content: Text(
        msg,
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      duration: Duration(seconds: 4),
    ));
  }
}
