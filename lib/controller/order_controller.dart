import 'package:flutter/material.dart';
import 'package:hospital_invoice/firebase/firestore_helper.dart';
import 'package:hospital_invoice/model/medicine_model.dart';

class OrderController extends ChangeNotifier {
  List<MedicineModel> selectedMedicines = [];

  get filteredMedicine => null;

  void addMedicine(MedicineModel medicine) {
    selectedMedicines.add(medicine);
    notifyListeners();
  }

  void removeMedicine(MedicineModel medicine) {
    selectedMedicines.remove(medicine);
    notifyListeners();
  }

  void toggleAddtoCart(MedicineModel medicineModel) {
    if (selectedMedicines.contains(medicineModel)) {
      removeMedicine(medicineModel);
    } else {
      addMedicine(medicineModel);
    }
  }

  void addQuantity(int index) {
    selectedMedicines[index].requiredQuantity <
            selectedMedicines[index].quantity
        ? selectedMedicines[index].requiredQuantity++
        : null;
    notifyListeners();
  }

  void removeQuantity(int index) {
    selectedMedicines[index].requiredQuantity > 0
        ? selectedMedicines[index].requiredQuantity--
        : null;
    notifyListeners();
  }

  void placeOrder(BuildContext context) {
    FirestoreService().updateQuantity(selectedMedicines, context);
    selectedMedicines = [];
  }
}
