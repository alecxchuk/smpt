import 'package:flutter/material.dart';
import 'package:smpt/models/customer.dart';
import 'package:smpt/models/invoice.dart';
import 'package:smpt/models/invoice_info.dart';
import 'package:smpt/models/invoice_item.dart';
import 'package:smpt/models/supplier.dart';
import 'package:smpt/services/pdf_api.dart';
import 'package:smpt/services/pdf_invoice_api.dart';
import 'package:smpt/views/send_email.dart';

class BillGenerator extends StatelessWidget {
  const BillGenerator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.picture_as_pdf,
              size: 128,
            ),
            const SizedBox(height: 20),
            const Text(
              'Generate Invoice',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              width: MediaQuery.of(context).size.width,
              height: 48,
              child: RawMaterialButton(
                fillColor: Colors.amber,
                splashColor: Colors.amberAccent,
                onPressed: () async {
                  final date = DateTime.now();
                  final dueDate = date.add(const Duration(days: 7));
                  final invoice = Invoice(
                    supplier: const Supplier(
                      name: 'E-store',
                      address: 'Portharcourt, Rivers State',
                      paymentInfo: 'https://paypal.me/e-store',
                    ),
                    customer: const Customer(
                      name: 'Apple Ince',
                      address: 'Apple Street, Cupertino, CA 95014',
                      email: 'apple@apple.com',
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

                  final pdfFile = await PdfInvoiceApi.generate(invoice);

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: ((context) => SendEmail(
                          // pdfFile: pdfFile,
                          )),
                    ),
                  );
                  // PdfApi.openFile(pdfFile);
                },
                child: const Text('Invoice Pdf'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
