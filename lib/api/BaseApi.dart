import 'dart:math';

import '../app.dart';

class BaseApi extends Api {
  @override
  Map<String, kApiMethod> get allows => {
        'category': category,
      };

  Future<dynamic> category() async {
    var cates = <Map>[
      {'name': 'Fresh Produce', 'pic': 'assets/images/veg.jpg', 'type': 0, 'id': 1},
      {'name': 'Meat', 'pic': 'assets/images/nonveg.jpg', 'type': 0, 'id': 2},
      {'name': 'Canned Goods', 'pic': 'assets/images/canned.jpg', 'type': 0, 'id': 3},
      {'name': 'Sauces/Toppings', 'pic': 'assets/images/groceries.jpg', 'type': 0, 'id': 4},
      {'name': 'Spices', 'pic': 'assets/images/spices.jpg', 'type': 0, 'id': 5},
      {'name': 'Dairy/eggs', 'pic': 'assets/images/dairy-eggs.jpg', 'type': 0, 'id': 6},
      {'name': 'Breads/Cereals', 'pic': 'assets/images/breads-cereals.jpg', 'type': 0, 'id': 7},
      {'name': 'Rice/Grains', 'pic': 'assets/images/rice-grains.jpg', 'type': 0, 'id': 8},
      {'name': 'Ready Made', 'pic': 'assets/images/ready-made.jpg', 'type': 0, 'id': 9},
      {'name': 'Baby Care', 'pic': 'assets/images/baby-care.jpg', 'type': 0, 'id': 10},
      {'name': 'Baby Food', 'pic': 'assets/images/baby-food.jpg', 'type': 0, 'id': 11},
      {'name': 'Hygiene products', 'pic': 'assets/images/hygiene.jpg', 'type': 0, 'id': 12},
      {'name': 'Cleaning', 'pic': 'assets/images/cleaning.jpg', 'type': 0, 'id': 13},
      {'name': 'Household', 'pic': 'assets/images/home.jpg', 'type': 0, 'id': 14},
      {'name': 'Drinks', 'pic': 'assets/images/drinks.jpg', 'type': 0, 'id': 15},
      {'name': 'Snacks', 'pic': 'assets/images/snacks.jpg', 'type': 0, 'id': 16},
      {'name': 'Baking/Cooking', 'pic': 'assets/images/eggs.jpg', 'type': 0, 'id': 17},
      {'name': 'SkinCare/Beauty', 'pic': 'assets/images/be.jpg', 'type': 0, 'id': 18},
      {'name': 'Fresh Produce', 'pic': 'assets/images/groceries.jpg', 'type': 0, 'id': 19}
    ];

    await Dao.connect();
    await Dao.category.drop();
    cates.forEach((element) {
      Dao.category.insert(Map.from(element));
    });
    return Api.success(cates);
  }
}
