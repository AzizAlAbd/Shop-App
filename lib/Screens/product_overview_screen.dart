import 'package:ShopApp/Screens/cart_screen.dart';
import 'package:ShopApp/providers/cart.dart';
import 'package:ShopApp/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Widgets/product_grid.dart';
import '../Widgets/badge.dart';
import '../Widgets/app_drawer.dart';

enum FilterOption { All, Favorites }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavorites = false;
  var _isInit = true;
  var _isloading = true;
  @override
  void initState() {
    //Provider.of<Products>(context, listen: false).fetchAndSetProducts();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      Provider.of<Products>(context, listen: false)
          .fetchAndSetProducts()
          .then((value) => setState(() {
                _isloading = false;
              }));
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('MyShop'),
          actions: [
            PopupMenuButton(
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('Only favorites'),
                  value: FilterOption.Favorites,
                ),
                PopupMenuItem(
                  child: Text('Show all'),
                  value: FilterOption.All,
                ),
              ],
              onSelected: (FilterOption selectedvalue) {
                if (selectedvalue == FilterOption.Favorites) {
                  setState(() {
                    _showFavorites = true;
                  });
                }
                if (selectedvalue == FilterOption.All) {
                  setState(() {
                    _showFavorites = false;
                  });
                }
              },
              icon: Icon(Icons.more_vert),
            ),
            Consumer<Cart>(
              builder: (ctx, cart, ch) =>
                  Badge(child: ch, value: cart.itemCount.toString()),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            )
          ],
        ),
        body: _isloading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ProductGrid(_showFavorites),
        drawer: Appdrawer());
  }
}
