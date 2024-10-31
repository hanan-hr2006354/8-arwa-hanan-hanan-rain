class Payment {
  final String id;
  final String invoiceNo;
  final double amount; // Ensure amount is a double
  final String paymentDate;
  final String paymentMode;
  final int? chequeNo;

  Payment({
    required this.id,
    required this.invoiceNo,
    required this.amount,
    required this.paymentDate,
    required this.paymentMode,
    this.chequeNo,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      invoiceNo: json['invoiceNo'],
      amount: json['amount'] is double ? json['amount'] : double.parse(json['amount'].toString()), // Convert to double if necessary
      paymentDate: json['paymentDate'],
      paymentMode: json['paymentMode'],
      chequeNo: json['chequeNo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoiceNo': invoiceNo,
      'amount': amount,
      'paymentDate': paymentDate,
      'paymentMode': paymentMode,
      'chequeNo': chequeNo,
    };
  }
}
