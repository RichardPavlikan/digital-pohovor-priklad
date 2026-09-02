import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/presentation/login_cubit.dart';
import 'features/auth/presentation/login_page.dart';
import 'injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const SalaryApp());
}

class SalaryApp extends StatelessWidget {
  const SalaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salary overview',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.blueGrey, useMaterial3: true),
      home: BlocProvider(
        create: (_) => getIt<LoginCubit>(),
        child: const LoginPage(),
      ),
    );
  }
}
