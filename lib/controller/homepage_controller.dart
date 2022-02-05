import 'package:flutter/material.dart';
import 'package:hospital_invoice/firebase/firestore_helper.dart';
import 'package:hospital_invoice/model/medicine_model.dart';

class HomepageController extends ChangeNotifier {
  bool isLoading = true;
  List<MedicineModel> allMedicine = [];
  List<MedicineModel> filteredMedicine = [];

  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  getAllMedicine() async {
    allMedicine = await FirestoreService().getAllInventoryDocs();
    filteredMedicine = allMedicine;
    stopLoading();
    notifyListeners();
  }

  filterMedicine(String query) {
    filteredMedicine = query == ""
        ? allMedicine
        : allMedicine
            .where((medicine) => checkSearchedText(query, medicine))
            .toList();
    notifyListeners();
  }

  checkSearchedText(String query, MedicineModel medicine) {
    if (medicine.description.toLowerCase().contains(query.toLowerCase()) ||
        medicine.productName.toLowerCase().contains(query.toLowerCase()) ||
        medicine.manufacturer.toLowerCase().contains(query.toLowerCase()) ||
        medicine.expiryDate
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase())) {
      return true;
    } else {
      return false;
    }
  }
}
