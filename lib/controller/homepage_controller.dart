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
            .where((medicine) => medicine.productName
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
    notifyListeners();
  }
}
