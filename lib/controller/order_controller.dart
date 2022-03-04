import 'package:flutter/material.dart';
import 'package:hospital_invoice/firebase/firestore_helper.dart';
import 'package:hospital_invoice/model/medicine_model.dart';
import 'package:hospital_invoice/model/procedure_model.dart';

class OrderController extends ChangeNotifier {
  List<MedicineModel> selectedMedicines = [];
  List<ProcedureModel> selectedProcedures = [];

  get filteredMedicine => null;

  void addMedicine(MedicineModel medicine) {
    selectedMedicines.add(medicine);
    notifyListeners();
  }

  void addProcedure(ProcedureModel procedure) {
    selectedProcedures.add(procedure);
    notifyListeners();
  }

  void removeProcedure(ProcedureModel procedureModel) {
    selectedProcedures.remove(procedureModel);
    notifyListeners();
  }

  autoAddToCart(List<MedicineModel> filteredMedicine, List<String> names) {
    for (String item in names) {
      for (var medicine in filteredMedicine) {
        if (medicine.productName.toLowerCase() == item.toLowerCase()) {
          addMedicine(medicine);
        }
      }
    }
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
