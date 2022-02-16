import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:plant_app/model/medicine.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartLoaded()) {
    on<AddItem>(_onAddItem);
    on<RemoveItem>(_onRemoveItem);
  }

  void _onAddItem(AddItem event, Emitter<CartState> emit) {
    final state = this.state;
    if (state is CartLoaded) {
      emit(
        CartLoaded(
          medicineAdded: List.from(state.medicineAdded)..add(event.medicine),
        ),
      );
    }
  }

  void _onRemoveItem(RemoveItem event, Emitter<CartState> emit) {
    final state = this.state;
    if (state is CartLoaded) {
      List<Medicine> medicineAdded = state.medicineAdded.where(
        (element) {
          return element.name != event.medicine.name;
        },
      ).toList();
      emit(
        CartLoaded(medicineAdded: medicineAdded),
      );
    }
  }

  List<Medicine>? get initialState => <Medicine>[];
}
