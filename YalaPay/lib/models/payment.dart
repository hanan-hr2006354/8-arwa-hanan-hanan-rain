class Payment {
  final String id;
  final String invoiceNo;
  final String amount;
  final String paymentDate;
  String paymentMode;
  final String chequeNo;

  Payment(
      {required this.id,
      required this.invoiceNo,
      required this.amount,
      required this.paymentDate,
      required this.paymentMode,
      required this.chequeNo});

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
        id: json['id'],
        invoiceNo: json['invoiceNo'],
        amount: json['amount'],
        paymentDate: json['paymentDate'],
        paymentMode: json['paymentMode'],
        chequeNo: json['chequeNo']);
  }

  ///fix payment date

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      ' invoiceNo': invoiceNo,
      'paymentDate': paymentDate,
      'paymentMode': paymentMode,
      'chequeNo': chequeNo,
    };
  }
}
