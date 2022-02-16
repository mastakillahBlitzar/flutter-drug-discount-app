part of 'cart_bloc.dart';

enum EventType { add, delete }

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddItem extends CartEvent {
  final Medicine medicine;

  const AddItem({required this.medicine});
  @override
  List<Object?> get props => [medicine];
}

class RemoveItem extends CartEvent {
  final Medicine medicine;

  const RemoveItem({required this.medicine});
  @override
  List<Object?> get props => [medicine];
}
