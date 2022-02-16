import 'package:flutter/material.dart';
import 'package:drug_discount_app/constants.dart';

class FeaturedPlants extends StatelessWidget {
  const FeaturedPlants({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          FeaturedPlantsCard(
            image: "assets/images/ensure.png",
            press: () {},
          ),
          FeaturedPlantsCard(
            image: "assets/images/ensure.png",
            press: () {},
          ),
          FeaturedPlantsCard(
            image: "assets/images/ensure.png",
            press: () {},
          ),
        ],
      ),
    );
  }
}

class FeaturedPlantsCard extends StatelessWidget {
  const FeaturedPlantsCard({
    Key? key,
    required this.image,
    required this.press,
  }) : super(key: key);

  final String image;
  final Function press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        press;
      },
      child: Container(
        margin: const EdgeInsets.only(
          left: kDefaultPadding,
          top: kDefaultPadding / 2,
          bottom: kDefaultPadding / 2,
        ),
        width: size.width * .8,
        height: 185,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(image),
          ),
        ),
      ),
    );
  }
}
