import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hospital_invoice/model/medicine_model.dart';
import 'package:hospital_invoice/screen/homepage.dart';

class FirestoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference inventory =
      FirebaseFirestore.instance.collection('inventory');

  //get all inventory documents
  getAllInventoryDocs() async {
    List<MedicineModel> allMedicine = [];
    await inventory.get().then(
      (QuerySnapshot snapshot) {
        for (var f in snapshot.docs) {
          // ignore: avoid_print
          Map medicine = f.data() as Map;
          allMedicine.add(
            MedicineModel(
              docId: f.id,
              productName: medicine['productName'],
              authorizedBy: medicine["authorizedBy"],
              code_value: medicine["code_value"],
              description: medicine["description"],
              expiryDate: medicine["expiryDate"],
              hospitalId: medicine["hospitalId"],
              listedTimeStamp: medicine["listedTimeStamp"],
              mobile: medicine["mobile"],
              productType: medicine["productType"],
              quantity: medicine["quantity"],
              status: medicine["status"],
              unitCost: medicine["unitCost"],
            ),
          );
        }
      },
    );
    return allMedicine;
  }

  void updateQuantity(
      List<MedicineModel> selectedMedicines, BuildContext context) {
    for (MedicineModel medicine in selectedMedicines) {
      inventory.doc(medicine.docId).update({
        'quantity': medicine.quantity - medicine.requiredQuantity,
      });
    }

    getAllInventoryDocs();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const Homepage(),
        ),
        (route) => false);
  }
}
