import 'package:flutter/material.dart';
import 'package:hospital_invoice/controller/order_controller.dart';
import 'package:hospital_invoice/controller/pdf_controller.dart';
import 'package:hospital_invoice/gen/assets.gen.dart';
import 'package:hospital_invoice/model/medicine_model.dart';
import 'package:provider/provider.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({Key? key}) : super(key: key);

  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
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
                child: ListView.builder(
                  itemCount: myType.selectedMedicines.length,
                  itemBuilder: (context, index) {
                    MedicineModel medicineModel =
                        myType.selectedMedicines[index];
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Assets.drugs.image(height: 30),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            medicineModel.productName,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            child:
                                                Text(medicineModel.description),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              const Text("Unit price: "),
                                              Text(
                                                  "Rs " +
                                                      medicineModel.unitCost
                                                          .toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              const Text("Quantity: "),
                                              Text(
                                                  medicineModel.requiredQuantity
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 3.0),
                                      child: Text("Rs "),
                                    ),
                                    Text(
                                      (int.parse(medicineModel.unitCost) *
                                              medicineModel.requiredQuantity)
                                          .toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
                            )}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25)),
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
