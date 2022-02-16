import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_app/constants.dart';
import 'package:plant_app/logic/bloc/cart_bloc.dart';
import 'package:plant_app/model/medicine.dart';
import 'package:plant_app/presentation/screens/details/components/image_and_icon.dart';
import 'package:plant_app/presentation/screens/details/components/title_and_price.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

class Body extends StatelessWidget {
  const Body({Key? key, required this.medicine}) : super(key: key);

  final Medicine medicine;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          ImageAndIcon(size: size),
          TitleAndPrice(
            title: toBeginningOfSentenceCase(medicine.name) ?? "Name Error",
            country: medicine.laboratory,
            price: 440,
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: TextButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                ),
                onPressed: () =>
                    {context.read<CartBloc>().add(AddItem(medicine: medicine))},
                child: const Text(
                  "Add To Cart",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),

              /*    SizedBox(
                width: size.width / 2,
                height: 84,
                child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20)))),
                  onPressed: () => {
                    context.read<CartBloc>().add(AddItem(medicine: medicine))
                  },
                  child: const Text(
                    "Add To Cart",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Description"),
                ),
              ), */
            ],
          ),
          const SizedBox(
            height: kDefaultPadding * 2,
          )
        ],
      ),
    );
  }
}
