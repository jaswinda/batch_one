import 'package:batch_one/models/product.dart';
import 'package:batch_one/services/cart_service.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Map<dynamic, dynamic> cart = {};
  int order_qnty = 1;
  double order_total = 0;
  double total = 0;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  fetchCartItems() async {
    cart = await CartService().getCartItems();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    total = 0;
    return Scaffold(
        appBar: AppBar(
          title: Text('Cart'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Column(
                children: cart.keys.map((key) {
                  total +=
                      (double.parse(cart[key]['orderQuantity'].toString()) *
                          double.parse(cart[key]['price'].toString()));

                  return ListTile(
                    title: Text(cart[key]['name']),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Price ' + cart[key]['price'].toString()),
                        Text(
                            'Quantity' + cart[key]['orderQuantity'].toString()),
                        Text('Total' +
                            (double.parse(
                                        cart[key]['orderQuantity'].toString()) *
                                    double.parse(cart[key]['price'].toString()))
                                .toString()),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {},
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              height: 100,
              child: Row(
                children: [
                  const Expanded(
                    child: Text('Total'),
                  ),
                  Expanded(
                    child: Text(total.toString()),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              child: const Text('Checkout'),
              onPressed: () {},
            ),
          ],
        ));
  }

  _modalBottomSheetMenu(Product product) {
    double price = double.parse(product.price);
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (builder) {
          // to change the data
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 350.0,
              color:
                  Colors.transparent, //could change this to Color(0xFF737373),
              //so you don't have to change MaterialApp canvasColor
              child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
                          child: Text(
                            product.name.toString().toUpperCase(),
                            style: const TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(product.image),
                              ),
                            ),
                            Text(product.price),
                            const Text(' X '),
                            Text(order_qnty.toString()),
                            const Text(' = '),
                            Text(
                              order_total.toString(),
                              style: const TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Container(
                          color: Colors.grey[200],
                          height: 50,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (order_qnty != 1) {
                                      setState(() {
                                        order_qnty -= 1;
                                        order_total = price * order_qnty;
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.remove),
                                ),
                                Text(
                                  order_qnty.toString(),
                                  style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      order_qnty += 1;
                                      order_total = price * order_qnty;
                                    });
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  addProductToCart(product);
                                  Navigator.pop(context);
                                },
                                child: const Text('Add To Card')),
                          ],
                        )
                      ],
                    ),
                  )),
            );
          });
        });
  }

  addProductToCart(product) {
    setState(() {
      cart[product.id] = {
        'productId': product.id,
        'image': product.image,
        'price': product.price,
        'despcription': product.despcription,
        'name': product.name,
        'orderQuantity': order_qnty
      };
      CartService().addToCart(cart);
    });
  }
}
