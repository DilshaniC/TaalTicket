import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../../communicators/ticket.dart';
import '../../communicators/venue.dart';

class PaymentPage extends StatefulWidget {
  final String showName;
  final Venue selectedVenue;
  final Ticket selectedTicket;
  final int ticketCount;

  PaymentPage({super.key, 
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

      // Send encrypted details to backend
      bool success = await _sendCardDetailsToBackend(encrypted.base64);

      if (success) {
        _showMessage('Payment Successful', true);
      } else {
        _showMessage('Payment Failed', false);
      }
    }
  }

  Future<bool> _sendCardDetailsToBackend(String encryptedCardDetails) async {
    // TODO: Implement your backend call here
    // For demo purposes, we'll just return true
    await Future.delayed(const Duration(seconds: 2));
    return true; // or false based on backend response
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
                  Navigator.pop(context); // Go back to the previous screen
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
                decoration: const InputDecoration(labelText: 'Expiry Date (MM/YY)'),
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
            ],
          ),
        ),
      ),
    );
  }
}
