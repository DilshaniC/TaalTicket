import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../communicators/ticket.dart';
import '../../communicators/venue.dart';
import 'package:rive_animation/user_session.dart';

import 'main_screen.dart';

class PaymentPage extends StatefulWidget {
  final String id;
  final String showName;
  final Venue selectedVenue;
  final Ticket selectedTicket;
  final int ticketCount;

  PaymentPage({
    super.key,
    required this.id,
    required this.showName,
    required this.selectedVenue,
    required this.selectedTicket,
    required this.ticketCount,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();

  Future<bool> _bookTicket() async {
    final url = Uri.parse('http://localhost:9090/tickets/addNew');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "showId": widget.id,
        "userId": UserSession().userId,
        "location": widget.selectedVenue.location,
        "ticketCount":widget.ticketCount,
        "price": widget.selectedTicket.price,
        "starttime": widget.selectedVenue.starttime,
        "endtime": widget.selectedVenue.endtime,
        "status": "Booked"
      }),
    );

    if (response.statusCode >= 200 || response.statusCode < 300) {
      return true;
    } else {
      return false;
    }
  }

  void _processPayment() async {
    if (_formKey.currentState!.validate()) {
      String cardNumber = _cardNumberController.text;
      String expiryDate = _expiryDateController.text;
      String cvv = _cvvController.text;

      // Encrypt card details
      final plainText = '$cardNumber|$expiryDate|$cvv';
      final key = encrypt.Key.fromLength(32);
      final iv = encrypt.IV.fromLength(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      final encrypted = encrypter.encrypt(plainText, iv: iv);

      // Mock payment process
      await Future.delayed(const Duration(seconds: 2));

      // Send encrypted details to backend (mocked here)
      bool paymentSuccess =
          true; // Assume payment is always successful for mock

      if (paymentSuccess) {
        // Book the ticket
        bool bookingSuccess = await _bookTicket();

        if (bookingSuccess) {
          _showMessage('Payment and Booking Successful', true);
        } else {
          _showMessage('Payment Successful, but Booking Failed', false);
        }
      } else {
        _showMessage('Payment Failed', false);
      }
    }
  }

  void _showMessage(String message, bool isSuccess) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isSuccess ? 'Success' : 'Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                if (isSuccess) {
                  // Navigator.pop(context); //
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                  );// Go back to the previous screen
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment for ${widget.showName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(labelText: 'Card Number'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your card number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _expiryDateController,
                decoration:
                    const InputDecoration(labelText: 'Expiry Date (MM/YY)'),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the expiry date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cvvController,
                decoration: const InputDecoration(labelText: 'CVV'),
                keyboardType: TextInputType.number,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the CVV';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: _processPayment,
                  child: Text('Pay Now'),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Center(
                child: Text("* This is a test payment screen. Please do not enter your original card details here"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
