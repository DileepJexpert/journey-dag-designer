/// App shell: dark theme in the Designer's palette, identity gate, runs list.
/// READ-ONLY BY CONSTRUCTION: no screen in this app has a mutation affordance,
/// and the [OpsApi] port has no mutating method to call.
library;

import 'package:flutter/material.dart';

import '../features/identity/identity_gate.dart';
import '../features/runs/runs_screen.dart';

class OpsApp extends StatelessWidget {
  const OpsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journey Ops View',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4C7DFF),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF12151A),
        cardColor: const Color(0xFF1B2027),
        useMaterial3: true,
      ),
      home: const IdentityGate(child: RunsScreen()),
    );
  }
}
