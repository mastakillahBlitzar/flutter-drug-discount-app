import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_app/constants.dart';
import 'package:plant_app/logic/bloc/cart_bloc.dart';
import 'package:plant_app/presentation/router/app_router.dart';

void main() {
  runApp(MyApp(
    appRouter: AppRouter(),
  ));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  const MyApp({Key? key, required this.appRouter}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartBloc>(
      create: (context) => CartBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'The Drug Discount app',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(backgroundColor: kPrimaryColor),
          scaffoldBackgroundColor: kBackgroundColor,
          primaryColor: kPrimaryColor,
          textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
        ),
        onGenerateRoute: appRouter.onGenerateRoute,
      ),
    );
  }
}
