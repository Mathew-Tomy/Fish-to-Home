import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glitzy/colors/Colors.dart';
import 'package:glitzy/modals/Addressbook_modal.dart';
import 'package:glitzy/restAPI/API.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:glitzy/modals/Cities_modal.dart';
import 'package:glitzy/modals/Countries_modal.dart';
import 'package:glitzy/modals/States_modal.dart';
import 'dashboard_screen.dart';

class Viewaddress extends StatefulWidget {
  const Viewaddress({Key? key, required this.address}) : super(key: key);
  final AddressData address;

  @override
  _ViewaddressState createState() => _ViewaddressState();
}

class _ViewaddressState extends State<Viewaddress> {
  List<Countries> ?countries=[];
  List<States> ?states=[];
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
    await _getCountries();
    await _getStates();
    await _getCities();
    setState(() {
      isLoading = false;
    });
  }


  String? firstname;
  String? lastname;
  String? customer_mobile;
  String? customer_address_1;
  String? customer_address_2;
  String? city;
  String? state;
  String? country;
  String? zip;

  // Define the selected values
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;
  // final List<String> countries = ['Canada']; // Static dropdown for country
  // final List<String> states = ['Ontario']; // Static dropdown for state
  // final List<String> cities = ['London', 'Niagara falls', 'Scarborough'];

  var _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    } else {
      setState(() {
        isLoading = true;
      });
    }
    _formKey.currentState!.save();
    _saveAddress();
  }
  _getCountries() async {
    String url = '${ApiUrl.countries}'; // Use the POST endpoint URL
    setState(() {
      isLoading = true;
    });

    try {
      Response response = await get(Uri.parse(url), headers: {
        "Content-Type": "application/json",
      });
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['countries'] != null) {
          List<dynamic> countryData = responseData['countries'];
          setState(() {
            countries = countryData.map((country) => Countries.fromJson(country)).toList();
          });
        } else {
          print('No countries found in the response');
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

  _getStates() async {


    String url = '${ApiUrl.states}'; // Use the POST endpoint URL
    setState(() {
      isLoading = true;

    });

    try {
      Response response = await get(Uri.parse(url), headers: {
        "Content-Type": "application/json",
      });
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['states'] != null) {
          List<dynamic> stateData = responseData['states'];
          setState(() {
            states = stateData.map((state) => States.fromJson(state)).toList();
            isLoading = false;
          });

        } else {
          print('No states found in the response');
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


  Future<void> _showMyDialog(String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => Dashboard()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          'Edit Address Book',
          style: TextStyle(color: CustomColor.accentColor),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: CustomColor.accentColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // First Name
                    _buildTextFormField(
                      label: 'First Name',
                      initialValue: widget.address.firstname,
                      onSaved: (value) => firstname = value,
                      validator: (value) =>
                      value!.isEmpty ? 'Enter first name' : null,
                    ),

                    SizedBox(height: 10),

                    // Last Name
                    _buildTextFormField(
                      label: 'Last Name',
                      initialValue: widget.address.lastname,
                      onSaved: (value) => lastname = value,
                      validator: (value) =>
                      value!.isEmpty ? 'Enter last name' : null,
                    ),

                    SizedBox(height: 10),

                    // Phone
                    _buildTextFormField(
                      label: 'Phone',
                      initialValue: widget.address.customer_mobile,
                      onSaved: (value) => customer_mobile = value,
                      validator: (value) =>
                      value!.isEmpty ? 'Enter phone' : null,
                    ),

                    SizedBox(height: 10),

                    SizedBox(height: 10,),
                    DropdownButtonFormField<String>(
                      value: selectedCountry,
                      onSaved: (value) => selectedCountry = value,
                      items: countries?.map((country) {
                        return DropdownMenuItem<String>(
                          value: country.name,
                          child: Text(country.name ?? 'Unknown'),
                        );
                      }).toList() ?? [],
                      onChanged: (value) {
                        setState(() {
                          selectedCountry = value;

                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Country',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                    ),

// State Dropdown
                    SizedBox(height: 10,),
                    SizedBox(height: 10,),
                    DropdownButtonFormField<String>(
                      value: selectedState,
                      onSaved: (value) => selectedState= value,
                      items: states?.map((state) {
                        return DropdownMenuItem<String>(
                          value: state.name,
                          child: Text(state.name!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedState = value;

                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'State',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                    ),

// City Dropdown
                    SizedBox(height: 10,),
                    SizedBox(height: 10,),
                    DropdownButtonFormField<String>(
                      value: selectedCity,
                      onSaved: (value) => selectedCity= value,
                      items: cities?.map((city) {
                        return DropdownMenuItem<String>(
                          value: city.name,
                          child: Text(city.name ?? ''),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCity = value;

                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    // Address 1
                    _buildTextFormField(
                      label: 'Address 1',
                      initialValue: widget.address.customer_address_1,
                      onSaved: (value) => customer_address_1 = value,
                      validator: (value) =>
                      value!.isEmpty ? 'Enter address 1' : null,
                    ),

                    SizedBox(height: 10),

                    // Address 2
                    _buildTextFormField(
                      label: 'Address 2',
                      initialValue: widget.address.customer_address_2,
                      onSaved: (value) => customer_address_2 = value,
                      validator: (value) =>
                      value!.isEmpty ? 'Enter address 2' : null,
                    ),

                    SizedBox(height: 10),

                    // Zip Code
                    _buildTextFormField(
                      label: 'Post Code',
                      initialValue: widget.address.zip,
                      onSaved: (value) => zip = value,
                      validator: (value) =>
                      value!.isEmpty ? 'Enter postcode' : null,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            isLoading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : MaterialButton(
              onPressed: _submit,
              color: CustomColor.accentColor,
              padding:
              EdgeInsets.symmetric(vertical: 12, horizontal: 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              child: Text(
                "Update Address",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildDropdownDecoration({required String label}) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(width: 1, color: Colors.black54),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(width: 1, color: Colors.black54),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(width: 1, color: Color(0xff3d63ff)),
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required String? initialValue,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
  }) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: 1,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 1, color: Colors.black54),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 1, color: Colors.black54),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 1, color: Color(0xff3d63ff)),
        ),
      ),
      validator: validator,
      onSaved: onSaved,
    );
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
      duration: Duration(seconds: 4),
    ));
  }

  Future<void> _saveAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? customerId = prefs.getString('customer_id');

    if (customerId == null || customerId.isEmpty) {
      showSnackbar('User not logged in');
      setState(() {
        isLoading = false;
      });
      return;
    }

    String url = ApiUrl.updateAddress;
    setState(() {
      isLoading = true; // Start loading
    });

    try {
      Response response = await post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json", // JSON content type
        },
          body: json.encode({
          'first_name': firstname ?? '',
          'last_name': lastname ?? '',
          'customer_mobile': customer_mobile ?? '',
          'customer_address_1': customer_address_1 ?? '',
          'customer_address_2': customer_address_2 ?? '',
          'city': selectedCity ?? '',
          'state': selectedState ?? '',
          'zip': zip ?? '',
          'country': selectedCountry ?? '',
          'customer_id': customerId, // Use as string
          }),
      );

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });

        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == true) {
          _showMyDialog(
              responseData['message'] ?? 'Address updated successfully.');
        } else {
          showSnackbar(responseData['message'] ?? 'Failed to update address.');
        }
      } else {
        setState(() {
          isLoading = false;
        });
        print('Error: ${response.statusCode}, Body: ${response.body}');
        showSnackbar('Failed to update address. Please try again.');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Exception: $e');
      showSnackbar('An error occurred. Please try again.');
    }
  }
}