import 'package:drug_discount_app/logic/bloc/cart_bloc.dart';
import 'package:drug_discount_app/model/medicine.dart';
import 'package:drug_discount_app/presentation/screens/cart/components/order_summary.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

class CartView extends StatelessWidget {
  const CartView({
    Key? key,
    required this.medicineAdded,
  }) : super(key: key);

  final List<Medicine> medicineAdded;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: Row(
            children: const [
              Text(
                "Items in your cart",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: medicineAdded.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                  title: Text(
                      toBeginningOfSentenceCase(medicineAdded[index].name) ??
                          "Uknown Name"),
                  trailing: IconButton(
                      onPressed: () {
                        context
                            .read<CartBloc>()
                            .add(RemoveItem(medicine: medicineAdded[index]));
                      },
                      icon: const Icon(Icons.cancel))),
            );
          },
        ),
        OrderSummary(
          order: medicineAdded,
        ),
      ],
    );
  }
}
