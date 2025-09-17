import 'package:blue_thermal_printer/blue_thermal_printer.dart';

/// Example usage of GP1324D receipt printing functionality
class GP1324DReceiptExample {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  /// Print a simple receipt using GP1324D printer
  Future<void> printReceipt() async {
    try {
      // Check if connected to GP1324D printer
      bool? isConnected = await bluetooth.isConnected;
      if (isConnected != true) {
        print("Please connect to GP1324D printer first");
        return;
      }

      // Receipt content
      String receiptContent = """
STORE NAME
123 Main Street
City, State 12345
Tel: (555) 123-4567

--------------------------------
RECEIPT #12345
Date: ${DateTime.now().toString().substring(0, 19)}
--------------------------------

Item 1                    \$10.99
Item 2                     \$5.50
Item 3                    \$15.25
--------------------------------
Subtotal:                 \$31.74
Tax:                       \$2.54
--------------------------------
TOTAL:                    \$34.28

Payment: Cash             \$40.00
Change:                    \$5.72

Thank you for your purchase!
Visit us again soon.
""";

      // Print with normal font size and left alignment
      await bluetooth.printReceiptGP1324D(
        receiptContent,
        fontSize: 1, // 0=small, 1=normal, 2=large
        align: 0,    // 0=left, 1=center, 2=right
      );

      print("Receipt printed successfully!");

    } catch (e) {
      print("Error printing receipt: $e");
    }
  }

  /// Print receipt header with large centered text
  Future<void> printReceiptHeader() async {
    try {
      String header = "*** RECEIPT ***";

      // Print header with large font, center aligned
      await bluetooth.printReceiptGP1324D(
        header,
        fontSize: 2, // Large font
        align: 1,    // Center aligned
      );

    } catch (e) {
      print("Error printing header: $e");
    }
  }

  /// Print receipt line item with left alignment
  Future<void> printLineItem(String item, String price) async {
    try {
      String line = "$item                    $price";

      // Print with normal font, left aligned
      await bluetooth.printReceiptGP1324D(
        line,
        fontSize: 1, // Normal font
        align: 0,    // Left aligned
      );

    } catch (e) {
      print("Error printing line item: $e");
    }
  }

  /// Print receipt total with emphasis
  Future<void> printTotal(String totalAmount) async {
    try {
      String total = "TOTAL: $totalAmount";

      // Print with large font for emphasis
      await bluetooth.printReceiptGP1324D(
        total,
        fontSize: 2, // Large font
        align: 2,    // Right aligned
      );

    } catch (e) {
      print("Error printing total: $e");
    }
  }

  /// Connect to GP1324D printer
  Future<void> connectToPrinter() async {
    try {
      // Get bonded devices
      List<BluetoothDevice> devices = await bluetooth.getBondedDevices();

      // Find GP1324D device
      BluetoothDevice? gp1324d = devices.firstWhere(
        (device) => device.name?.contains('GP1324D') == true ||
                    device.name?.contains('GP-1324D') == true ||
                    device.name?.contains('1324D') == true,
        orElse: () => throw Exception('GP1324D printer not found'),
      );

      // Connect to the printer
      await bluetooth.connect(gp1324d);
      print("Connected to GP1324D printer: ${gp1324d.name}");

    } catch (e) {
      print("Error connecting to printer: $e");
    }
  }

  /// Full receipt printing workflow
  Future<void> printCompleteReceipt() async {
    try {
      // Connect to printer
      await connectToPrinter();

      // Print receipt header
      await printReceiptHeader();

      // Print store info
      await bluetooth.printReceiptGP1324D(
        "STORE NAME\n123 Main Street\nCity, State 12345",
        fontSize: 1,
        align: 1, // Center
      );

      // Print separator
      await bluetooth.printReceiptGP1324D(
        "--------------------------------",
        fontSize: 0,
        align: 0,
      );

      // Print items
      await printLineItem("Coffee", "\$3.50");
      await printLineItem("Sandwich", "\$7.99");
      await printLineItem("Cookie", "\$2.25");

      // Print separator
      await bluetooth.printReceiptGP1324D(
        "--------------------------------",
        fontSize: 0,
        align: 0,
      );

      // Print total
      await printTotal("\$13.74");

      // Print footer
      await bluetooth.printReceiptGP1324D(
        "Thank you!",
        fontSize: 1,
        align: 1, // Center
      );

      print("Complete receipt printed successfully!");

    } catch (e) {
      print("Error in complete receipt workflow: $e");
    }
  }
}

/// Usage example
void main() async {
  GP1324DReceiptExample example = GP1324DReceiptExample();

  // Print a complete receipt
  await example.printCompleteReceipt();

  // Or print individual components
  // await example.connectToPrinter();
  // await example.printReceipt();
}