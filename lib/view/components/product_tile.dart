import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  final String productName;
  final String productImage;
  final String productDesp;
  final String productPrice;
  const ProductTile(
      {Key? key,
      required this.productName,
      required this.productImage,
      required this.productDesp,
      required this.productPrice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return designedListWidgetTwo(
        productName, productImage, productDesp, productPrice);
  }

  Widget designedListWidgetTwo(
      productNam, productImage, productDesp, productPrice) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Image.network(
                        productImage,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                productNam,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text(productDesp,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 12)),
              Text(productPrice.toString(),
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
    );
  }
}
