import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drug_discount_app/logic/bloc/cart_bloc.dart';
import 'package:drug_discount_app/model/medicine.dart';
import 'package:drug_discount_app/presentation/screens/details/components/body.dart';

class DetailsScreen extends StatelessWidget {
  final Medicine medicine;

  const DetailsScreen({Key? key, required this.medicine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Added!"),
                duration: Duration(milliseconds: 700),
              ),
            );
          }
        },
        child: Body(
          medicine: medicine,
        ),
      ),
    );
  }
}
