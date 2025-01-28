import 'dart:convert';
import 'package:fishtohome/modals/Cities_modal.dart';
import 'package:fishtohome/colors/Colors.dart';
import 'package:fishtohome/restAPI/API.dart';
import 'package:fishtohome/screens/login_screen.dart';
import 'package:fishtohome/widgets/back_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Signupscreen extends StatefulWidget {
  const Signupscreen({Key? key}) : super(key: key);

  @override
  _SignupscreenState createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  List<Cities> ?cities=[];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }
  void _initializeData() async {
    setState(() {
      isLoading = true;
    });

    await _getCities();
    setState(() {
      isLoading = false;
    });
  }
  String ?email;
  String ?password;
  String ?confirmpassword;
  String ?firstName;
  String ?lastName;
  String ?telephone;
  String? city;
  String? selectedCity;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading  =  false;

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

    _register(context);


  }
  _getCities() async {


    String url = '${ApiUrl.cities}'; // Use the POST endpoint URL
    setState(() {
      isLoading = true;

    });

    try {
      Response response = await get(Uri.parse(url), headers: {
        "Content-Type": "application/json",
      });
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['cities'] != null) {
          List<dynamic> cityData = responseData['cities'];

          setState(() {
            cities = cityData.map((city) => Cities.fromJson(city)).toList();
            isLoading = false;
          });
        } else {
          print('No cities found in the response');
        }
      } else {
        print('Failed to fetch countries. HTTP Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
              BackWidget( title: 'Sign Up'),
              SizedBox(height: 40,),
              headingWidget(context),
              SizedBox(height: 35,),
              formWidget(context),
              SizedBox(height: 25,),
              continueWidget(context),

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
          'Register Account',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 7.5,),
        Text(
          'Complete your details or continue \n  with social media',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black38, fontSize: 18),
        ),
      ],
    );
  }

  formWidget(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
          Padding(
            padding:  EdgeInsets.only(left:10.0,right: 10),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: "First Name",
                labelStyle: TextStyle(color: Colors.grey),
                hintText: 'Enter your name',
                suffixIcon: Icon(Icons.person,color: Colors.grey,),
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
                firstName = value;
              },
              validator: (String? value){
                if(value!.isEmpty){
                  return 'Enter your name';
                }else{
                  return null;
                }
              },
            ),
          ),
          SizedBox(height: 25,),
          Padding(
            padding:  EdgeInsets.only(left:10.0,right: 10),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: "Last Name",
                labelStyle: TextStyle(color: Colors.grey),
                hintText: 'Enter your last name',
                suffixIcon: Icon(Icons.person,color: Colors.grey,),
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
                lastName = value;
              },
              validator: (String? value){
                if(value!.isEmpty){
                  return 'Enter last name';
                }else{
                  return null;
                }
              },
            ),
          ),
          SizedBox(height: 25,),
          Padding(
            padding:  EdgeInsets.only(left:10.0,right: 10),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: "Telephone",
                labelStyle: TextStyle(color: Colors.grey),
                hintText: 'Enter your contact number',
                suffixIcon: Icon(Icons.phone,color: Colors.grey,),
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
                telephone = value;
              },
              validator: (String? value){
                if(value!.isEmpty){
                  return 'Enter phone number';
                }else{
                  return null;
                }
              },
            ),
          ),
          SizedBox(height: 25,),
          Padding(
            padding:  EdgeInsets.only(left:10.0,right: 10),
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
          SizedBox(height: 20,),
          // DropdownButtonFormField styled like the password TextFormField
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child: DropdownButtonFormField<String>(
              value: selectedCity,
              items: cities?.map((city) {
                return DropdownMenuItem<String>(
                  value: city.name,
                  child: Text(city.name ?? ''),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCity = value;
                  city = value; // Ensure the variable is updated
                });
              },
              decoration: InputDecoration(
                labelText: 'City',
                labelStyle: TextStyle(color: Colors.grey),
                hintText: 'Select your city',
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
                  return 'Enter password';
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
                labelText: "Confirm-Password",
                labelStyle: TextStyle(color: Colors.grey),
                hintText: 'Re-Enter your password',
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
                confirmpassword = value;
              },
              validator: (String? value){
                if(value!.isEmpty){
                  return 'Confirm password';
                }else{
                  return null;
                }
              },
            ),
          ),
        ],
      ),
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

  _register(BuildContext context) async {
    String url = ApiUrl.registration;

    try {
      // Sending POST request
      Response response = await post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          'email': email,
          'phone': telephone,
          'password': password,
          'first_name': firstName,
          'last_name': lastName,
          'city': selectedCity ?? '',
        }),
      );

      // Handle response
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          _showMyDialog('Account created successfully');
          Navigator.pushReplacementNamed(context, "/loginscreen");
        } else {
          // Show server-side error
          showSnackbar('Account not created: ${responseData['message']}');
        }
      } else if (response.statusCode == 400 || response.statusCode == 409) {
        // Bad request or conflict
        final Map<String, dynamic> responseData = json.decode(response.body);
        showSnackbar('Failed: ${responseData['message']}');
      } else {
        // Other errors
        print('Failed to register: ${response.statusCode}');
        showSnackbar('Failed to register. Please try again later.');
      }
    } catch (error) {
      print('Error registering user: $error');
      showSnackbar('An error occurred while registering. Please try again later.');
    }
  }



  Future<void> _showMyDialog(msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/loginscreen");
              },
            ),
          ],
        );
      },
    );
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
