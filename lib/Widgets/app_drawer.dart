import 'package:ShopApp/Screens/order_screen.dart';
import 'package:ShopApp/Screens/user_product_screen.dart';
import 'package:ShopApp/helper/custom_route.dart';
import 'package:ShopApp/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Appdrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
          color: Colors.purple[50],
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(60),
            topRight: Radius.circular(60),
          )),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 15),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(150),
                )),
            height: 200,
            width: double.infinity,
            child: Text(
              "My Shop",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ListTile(
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
            leading: Icon(
              Icons.shop,
              size: 35,
            ),
            title: Text(
              'Shop',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Divider(),
          ListTile(
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(OrderScreen.routeName),
            leading: Icon(
              Icons.payment,
              size: 35,
            ),
            title: Text(
              'Orders',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Divider(),
          ListTile(
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(UserProductScreen.routeName),
            leading: Icon(
              Icons.edit,
              size: 35,
            ),
            title: Text(
              'Manage Products',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logOut();
            },
            leading: Icon(
              Icons.exit_to_app,
              size: 35,
            ),
            title: Text(
              'Logout',
              style: TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}
