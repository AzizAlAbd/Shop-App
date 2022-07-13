import 'package:ShopApp/Screens/auth_screen.dart';
import 'package:ShopApp/Screens/edit_product_screen.dart';
import 'package:ShopApp/Screens/order_screen.dart';
import 'package:ShopApp/Screens/splash_screen.dart';
import 'package:ShopApp/Screens/user_product_screen.dart';
import 'package:ShopApp/helper/custom_route.dart';
import 'package:ShopApp/providers/auth.dart';
import 'package:ShopApp/providers/cart.dart';
import 'package:ShopApp/Screens/product_detail_screen.dart';
import 'package:ShopApp/Screens/product_overview_screen.dart';
import 'package:ShopApp/providers/order.dart';
import 'package:flutter/material.dart';
import './providers/products.dart';
import 'package:provider/provider.dart';
import './providers/cart.dart';
import './Screens/cart_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, auth, previousProduct) => Products(
                auth.getToken,
                auth.getUserId,
                previousProduct.items == null ? [] : previousProduct.items),
            create: (ctx) => Products(null, null, []),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Order>(
            update: (ctx, auth, previousOrder) => Order(
                auth.getToken,
                auth.getUserId,
                previousOrder.orders == null ? [] : previousOrder.orders),
            create: (ctx) => Order(null, null, []),
          )
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
                primarySwatch: Colors.deepPurple,
                accentColor: Colors.red,
                fontFamily: 'Lato',
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CustomePageTransitionBuilder(),
                  TargetPlatform.iOS: CustomePageTransitionBuilder()
                })),
            home: auth.isAuth
                ? ProductOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutologin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen()),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrderScreen.routeName: (ctx) => OrderScreen(),
              UserProductScreen.routeName: (ctx) => UserProductScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
              AuthScreen.routeName: (ctx) => AuthScreen(),
            },
          ),
        ));
  }
}
