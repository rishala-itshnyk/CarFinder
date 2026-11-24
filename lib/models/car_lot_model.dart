enum LotStatus { active, sold }

class CarLotModel {
  final int id;
  String title;
  int price;
  bool isFavorite;
  LotStatus status;

  CarLotModel({
    required this.id,
    required this.title,
    required this.price,
    this.isFavorite = false,
    this.status = LotStatus.active,
  });
}
