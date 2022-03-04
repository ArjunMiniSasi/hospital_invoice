import 'package:flutter/material.dart';
import 'package:hospital_invoice/controller/homepage_controller.dart';
import 'package:hospital_invoice/controller/order_controller.dart';
import 'package:hospital_invoice/firebase/firestore_helper.dart';
import 'package:hospital_invoice/gen/assets.gen.dart';
import 'package:hospital_invoice/model/medicine_model.dart';
import 'package:hospital_invoice/screen/cofirm_order_page.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({
    Key? key,
  }) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late HomepageController _controller;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _controller = Provider.of<HomepageController>(context, listen: false);
    _controller.getAllMedicine();
    FirestoreService().getAllProcedure();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Vams invoice'),
        ),
        body: Consumer<HomepageController>(
          builder: (context, myType, child) {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _searchController,
                    onChanged: (value) =>
                        myType.filterMedicine(_searchController.text),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: "Search Medicines",
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                myType.isLoading
                    ? const CircularProgressIndicator.adaptive()
                    : MedicineList(
                        myType: myType,
                      ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConfirmOrderPage(),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text("View order",
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

class MedicineList extends StatefulWidget {
  final HomepageController myType;

  const MedicineList({
    Key? key,
    required this.myType,
  }) : super(key: key);

  @override
  State<MedicineList> createState() => _MedicineListState();
}

class _MedicineListState extends State<MedicineList> {
  late OrderController _orderController;
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _orderController = Provider.of<OrderController>(context, listen: false);
      _orderController.autoAddToCart(widget.myType.filteredMedicine, [
        "metacam",
        "pet vita d"
      ]); //use this function to send the default medicine name
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderController>(
      builder: (context, orderController, child) {
        return Expanded(
          child: ListView.builder(
            itemCount: widget.myType.filteredMedicine.length,
            itemBuilder: (BuildContext context, int index) {
              MedicineModel medicineModel =
                  widget.myType.filteredMedicine[index];
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
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  medicineModel.productName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Text(medicineModel.description),
                                ),
                                Row(
                                  children: <Widget>[
                                    const Text("Product type: "),
                                    Text(medicineModel.productType,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    const Text("Unit price: "),
                                    Text(
                                        "Rs " +
                                            medicineModel.unitCost.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Text("Quantity: "),
                                    Text(medicineModel.quantity.toString(),
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
                      widget.myType.filteredMedicine[index].quantity == 0
                          ? Assets.openBox.image(height: 30)
                          : InkWell(
                              onTap: () {
                                orderController.toggleAddtoCart(medicineModel);
                              },
                              child: !orderController.selectedMedicines
                                      .contains(medicineModel)
                                  ? Assets.addProduct.image(height: 30)
                                  : Assets.remove.image(height: 30),
                            ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
