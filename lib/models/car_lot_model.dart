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

  factory CarLotModel.fromJson(Map<String, dynamic> jsonMap) {
    return CarLotModel(
      id: jsonMap['id'] as int,
      title: jsonMap['title'] as String,
      price: jsonMap['price'] as int,
      isFavorite: jsonMap['isFavorite'] as bool? ?? false,
      status: jsonMap['status'] == 'sold' ? LotStatus.sold : LotStatus.active,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'isFavorite': isFavorite,
      'status': status.name,
    };
  }
}
