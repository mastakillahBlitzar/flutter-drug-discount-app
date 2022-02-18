import 'package:bloc_test/bloc_test.dart';
import 'package:drug_discount_app/logic/bloc/cart_bloc.dart';
import 'package:drug_discount_app/model/medicine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('cartBloc', () {
    late CartBloc cartBloc;

    setUp(() {
      cartBloc = CartBloc();
    });

    tearDown(() {
      cartBloc.close();
    });

    test("initial state is cart loaded", () {
      expect(cartBloc.state, const CartLoaded());
    });

    blocTest<CartBloc, CartState>(
      'the bloc should add one item to the cart',
      build: () => cartBloc,
      act: (bloc) => bloc.add(
        const AddItem(
          medicine: Medicine("name", "description", "laboratory", "image", 200),
        ),
      ),
      expect: () => [
        const CartLoaded(
          medicineAdded: [
            Medicine("name", "description", "laboratory", "image", 200)
          ],
        )
      ],
    );
  });
}
