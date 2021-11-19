import 'package:localstorage/localstorage.dart';

class CartService {
  final LocalStorage storage = new LocalStorage('items');
  addToCart(Map<dynamic, dynamic> items) {
    storage.setItem("items", items);
  }

  Future<Map<String, dynamic>> getCartItems() async {
    print("before ready: " + storage.getItem("items").toString());

    //wait until ready
    await storage.ready;

    //this will now print 0
    print("after ready: " + storage.getItem("items").toString());
    return storage.getItem("items") ?? {};
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
