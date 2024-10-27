import 'package:quickmart/models/address.dart';
import 'package:quickmart/models/contact.dart';

class Company {
  final String id;
  final String companyName;
  final Address address;
  final ContactDetails contactDetails;

  Company({
    required this.id,
    required this.companyName,
    required this.address,
    required this.contactDetails,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      companyName: json['companyName'],
      address: Address.fromJson(json['address']),
      contactDetails: ContactDetails.fromJson(json['contactDetails']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyName': companyName,
      'address': address.toJson(),
      'contactDetails': contactDetails.toJson(),
    };
  }
}
