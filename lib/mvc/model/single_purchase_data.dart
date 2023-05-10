// To parse this JSON data, do
//
//     final singlePurchaseData = singlePurchaseDataFromJson(jsonString);

import 'dart:convert';

SinglePurchaseData singlePurchaseDataFromJson(String str) => SinglePurchaseData.fromJson(json.decode(str));

String singlePurchaseDataToJson(SinglePurchaseData data) => json.encode(data.toJson());

class SinglePurchaseData {
  SinglePurchaseData({
     this.data,
  });

  Data? data;

  factory SinglePurchaseData.fromJson(Map<String, dynamic> json) => SinglePurchaseData(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    required this.id,
    required this.supplierId,
    this.bankId,
    required this.referenceNo,
    required this.totalAmount,
    required this.shippingCharge,
    required this.discountAmount,
    required this.paidAmount,
    required this.status,
    required this.date,
    required this.paymentType,
    this.details,
    required this.supplier,
    required this.bank,
  });

  int id;
  int supplierId;
  dynamic bankId;
  String referenceNo;
  String totalAmount;
  String shippingCharge;
  String discountAmount;
  String paidAmount;
  int status;
  DateTime date;
  String paymentType;
  dynamic details;
  Bank supplier;
  Bank bank;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    supplierId: json["supplier_id"],
    bankId: json["bank_id"],
    referenceNo: json["reference_no"],
    totalAmount: json["total_amount"],
    shippingCharge: json["shipping_charge"],
    discountAmount: json["discount_amount"],
    paidAmount: json["paid_amount"],
    status: json["status"],
    date: DateTime.parse(json["date"]),
    paymentType: json["payment_type"],
    details: json["details"],
    supplier: Bank.fromJson(json["supplier"]),
    bank: Bank.fromJson(json["bank"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "supplier_id": supplierId,
    "bank_id": bankId,
    "reference_no": referenceNo,
    "total_amount": totalAmount,
    "shipping_charge": shippingCharge,
    "discount_amount": discountAmount,
    "paid_amount": paidAmount,
    "status": status,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "payment_type": paymentType,
    "details": details,
    "supplier": supplier.toJson(),
    "bank": bank.toJson(),
  };
}

class Bank {
  Bank({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
