import 'dart:convert';

import 'package:glitzy/colors/Colors.dart';
import 'package:glitzy/restAPI/API.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:glitzy/modals/Cities_modal.dart';
import 'package:glitzy/modals/Countries_modal.dart';
import 'package:glitzy/modals/States_modal.dart';
import 'dashboard_screen.dart';

class Addaddress extends StatefulWidget {

  const Addaddress({Key? key}) : super(key: key);

  @override
  _AddaddressState createState() => _AddaddressState();
}

class _AddaddressState extends State<Addaddress> {
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
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          'New Address',
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
                child: Container(
                  child: Column(
                    children: [
                      TextFormField(
                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: "First Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                                width: 1, color: Colors.black54),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                                width: 1, color: Colors.black54),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                                width: 1, color: Color(0xff3d63ff)),
                          ),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter first name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          firstname = value;
                        },
                      ),
                      SizedBox(height: 10,),
                      TextFormField(

                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: "Last Name",
                          border:
                          OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.black54)),
                          enabledBorder:
                          OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.black54)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                                width: 1, color: Color(0xff3d63ff)),
                          ),
                        ),

                        textCapitalization:
                        TextCapitalization.sentences,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter last name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          lastname = value;
                        },
                      ),
                      SizedBox(height: 10,),
                      TextFormField(

                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: "Phone",
                          border:
                          OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.black54)),
                          enabledBorder:
                          OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.black54)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                                width: 1, color: Color(0xff3d63ff)),
                          ),
                        ),

                        textCapitalization:
                        TextCapitalization.sentences,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter phone';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          customer_mobile = value;
                        },
                      ),

                      SizedBox(height: 10,),
                      TextFormField(

                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: "Address 1",
                          border:
                          OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.black54)),
                          enabledBorder:
                          OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.black54)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                                width: 1, color: Color(0xff3d63ff)),
                          ),
                        ),

                        textCapitalization:
                        TextCapitalization.sentences,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter address 1';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          customer_address_1 = value;
                        },
                      ),
                      SizedBox(height: 10,),
                      TextFormField(

                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: "Address 2",
                          border:
                          OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.black54)),
                          enabledBorder:
                          OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.black54)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                                width: 1, color: Color(0xff3d63ff)),
                          ),
                        ),

                        textCapitalization:
                        TextCapitalization.sentences,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter address 2';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          customer_address_2 = value;
                        },
                      ),

                      SizedBox(height: 10,),
                      DropdownButtonFormField<String>(
                        value: selectedCountry,
                        items: countries?.map((country) {
                          return DropdownMenuItem<String>(
                            value: country.name,
                            child: Text(country.name ?? 'Unknown'),
                          );
                        }).toList() ?? [],
                        onChanged: (value) {
                          setState(() {
                            selectedCountry = value;
                            country = value; // Ensure the variable is updated
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
                        items: states?.map((state) {
                          return DropdownMenuItem<String>(
                            value: state.name,
                            child: Text(state.name!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedState = value;
                            state = value; // Ensure the variable is updated
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(

                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: "Post Code",
                          border:
                          OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.black54)),
                          enabledBorder:
                          OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.black54)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                                width: 1, color: Color(0xff3d63ff)),
                          ),
                        ),

                        textCapitalization:
                        TextCapitalization.sentences,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter postcode';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          zip = value;
                        },
                      ),
                      // Other TextFormField widgets go here
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),

            // Other widgets go here
            SizedBox(height: 15,),
            isLoading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : MaterialButton(
              onPressed: () {
                _submit();
              },
              color: CustomColor.accentColor,
              padding: EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              child: Text(
                "Save Address",
                style: TextStyle(color: Colors.white),
              ),
            ),

          ],
        ),
      ),
    );
  }


  _saveAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? customerId = prefs.getString('customer_id');

    if (customerId == null || customerId.isEmpty) {
      _showMyDialog('User not logged in');
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
          'state':  selectedState?? '',
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
          _showMyDialog(responseData['message'] ?? 'Failed to update address.');
        }
      } else {
        setState(() {
          isLoading = false;
        });
        print('Error: ${response.statusCode}, Body: ${response.body}');
        _showMyDialog('Failed to update address. Please try again.');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Exception: $e');
      _showMyDialog('An error occurred. Please try again.');
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
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) =>
                        Dashboard()), (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }

}