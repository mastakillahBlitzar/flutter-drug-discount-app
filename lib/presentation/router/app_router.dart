import 'package:flutter/material.dart';
import 'package:drug_discount_app/presentation/screens/cart/cart_screen.dart';
import 'package:drug_discount_app/presentation/screens/home/home_screen.dart';

class AppRouter {
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
}
