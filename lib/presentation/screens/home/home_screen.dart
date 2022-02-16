import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:drug_discount_app/presentation/components/bottom_tabs_bar.dart';
import 'package:drug_discount_app/presentation/screens/home/components/body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: const Body(),
      bottomNavigationBar: const BottomTabsBar(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset("assets/icons/menu.svg"),
        onPressed: () {},
      ),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed("/cart");
            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ))
      ],
    );
  }
}
