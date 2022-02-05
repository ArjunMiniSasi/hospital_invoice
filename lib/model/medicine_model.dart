import 'package:cloud_firestore/cloud_firestore.dart';

class MedicineModel {
  String authorizedBy;
  String code_value;
  String description;
  String expiryDate;
  String manufacturer;
  String hospitalId;
  String productName;
  Timestamp listedTimeStamp;
  String mobile;
  String productType;
  int quantity;
  String status;
  String unitCost;
  String docId;
  int requiredQuantity = 0;

  MedicineModel(
      {required this.authorizedBy,
      required this.code_value,
      required this.docId,
      required this.description,
      required this.expiryDate,
      required this.hospitalId,
      required this.listedTimeStamp,
      required this.manufacturer,
      required this.mobile,
      required this.productType,
      required this.quantity,
      required this.status,
      required this.unitCost,
      required this.productName});
}
