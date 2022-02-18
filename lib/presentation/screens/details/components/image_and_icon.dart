import 'package:drug_discount_app/model/medicine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:drug_discount_app/constants.dart';
import 'package:drug_discount_app/presentation/screens/details/components/icon_card.dart';

class ImageAndIcon extends StatelessWidget {
  const ImageAndIcon({
    Key? key,
    required this.size,
    required this.medicine,
  }) : super(key: key);

  final Size size;
  final Medicine medicine;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: kDefaultPadding * 3),
      child: SizedBox(
        height: size.height * .7,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: kDefaultPadding * 3),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon:
                              SvgPicture.asset("assets/icons/back_arrow.svg")),
                    ),
                    const Spacer(),
                    const Tooltip(
                      child: IconCard(icon: "assets/icons/sun.svg"),
                      message: "testin my tooltip",
                    ),
                    const IconCard(icon: "assets/icons/icon_2.svg"),
                    const IconCard(icon: "assets/icons/icon_3.svg"),
                    const IconCard(icon: "assets/icons/icon_4.svg"),
                  ],
                ),
              ),
            ),
            Container(
              height: size.height * .8,
              width: size.width * .75,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(63),
                    bottomLeft: Radius.circular(63),
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 10),
                      blurRadius: 60,
                      color: kPrimaryColor.withOpacity(0.29),
                    )
                  ],
                  image: DecorationImage(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.cover,
                      image: AssetImage(medicine.image))),
            ),
          ],
        ),
      ),
    );
  }
}
