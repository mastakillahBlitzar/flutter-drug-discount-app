import 'package:drug_discount_app/constants.dart';
import 'package:drug_discount_app/model/medicine.dart';
import 'package:flutter/material.dart';

class OrderSummary extends StatelessWidget {
  const OrderSummary({
    Key? key,
    required this.order,
  }) : super(key: key);

  final List<Medicine> order;

  @override
  Widget build(BuildContext context) {
    int orderSubTotal = order.map<int>((m) => m.price).reduce((a, b) => a + b);
    int orderTotal = orderSubTotal + 5;
    return Column(
      children: [
        const Divider(
          thickness: 2,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "SUBTOTAL",
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                "\$$orderSubTotal",
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "DELIVERY FEE",
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                "\$5",
                style: Theme.of(context).textTheme.headline6,
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                  color: Colors.black.withAlpha(50),
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
            ),
            Container(
              margin: const EdgeInsets.all(5),
              height: 50,
              width: MediaQuery.of(context).size.width - 10,
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "TOTAL",
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(color: Colors.white),
                    ),
                    Text(
                      "\$$orderTotal",
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
