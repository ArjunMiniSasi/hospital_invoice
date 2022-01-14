import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hospital_invoice/controller/homepage_controller.dart';
import 'package:hospital_invoice/controller/order_controller.dart';
import 'package:provider/provider.dart';

import 'screen/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomepageController>(
          create: (_) => HomepageController(),
        ),
        ChangeNotifierProvider<OrderController>(
          create: (_) => OrderController(),
        ),
      ],
      child: const MaterialApp(
        title: 'Material App',
        home: Homepage(),
      ),
    );
  }
}
