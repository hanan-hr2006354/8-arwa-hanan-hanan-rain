class Payment {
  final String id;
  final String invoiceNo;
  final double amount;
  final String paymentDate;
  final String paymentMode;
  final int? chequeNo; // Optional field

  Payment({
    required this.id,
    required this.invoiceNo,
    required this.amount,
    required this.paymentDate,
    required this.paymentMode,
    this.chequeNo, // Optional parameter
  });

  // Factory constructor to create a Payment instance from JSON
  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as String,
      invoiceNo: json['invoiceNo'] as String,
      amount: (json['amount'] as num).toDouble(), // Convert to double
      paymentDate: json['paymentDate'] as String,
      paymentMode: json['paymentMode'] as String,
      chequeNo: json['chequeNo'], // Use null-aware operator
    );
  }

  // Method to convert Payment instance to JSON
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
