import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drug_discount_app/constants.dart';
import 'package:drug_discount_app/logic/bloc/cart_bloc.dart';
import 'package:drug_discount_app/model/medicine.dart';
import 'package:drug_discount_app/presentation/screens/details/components/image_and_icon.dart';
import 'package:drug_discount_app/presentation/screens/details/components/title_and_price.dart';
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
          ImageAndIcon(
            size: size,
            medicine: medicine,
          ),
          TitleAndPrice(
            title: toBeginningOfSentenceCase(medicine.name) ?? "Name Error",
            country: medicine.laboratory,
            price: medicine.price,
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: kPrimaryColor,
                minimumSize: const Size.fromHeight(50),
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
          ),
          const SizedBox(
            height: kDefaultPadding * 2,
          )
        ],
      ),
    );
  }
}
