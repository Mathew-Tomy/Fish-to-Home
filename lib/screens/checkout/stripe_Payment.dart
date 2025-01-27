import 'package:flutter/services.dart'; // For platform exceptions
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:glitzy/restAPI/API.dart';
import 'package:glitzy/.env.dart';

class StripeCheckout extends StatefulWidget {
  final String totalAmount;
  final String secretKey;
  final String publicKey;
  final bool isHomeDelivery; // New parameter
  const StripeCheckout({
    Key? key,
    required this.totalAmount,
    required this.secretKey,
    required this.publicKey,
    required this.isHomeDelivery,
  }) : super(key: key);

  @override
  _StripeCheckoutState createState() => _StripeCheckoutState();
}

class _StripeCheckoutState extends State<StripeCheckout> {
  bool isLoading = true;
  Map<String, dynamic>? paymentIntentData;

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
        child: isLoading
            ? CircularProgressIndicator() // Show a loading indicator while processing payment
            : const Text("Processing payment..."),
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Adjust total amount for home delivery
      double totalAmount = double.parse(widget.totalAmount);
      if (widget.isHomeDelivery) {
        totalAmount += 7.0; // Add $7 if Home Delivery is selected
      }

      // Create payment intent with the updated total amount
      paymentIntentData = await createPaymentIntent(totalAmount.toString(), 'CAD');

      // Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          customFlow: true,
          style: ThemeMode.dark,
          merchantDisplayName: 'FishToHome',
        ),
      );

      // Display payment sheet
      await displayPaymentSheet();
    } catch (e) {
      print('Error in makePayment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment failed. Please try again.")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();

      // Confirm the payment
      await Stripe.instance.confirmPaymentSheetPayment();

      // Log payment details for debugging
      print('Payment Intent ID: ${paymentIntentData!['id']}');
      print('Client Secret: ${paymentIntentData!['client_secret']}');
      print('Full Payment Intent Data: $paymentIntentData');

      // Extract the Payment Intent ID from paymentIntentData
      String paymentIntentId = paymentIntentData!['id'];

      // Save the order in the backend
      await saveOrderToDatabase(paymentIntentId, widget.isHomeDelivery ? "true" : "false");

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment successful!")),
      );

      // Navigate to the dashboard or another success page
      Navigator.pushReplacementNamed(context, "/dashboard");
    } on StripeException catch (e) {
      print('StripeException: $e');
      showSnackbar('Payment failed. Please try again.');
    } catch (e) {
      print('Unknown error: $e');
      showSnackbar('An error occurred. Please try again.');
    }
  }

  Future<void> saveOrderToDatabase(String paymentIntentId, String isHomeDelivery) async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? customerId = prefs.getString('customer_id');

    if (customerId == null || customerId.isEmpty) {
      showSnackbar('User not logged in');
      setState(() {
        isLoading = false;
      });
      return;
    }

    String url = ApiUrl.StripeCheckout;

    try {
      // Log the data being sent to the backend
      print('Sending to backend:');
      print('Customer ID: $customerId');
      print('Payment Intent ID: $paymentIntentId');
      print('Total Amount: ${widget.totalAmount}');
      print('Service Charge: ${isHomeDelivery == "true" ? 7 : 0}');

      final http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          'customer_id': customerId,
          'payment_intent_id': paymentIntentId, // Pass Payment Intent ID
          'total_amount': widget.totalAmount,
          'service_charge': isHomeDelivery == "true" ? 7 : 0,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == true) {
          showSnackbar('Order placed successfully!');
          Navigator.pushReplacementNamed(context, "/dashboard");
        } else {
          showSnackbar('Order not placed: ${responseData['message']}');
        }
      } else {
        print('Failed to checkout: ${response.statusCode}');
        print('Response Body: ${response.body}');
        showSnackbar('Failed to checkout. Please try again later.');
      }
    } catch (error) {
      print('Error during checkout: $error');
      showSnackbar('An error occurred while checking out. Please try again later.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  Future<Map<String, dynamic>> createPaymentIntent(String totalAmountString, String currency) async {
    try {
      double amount = double.tryParse(totalAmountString) ?? 0.0;
      if (amount <= 0) throw Exception('Invalid total amount.');

      int amountInCents = (amount * 100).toInt();

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${widget.secretKey}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': amountInCents.toString(),
          'currency': currency,
          'payment_method_types[]': 'card',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create payment intent.');
      }
    } catch (e) {
      print('Error creating payment intent: $e');
      throw e;
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}


