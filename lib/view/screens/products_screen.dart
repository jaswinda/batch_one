import 'dart:convert';
import 'package:batch_one/models/product.dart';
import 'package:batch_one/services/authentication.dart';
import 'package:batch_one/services/products_services.dart';
import 'package:batch_one/view/components/product_tile.dart';
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
  List<Product> list = [];
  @override
  void initState() {
    super.initState();
    fetchAllProducts();
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
          print(list);
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
          child: CircularButton(
            icon: const Icon(Icons.place),
            onPressed: () {},
          ),
        ),
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
                            ProductTile(
                                productName: prduct.name,
                                productImage: prduct.image,
                                productDesp: prduct.despcription,
                                productPrice: prduct.price),
                            Positioned(
                                right: 20,
                                top: 10,
                                child: CircleAvatar(
                                    child: IconButton(
                                        onPressed: () {
                                          // double price = double.parse(prduct.price);
                                          // setState(() {
                                          //   order_qnty = 1;
                                          //   order_total = price * order_qnty;
                                          // });
                                          // _modalBottomSheetMenu(prduct);
                                        },
                                        icon: const Icon(Icons.shopping_cart))))
                          ],
                        ))
                    .toList()),
          );
  }
}
