import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:glitzy/restAPI/API.dart';
import 'package:glitzy/.env.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';



class StripeCheckouts extends StatefulWidget {
  final String totalAmount; // Specify the type of totalAmount



  const StripeCheckouts({super.key,required this.totalAmount});

  @override
  _StripeCheckoutsState createState() => _StripeCheckoutsState();
}
  class _StripeCheckoutsState extends State<StripeCheckouts> {
    Map<String, dynamic>? paymentIntentData;
    bool isLoadingButton = false;
    @override
    void initState() {
      super.initState();
      // Initiate the payment process as soon as the page is loaded
      makePayment();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Payment Transaction'),
        ),
        body: Center(
          child: CircularProgressIndicator(), // Show a loading indicator while processing payment
        ),
      );
    }


    Future<void> makePayment() async {
      setState(() {
        isLoadingButton = true;
      });

      try {
        // Perform payment transaction
        String totalAmountString = widget.totalAmount.toString();
        // Perform payment transaction
        await performPaymentTransaction(widget.totalAmount.toString());



      } catch (e, s) {
        // Handle payment transaction failure
        print('Payment failed: $e');
        // You can display an error message to the user if needed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Payment failed. Please try again.")),
        );
      } finally {
        setState(() {
          isLoadingButton = false;
        });
      }
    }


    Future<void> performPaymentTransaction(String totalAmountString) async {
      // Implement logic to perform payment transaction
      paymentIntentData = await createPaymentIntent(totalAmountString, 'CAD');
      //
      // Initialize payment sheet
      await Stripe.instance
          .initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          setupIntentClientSecret: STRIPE_SECRET,
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          customFlow: true,
          style: ThemeMode.dark,
          merchantDisplayName: 'Glitzy',
        ),
      )
          .then((value) {
        // Display payment sheet
        displayPaymentSheet();
      });

    }
    displayPaymentSheet() async {
      try {
        await Stripe.instance
            .presentPaymentSheet(

        )
            .then((newValue) {
          Stripe.instance.confirmPaymentSheetPayment();
          print('payment intent' + paymentIntentData!['id'].toString());
          print(
              'payment intent' + paymentIntentData!['client_secret'].toString());
          print('payment intent' + paymentIntentData!['amount'].toString());
          print('payment intent' + paymentIntentData.toString());
          //orderPlaceApi(paymentIntentData!['id'].toString());
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("paid successfully"),
          ));

          // Save order to database
          saveOrderToDatabase(widget.totalAmount.toString());

          paymentIntentData = null;
        }).onError((error, stackTrace) {
          print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
        });
      } on StripeException catch (e) {
        print('Exception/DISPLAYPAYMENTSHEET==> $e');
        showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            content: Text("Cancelled "),
          ),
        );
      } catch (e) {
        print('$e');
      }
    }
    //  Future<Map<String, dynamic>>widget.totalAmount
    Future<Map<String, dynamic>> createPaymentIntent(String totalAmountString, String currency) async {
      try {
        // Parse totalAmountString as a double
        //double amount = double.tryParse(totalAmountString) ?? 0;
        double amount = double.tryParse(totalAmountString) ?? 0.0;

        // Check if amount is non-negative
        if (amount <= 0) {
          throw Exception('Invalid total amount');
        }

        // Convert amount to cents (assuming USD)
        int amountInCents = (amount * 100).toInt();

        Map<String, dynamic> body = {
          'amount': amountInCents.toString(),
          'currency': currency,
          'payment_method_types[]': 'card',
        };

        print(body);
        var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer ' + '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',
            'Content-Type': 'application/x-www-form-urlencoded'
          },
        );
        print('Create Intent reponse ===> ${response.body.toString()}');
        return jsonDecode(response.body);
      } catch (err) {
        print('err charging user: ${err.toString()}');
        throw err; // Rethrow the exception to handle it in makePayment function
      }
    }


    Future<void>  saveOrderToDatabase(String totalAmountString) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int userId = prefs.getInt('id') ?? 0; // Get user ID as an integer
      String url =  ApiUrl.StripeCheckout;
      try {
        final http.Response response = await http.post(
            Uri.parse(url),
            headers: {
              "Content-Type": "application/x-www-form-urlencoded",
            },
            body:{
              'customer_id': userId.toString(),
              'total_amount':totalAmountString,
            }
        );
        if (response.statusCode == 200) {
          setState(() {
            isLoadingButton = false;
          });
          _showMyDialog('Order has been placed');
          final Map<String, dynamic> responseData = json.decode(response.body);
          print(responseData);
          if (responseData['success'] == 'Success: API session successfully started!') {
            _showMyDialog('Order Placed successfully');
            Navigator.pushReplacementNamed(context, "/dashboard");
          } else {
            showSnackbar('Order not placed: ${responseData['error']}');
          }
        } else if (response.statusCode == 302) {
          // Handle redirection
          String? redirectUrl = response.headers['location'];
          if (redirectUrl != null) {
            print('Redirecting to: $redirectUrl');
            // Optionally, you can navigate to the login screen here
            Navigator.pushReplacementNamed(context, "/dashboard");
          }
        } else {
          print('Failed to checkout: ${response.statusCode}');
          showSnackbar('Failed to checkout. Please try again later.');
        }
      } catch (error) {
        print('Error checkout: $error');
        showSnackbar('An error occurred while checkout. Please try again later.');
      }
    }





    calculateAmount(String amount) {
      final a = (int.parse(amount)) * 100;
      return a.toString();
    }


    void showSnackbar(String message) {
      // TODO: Implement the snackbar method to show messages
    }

    Future<void> _showMyDialog(String message) async {
      // TODO: Implement the dialog method to show messages
    }

  }




