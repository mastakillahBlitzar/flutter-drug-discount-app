import 'package:flutter/material.dart';
import 'package:plant_app/logic/cubit/cart_cubit.dart';
import 'package:plant_app/presentation/screens/cart/cart_screen.dart';
import 'package:plant_app/presentation/screens/home/home_screen.dart';

class AppRouter {
  final CartCubit _cartCubit = CartCubit();

  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      /* case '/details':
        return MaterialPageRoute(
          builder: (_) => const DetailsScreen(
          ),
        ); */
      case '/cart':
        return MaterialPageRoute(
          builder: (_) => const CartScreen(),
        );
      default:
        return null;
    }
  }

  void dispose() {
    _cartCubit.close();
  }
}
