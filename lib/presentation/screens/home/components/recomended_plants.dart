import 'package:flutter/material.dart';
import 'package:plant_app/constants.dart';
import 'package:plant_app/medicine_list.dart';
import 'package:plant_app/model/medicine.dart';
import 'package:plant_app/presentation/screens/details/details_screen.dart';

class RecomendedPlants extends StatelessWidget {
  RecomendedPlants({
    Key? key,
  }) : super(key: key);

  final List<Medicine> medicines = List.from(medicineList);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: 344,
      child: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        scrollDirection: Axis.horizontal,
        itemCount: medicines.length,
        itemBuilder: (context, index) {
          return RecomendPlantCard(
            image: medicines[index].image,
            title: medicines[index].name,
            country: medicines[index].laboratory,
            price: 440,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsScreen(
                    medicine: medicines[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class RecomendPlantCard extends StatelessWidget {
  const RecomendPlantCard({
    Key? key,
    required this.image,
    required this.title,
    required this.country,
    required this.price,
    required this.press,
  }) : super(key: key);

  final String image, title, country;
  final int price;
  final Function press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(
          left: kDefaultPadding,
          top: kDefaultPadding / 2,
          bottom: kDefaultPadding * 2.5),
      width: size.width * .4,
      child: Column(
        children: <Widget>[
          Image.asset(
            image,
            fit: BoxFit.cover,
            //color: Colors.white,
            height: 200,
          ),
          GestureDetector(
            onTap: () {
              press();
            },
            child: Container(
              padding: const EdgeInsets.all(kDefaultPadding / 2),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 10),
                      blurRadius: 50,
                      color: kPrimaryColor.withOpacity(0.23),
                    ),
                  ]),
              child: Row(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "$title\n".toUpperCase(),
                            style: Theme.of(context).textTheme.button),
                        TextSpan(
                          text: country.toUpperCase(),
                          style: TextStyle(
                            color: kPrimaryColor.withOpacity(.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '\$$price',
                    style: Theme.of(context)
                        .textTheme
                        .button
                        ?.copyWith(color: kPrimaryColor),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
