import 'package:equatable/equatable.dart';

class Medicine extends Equatable {
  final String name;
  final String description;
  final String laboratory;
  final String image;
  final int price;

  const Medicine(
      this.name, this.description, this.laboratory, this.image, this.price);

  @override
  List<Object?> get props => [name, description, laboratory];
}
