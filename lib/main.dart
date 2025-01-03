import 'package:expensetx/features/home/data/i_mainfacade.dart';
import 'package:expensetx/features/presentation/view/homescreen.dart';
import 'package:expensetx/general/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/presentation/provider/state_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependancy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => StateProvider(expenseFacade: sl<IExpenseFacade>()),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
