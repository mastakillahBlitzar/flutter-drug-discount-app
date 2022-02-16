part of 'cart_bloc.dart';

@immutable
abstract class CartState extends Equatable {
  const CartState();
}

class CartLoading extends CartState {
  @override
  List<Object?> get props => [];
}

class CartLoaded extends CartState {
  final List<Medicine> medicineAdded;

  const CartLoaded({this.medicineAdded = const <Medicine>[]});

  @override
  List<Object?> get props => [medicineAdded];
}
