import 'package:flutter/material.dart';
import 'package:plant_app/constants.dart';
import 'package:plant_app/presentation/screens/home/components/featured_plants.dart';
import 'package:plant_app/presentation/screens/home/components/header_with_search_box.dart';
import 'package:plant_app/presentation/screens/home/components/recomended_plants.dart';
import 'package:plant_app/presentation/screens/home/components/title_with_button.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          HeaderWithSearchBox(size: size),
          TitleWithButton(
            title: "Recomended",
            press: () {},
          ),
          RecomendedPlants(),
          TitleWithButton(title: "Featured Plants", press: () {}),
          const FeaturedPlants(),
          const SizedBox(height: kDefaultPadding),
        ],
      ),
    );
  }
}
