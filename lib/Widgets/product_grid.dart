import 'package:flutter/material.dart';
import '../providers/products.dart';
import './product_Item.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  final _showFavorites;
  ProductGrid(this._showFavorites);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        _showFavorites ? productsData.favoritesItems : productsData.items;

    return Scaffold(
        body: GridView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemBuilder: (ctx, i) {
              return ChangeNotifierProvider.value(
                //create: (ctx) => products[i],
                value: products[i],
                child: ProductItem(),
              );
            }));
  }
}
