import 'package:restful/global.dart';

import '../app.dart';

class BaseApi extends Api {
  @override
  Map<String, kApiMethod> get allows => {
        'category': category,
        'product': product,
        'feedback': feedback,
        'order': order,
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
    ];
    await Dao.connect();
    await Dao.category.drop();
    cates.forEach((element) {
      Dao.category.insert(Map.from(element));
    });

    var outputs = [];

    ///==============for home
    if (postKeyVal('home')) outputs = cates.sublist(0, 12);
    if (postKeyVal('all')) outputs = cates;
    return Api.success(outputs);
  }

  Future<dynamic> product() async {
    var cates = <Map>[
      {
        'category': 1,
        'pic': 'assets/images/apple.jpg',
        'name': 'Apple',
        'price': '10',
        'items': [
          {'name': '1Box Case30', 'price': '30'},
          {'name': '2Box Case50', 'price': '50'},
        ],
        'id': 1,
      },
      {
        'category': 1,
        'pic': 'assets/images/lemons.jpg',
        'name': 'Lemons',
        'price': '10',
        'items': [
          {'name': '1Box Case', 'price': '30'},
          {'name': '2Box Case', 'price': '50'},
        ],
        'id': 2,
      },
      {
        'category': 2,
        'pic': 'assets/images/nonveg.jpg',
        'name': 'Meat',
        'price': '10',
        'id': 3,
      },
      {
        'category': 1,
        'pic': 'assets/images/kiwi.jpg',
        'name': 'KiwiFruit',
        'price': '10',
        'id': 4,
      },
      {
        'category': 1,
        'pic': 'assets/images/guava.jpg',
        'name': 'Guava',
        'price': '10',
        'id': 5,
      },
      {
        'category': 1,
        'pic': 'assets/images/grapes.jpg',
        'name': 'Grapes',
        'price': '10',
        'id': 6,
      },
      {
        'category': 1,
        'pic': 'assets/images/pineapple.jpg',
        'name': 'Pineapple',
        'price': '10',
        'id': 7,
      },
      {
        'category': 12,
        'pic': 'assets/images/dove-poder.jpg',
        'name': 'Dove-powder (1.6oz)',
        'price': '4.32',
        'id': 8,
      },
      {
        'category': 12,
        'pic': 'assets/images/degree-powder.jpg',
        'name': 'Degree Adrenaline Extreme (2.7oz)',
        'price': '8.61',
        'id': 9,
      },
      {
        'category': 12,
        'pic': 'assets/images/suave.jpg',
        'name': 'Suave Conditioner Strawberry (15oz)',
        'price': '3.50',
        'id': 10,
      },
      {
        'category': 12,
        'pic': 'assets/images/suave-green.jpg',
        'name': 'Suave Conditioner Green Apple (15oz)',
        'price': '3.88',
        'id': 11,
      },
      {
        'category': 11,
        'pic': 'assets/images/lactogen-3.jpg',
        'name': 'Gentle Grown 3 (350g)',
        'price': '6.25',
        'id': 12,
      },
      {
        'category': 11,
        'pic': 'assets/images/banana-sitter.jpg',
        'name': 'G Banana Orange Medley (2pk)',
        'price': '1.97',
        'id': 13,
      },
      {
        'category': 11,
        'pic': 'assets/images/good-care.jpg',
        'name': 'Nestle 3 (2pk)',
        'price': '23.05',
        'id': 14,
      },
      {
        'category': 10,
        'pic': 'assets/images/dove-baby.jpg',
        'name': 'Dove Baby Lotion (200ml)',
        'price': '9.97',
        'id': 15,
      },
      {
        'category': 10,
        'pic': 'assets/images/pull-ups.jpg',
        'name': 'Huggies Pul-Ups 3T-4T (22ct)',
        'price': '14.97',
        'id': 16,
      },
      {
        'category': 10,
        'pic': 'assets/images/pull-ups-blue.jpg',
        'name': 'Huggies Pul-Ups 2T-3T (25ct)',
        'price': '14.97',
        'id': 17,
      },
      {
        'category': 10,
        'pic': 'assets/images/ammens.jpg',
        'name': 'Ammens Baby Powder (250g)',
        'price': '10.49',
        'id': 18,
      },
    ];
    await Dao.connect();
    await Dao.product.drop();
    cates.forEach((element) {
      Dao.product.insert(Map.from(element));
    });

    var outputs = [];
    if (postKey('id')) {
      cates.forEach((element) {
        if (element['category'] == post['id']) {
          outputs.add(element);
        }
      });
    }

    ///==============for home
    if (postKeyVal('home')) {
      outputs = cates.sublist(0);
    }

    return Api.success(outputs);
  }

  Future<dynamic> order() async {
    if(isGet){
      await Dao.connect();
      var list=await Dao.order.find();
      var outs=<Map>[];
      await list.forEach((element) {
        element.remove('request');
        element.remove('_id');
        outs.add(element);
      });
      return Api.success(outs);
    }
    if (isPost&&postKey('user') && postKey('address') && postKey('orders')) {
      await Dao.connect();
      post['request'] = requestInfo;
      post['id'] = timeymd().replaceAll('-', '') + (await Dao.order.count()).toString();
      post['time'] = timestampStr();
      post['payment'] = 'COD';
      post['status'] = 'Your Order has been Placed!!!';
      post['deliver'] = 'To Deliver On : ${randomListElement(['today', 'yesterday', '3 hours', '24 minute'])}';

      await Dao.order.insert(post);
      var res=Map.from(post);
      res.remove('request');
      res.remove('_id');
      return Api.success(res);
    }
    return Api.error('data error');
  }

  Future<dynamic> feedback() async {
    if (post != null) {
      await Dao.connect();
      post['request'] = requestInfo;
      await Dao.feedback.insert(post);
      return Api.success('Thanks for your feeds!');
    }
    return Api.error('data error');
  }
}
