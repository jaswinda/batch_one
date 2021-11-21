import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:batch_one/models/product.dart';
import 'package:batch_one/services/authentication.dart';
import 'package:batch_one/services/cart_service.dart';
import 'package:batch_one/services/products_services.dart';
import 'package:batch_one/view/screens/cart_screen.dart';
import 'package:batch_one/view/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool isLoading = true;
  Map cart = {};
  int order_qnty = 1;
  double order_total = 0;
  List<Product> list = [];
  @override
  void initState() {
    super.initState();
    fetchAllProducts();
    fetchCartItems();
  }

  fetchCartItems() async {
    cart = await CartService().getCartItems();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // content(),
          buildFloatingSearchBar(context),
        ],
      ),
    );
  }

  Future<List<Product>> fetchAllProducts() async {
    setState(() {
      isLoading = true;
    });

    String token = await Authentication().getUserToken();
    Map data = {
      'token': token,
    };
    try {
      final response = await ProductService().getProducts(data);
      if (response.statusCode == 200 && response != null) {
        Map<String, dynamic> _body = jsonDecode(response.body);
        if (_body['success']) {
          List jsonResponse = _body["data"];
          list = jsonResponse.map((data) => Product.fromJson(data)).toList();
          // setState(() {});
          print('list ' + list.toString());
        } else {
          String message = _body['message'];
          if (message == "UnAuthenticated") {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return const Login();
            }));
          }
        }
        myScakbar(_body["message"]);
      }
    } catch (e) {
      myScakbar("Something went wrong.");
    }
    setState(() {
      isLoading = false;
    });

    return list;
  }

  myScakbar(message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget buildFloatingSearchBar(context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: 'Search...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        // Call your model, bloc, controller here.
      },
      body: content(),
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
            showIfOpened: false,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(),
                  ),
                );
              },
              child: Badge(
                badgeContent: Text(cart.length.toString(),
                    style: const TextStyle(color: Colors.white)),
                child: Icon(
                  Icons.shopping_bag,
                ),
              ),
            )),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: Colors.accents.map((color) {
                return Container(height: 112, color: color);
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget content() {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: GridView.count(
                crossAxisCount: 2,
                children: list
                    .map((prduct) => Stack(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Card(
                                color: Colors.blue[50],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Image.network(
                                                prduct.image,
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        prduct.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(prduct.despcription,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: const TextStyle(fontSize: 12)),
                                      Text(prduct.price.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                ),
                                elevation: 10,
                                shadowColor: Colors.blue,
                                margin: const EdgeInsets.all(10),
                              ),
                            ),
                            Positioned(
                                right: 20,
                                top: 10,
                                child: CircleAvatar(
                                    child: IconButton(
                                        onPressed: () {
                                          // cart[prduct.id] = prduct;
                                          // CartService().addToCart(cart);
                                          // setState(() {});
                                          _modalBottomSheetMenu(prduct);
                                        },
                                        icon: const Icon(Icons.shopping_cart))))
                          ],
                        ))
                    .toList()),
          );
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
