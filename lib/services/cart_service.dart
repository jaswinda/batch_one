import 'package:localstorage/localstorage.dart';

class CartService {
  final LocalStorage storage = new LocalStorage('cart');
  addToCart(Map<dynamic, dynamic> items) {
    print(items);
    storage.setItem("cart", items);
  }

  Future<Map<String, dynamic>> getCartItems() async {
    print("before ready: " + storage.getItem("cart").toString());

    //wait until ready
    await storage.ready;

    //this will now print 0
    print("after ready: " + storage.getItem("cart").toString());
    return storage.getItem("cart") ?? {};
  }

  clearCart() {
    storage.clear();
  }

  // order(data) async {
  //   try {
  //     final response = await http.post(Uri.parse(orderApi),
  //         headers: {
  //           "Accept": "application/json",
  //           "Content-Type": "application/x-www-form-urlencoded"
  //         },
  //         body: data,
  //         encoding: Encoding.getByName("utf-8"));
  //     return response;
  //   } catch (e) {
  //     return null;
  //   }
  // }
}
