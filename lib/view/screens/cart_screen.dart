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
    return Scaffold(
        appBar: AppBar(
          title: Text('Cart'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Column(
                children: cart.keys.map((key) {
                  return ListTile(
                    title: Text(cart[key]['name']),
                    subtitle: Text('\$${cart[key]['price']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        // CartService().removeItem(cart[key]['id']);
                        fetchCartItems();
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            Container(
              height: 100,
              child: Row(
                children: [
                  Expanded(
                    child: Text('Total'),
                  ),
                  Expanded(
                    child: Text('\$100'),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              child: Text('Checkout'),
              onPressed: () {},
            ),
          ],
        ));
  }
}
