import 'package:flutter/material.dart';
import 'package:recycle_this/src/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (RouteSettings routeSettings) =>
          generateRoutes(routeSettings),
      initialRoute: '/',
    );
  }
}
