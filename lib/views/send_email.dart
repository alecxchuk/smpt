import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:smpt/app_strings.dart';
import 'package:smpt/services/google_api.dart';
import 'package:smpt/models/customer.dart';
import 'package:smpt/models/invoice.dart';
import 'package:smpt/models/invoice_info.dart';
import 'package:smpt/models/invoice_item.dart';
import 'package:smpt/models/supplier.dart';
import 'package:smpt/services/pdf_invoice_api.dart';

class SendEmail extends StatefulWidget {
  const SendEmail({Key? key}) : super(key: key);

  @override
  State<SendEmail> createState() => _SendEmailState();
}

class _SendEmailState extends State<SendEmail> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  // Loading State
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Shows a snackbar
    void showSnackBar(String text, [bool? error]) {
      final snackBar = SnackBar(
        content: Text(text, style: const TextStyle(fontSize: 20)),
        backgroundColor: error ?? false ? Colors.red : Colors.green,
      );

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(snackBar);
    }

    // Function sets the loading state
    void setLoading(bool val) {
      setState(() {
        isLoading = val;
      });
    }

    // Sends an email to a recipient
    // parameter: pdfFile containing bill invoice
    Future sendEmail(File pdfFile) async {
      // GoogleAuthApi.signOut();
      final user = await GoogleAuthApi.signIn();

      // check if user is null
      if (user == null) {
        showSnackBar(asAuthError, true);
        return;
      }

      // Sender email
      final email = user.email;
      // Auth object
      final auth = await user.authentication;

      // Access token
      final token = auth.accessToken;

      // Smtp server
      final smtpServer = gmailSaslXoauth2(email, token!);
      // Message object
      final message = Message()
        ..from = Address(email, asStoreName)
        ..recipients = [emailController.text]
        ..subject = '${nameController.text} Invoice'
        ..text = 'Please find the bill of sale invoice in this email'
        ..attachments = [FileAttachment(pdfFile)];

      try {
        await send(message, smtpServer);

        showSnackBar(asSentSuccess);
      } on MailerException catch (e) {
        showSnackBar(e.toString(), true);
      } catch (e) {
        showSnackBar(e.toString(), true);
      }
      emailController.clear();
      nameController.clear();
    }

    void generateEmail() async {
      // Check
      if (emailController.text.isNotEmpty &&
          nameController.text.isNotEmpty &&
          addressController.text.isNotEmpty) {
        setLoading(true);
        final date = DateTime.now();
        final dueDate = date.add(const Duration(days: 7));
        final invoice = Invoice(
          supplier: const Supplier(
            name: asStoreName,
            address: 'Portharcourt, Rivers State',
            paymentInfo: 'https://paypal.me/e-store',
          ),
          customer: Customer(
            name: nameController.text,
            address: addressController.text,
            email: emailController.text,
          ),
          info: InvoiceInfo(
              date: date,
              dueDate: dueDate,
              description: 'My description',
              number: '${DateTime.now().year}-9999'),
          items: [
            InvoiceItem(
                description: 'Coffee',
                date: DateTime.now(),
                quantity: 3,
                vat: 0.19,
                unitPrice: 5.99),
            InvoiceItem(
                description: 'Water',
                date: DateTime.now(),
                quantity: 8,
                vat: 0.19,
                unitPrice: 0.99),
            InvoiceItem(
                description: 'Orange',
                date: DateTime.now(),
                quantity: 50,
                vat: 0.19,
                unitPrice: 1.29),
          ],
        );

        // Generate bill as pdf
        final pdfFile = await PdfInvoiceApi.generate(invoice);

        // Send email to recipient
        sendEmail(pdfFile);
      } else {
        showSnackBar(asFieldError, true);
      }
      // Stop loading indicator
      setLoading(false);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(asStoreName),
        backgroundColor: Colors.cyan,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.shopping_cart,
                          size: 64,
                          color: Colors.amber,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          asStoreName,
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.cyan),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    textBox(controller: nameController, hint: asCustomerName),
                    const SizedBox(height: 30),
                    textBox(
                        controller: emailController,
                        hint: asCustomerEmail,
                        keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 30),
                    textBox(
                        controller: addressController,
                        hint: asCustomerAddress,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.streetAddress),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          textStyle: const TextStyle(fontSize: 24),
                          primary: Colors.amber,
                        ),
                        onPressed: generateEmail,
                        child: const Text(asSendEmail),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

Widget textBox(
    {required TextEditingController controller,
    required String hint,
    TextInputAction? textInputAction,
    TextInputType? keyboardType}) {
  return SizedBox(
    height: 60,
    child: TextField(
      controller: controller,
      textInputAction: textInputAction ?? TextInputAction.next,
      keyboardType: keyboardType ?? TextInputType.name,
      decoration: InputDecoration(
        hintText: hint,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.cyan, width: 2),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.cyan, width: 4),
        ),
        border: const OutlineInputBorder(),
      ),
    ),
  );
}
