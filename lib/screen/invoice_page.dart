import 'package:flutter/material.dart';
import 'package:hospital_invoice/constant/constant.dart';
import 'package:hospital_invoice/controller/order_controller.dart';
import 'package:hospital_invoice/controller/pdf_controller.dart';
import 'package:hospital_invoice/gen/assets.gen.dart';
import 'package:hospital_invoice/model/medicine_model.dart';
import 'package:hospital_invoice/model/procedure_model.dart';
import 'package:hospital_invoice/widget/medicine_tile.dart';
import 'package:hospital_invoice/widget/procedure_tile.dart';
import 'package:provider/provider.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({Key? key}) : super(key: key);

  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  final TextEditingController _priceController = TextEditingController();
  String value = "SURGERY";

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderController>(
      builder: (context, myType, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Invoice'),
            centerTitle: true,
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: myType.selectedMedicines.length,
                        itemBuilder: (context, index) {
                          MedicineModel medicineModel =
                              myType.selectedMedicines[index];
                          return medicineTile(medicineModel, context);
                        },
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: myType.selectedProcedures.length,
                        itemBuilder: (context, index) {
                          ProcedureModel procedureModel =
                              myType.selectedProcedures[index];
                          return procedureTile(procedureModel, context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    DropdownButton(
                      items: procedureList
                          .map(
                            (e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ),
                          )
                          .toList(),
                      value: value,
                      hint: const Text("Select Procedure"),
                      onChanged: (val) {
                        value = val as String;
                        setState(() {});
                      },
                    ),
                    SizedBox(
                      width: 100,
                      height: 30,
                      child: TextField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "Price",
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        myType.addProcedure(
                          ProcedureModel(
                            amount: double.parse(_priceController.text),
                            procedure: value,
                          ),
                        );
                        _priceController.clear();
                      },
                      child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 10,
                          child: Assets.plus.image()),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text("Total amount"),
                        Text(
                          "Rs ${myType.selectedMedicines.fold(
                                0,
                                (int previousValue, element) =>
                                    previousValue +
                                    int.parse(element.unitCost) *
                                        element.requiredQuantity,
                              ) + myType.selectedProcedures.fold(
                                0,
                                (previousValue, element) =>
                                    previousValue + element.amount,
                              )}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ],
                    )),
              ),
              Consumer<PdfController>(
                builder: (context, pdfController, child) {
                  return InkWell(
                    onTap: () {
                      // myType.placeOrder(context);
                      pdfController.createPDF(myType.selectedMedicines, [
                        "take fruits",
                        "Drink 2 liters of water",
                        "Eat 2 pieces of bread",
                      ]);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text("Confirm order",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }
}
