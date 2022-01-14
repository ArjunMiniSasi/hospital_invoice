import 'package:flutter/material.dart';
import 'package:hospital_invoice/controller/order_controller.dart';
import 'package:hospital_invoice/gen/assets.gen.dart';
import 'package:hospital_invoice/model/medicine_model.dart';
import 'package:hospital_invoice/screen/invoice_page.dart';
import 'package:provider/provider.dart';

class ConfirmOrderPage extends StatefulWidget {
  const ConfirmOrderPage({Key? key}) : super(key: key);

  @override
  _ConfirmOrderPageState createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('View Order'),
          centerTitle: true,
        ),
        body: Consumer<OrderController>(
          builder: (context, myType, child) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: myType.selectedMedicines.length,
                    itemBuilder: (BuildContext context, int index) {
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                              child: Text(
                                                  medicineModel.description),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                const Text("Unit price: "),
                                                Text(
                                                    "Rs " +
                                                        medicineModel.unitCost
                                                            .toString(),
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                const Text("Quantity: "),
                                                Text(
                                                    medicineModel.quantity
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          myType.removeQuantity(index);
                                        },
                                        child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 10,
                                            child: Assets.minus.image()),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            "${medicineModel.requiredQuantity}"),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          myType.addQuantity(index);
                                        },
                                        child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 10,
                                            child: Assets.plus.image()),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const Divider(),
                              InkWell(
                                  onTap: () =>
                                      myType.toggleAddtoCart(medicineModel),
                                  child: const Text("Remove"))
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                InkWell(
                  onTap: () {
                    // myType.placeOrder(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InvoicePage(),
                      ),
                    );
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
                      child: Text("Generate Bill",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                    ),
                  ),
                )
              ],
            );
          },
        ));
  }
}
