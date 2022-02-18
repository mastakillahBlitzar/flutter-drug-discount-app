import 'package:drug_discount_app/logic/bloc/cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 150,
            width: 30,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed("/cart");
              },
              child: Stack(children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("/cart");
                  },
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                ),
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    if (state is CartLoaded) {
                      return Positioned(
                          child: Stack(
                        children: [
                          Icon(Icons.brightness_1,
                              size: 20, color: Colors.orange.shade500),
                          Positioned(
                              top: 4,
                              right: 5,
                              child: Center(
                                child: Text(
                                  state.medicineAdded.length.toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500),
                                ),
                              ))
                        ],
                      ));
                    } else {
                      return Container();
                    }
                  },
                )
              ]),
            ),
          ),
        )
      ],
    );
  }
}
