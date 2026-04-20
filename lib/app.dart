import 'package:flutter/material.dart';
import 'package:focus_flow_test/core/sdk/sdk_initializer.dart';
import 'package:focus_flow_test/screens/home_screen.dart';

class FocusFlowApp extends StatelessWidget {
  const FocusFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Focus Flow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const SdkInitializer(child: HomeScreen()),
    );
  }
}
