import 'package:ShopApp/Widgets/app_drawer.dart';
import 'package:ShopApp/providers/order.dart' show Order;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Widgets/orderitem.dart';

class OrderScreen extends StatelessWidget {
  static final String routeName = "/OrderScreen";

  /*@override
  void initState() {
    /*  Future.delayed(Duration.zero).then((_) {
      Provider.of<Order>(context, listen: false).fetchAndSetOrders().then((_) {
        setState(() {
          _isloading = false;
        });
      }).catchError((e) {
        setState(() {
          _isloading = false;
          _iserror = true;
        });
      });
    });*/
    super.initState();
  }*/

  @override
  Widget build(BuildContext context) {
    //final ordersData = Provider.of<Order>(context);
    print('s');
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
      ),
      body: FutureBuilder(
        future: Provider.of<Order>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (dataSnapShot.error != null) {
            return Center(
              child: Text(
                "Something is wrong please try again...",
                style: TextStyle(fontSize: 18),
              ),
            );
          } else {
            return Consumer<Order>(
                builder: (ctx, ordersData, child) => ListView.builder(
                      itemBuilder: (ctx, i) {
                        return OrderItem(ordersData.orders[i]);
                      },
                      itemCount: ordersData.orders.length,
                    ));
          }
        },
      ),
      drawer: Appdrawer(),
    );
  }
}
