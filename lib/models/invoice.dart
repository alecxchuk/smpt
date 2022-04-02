import 'package:smpt/models/customer.dart';
import 'package:smpt/models/invoice_info.dart';
import 'package:smpt/models/invoice_item.dart';
import 'package:smpt/models/supplier.dart';

class Invoice {
  final InvoiceInfo info;
  final Supplier supplier;
  final Customer customer;
  final List<InvoiceItem> items;

  const Invoice({
    required this.info,
    required this.supplier,
    required this.customer,
    required this.items,
  });
}
