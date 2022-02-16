import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_app/logic/bloc/cart_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return const CircularProgressIndicator();
            }
            if (state is CartLoaded && state.medicineAdded.isNotEmpty) {
              return Column(
                children: [
                  SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Text(
                          "Items in your cart",
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              ?.copyWith(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.medicineAdded.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: ListTile(
                              title: Text(state.medicineAdded[index].name),
                              trailing: IconButton(
                                  onPressed: () {
                                    context.read<CartBloc>().add(RemoveItem(
                                        medicine: state.medicineAdded[index]));
                                  },
                                  icon: const Icon(Icons.cancel))),
                        );
                      }),
                ],
              );
            }
            return const Text("No Items on Cart");
          },
        ),
      ),
    );
  }
}
