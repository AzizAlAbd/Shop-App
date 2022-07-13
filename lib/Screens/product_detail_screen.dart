import 'package:ShopApp/providers/product.dart';
import 'package:flutter/material.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;
  static const routeName = '/ProductDetailScreen';
  // ProductDetailScreen(this.title,this.price);
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadproduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      //appBar: AppBar(
      //  title: Text(loadproduct.title),
      //),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () => Navigator.of(context).pop()),
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.black45,
                  child: Text(loadproduct.title)),
              centerTitle: true,
              background: Hero(
                tag: loadproduct.id,
                child: Image.network(
                  loadproduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(
              height: 5,
            ),
            Text(
              '\$${loadproduct.price}',
              style: TextStyle(color: Colors.black54, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Text(
                  loadproduct.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(fontSize: 17),
                )),
          ]))
        ],
      ),
    );
  }
}
