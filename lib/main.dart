import 'package:flutter/material.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/orders.dart';
import './screens/products_overview_screen.dart';
import './providers/products.dart';
import './screens/splash_screen.dart';
import './helpers/custom_route.dart';
import 'package:provider/provider.dart';
import './screens/product_detail_screen.dart';
import './providers/cart.dart';
import './screens/edit_product.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
              create: (ctx) => Products('Null', 'NULL', []),
              update: (ctx, auth, previousProducts) => Products(
                  auth.token,
                  auth.userId,
                  previousProducts.items == null
                      ? []
                      : previousProducts.items)),
          ChangeNotifierProvider(create: (c) => Cart()),
          ChangeNotifierProxyProvider<Auth, Orders>(
              create: (_) => Orders('NULL', 'null', []),
              update: (ct, auth, previousOrders) => Orders(
                  auth.token,
                  auth.userId,
                  previousOrders == null ? [] : previousOrders.orders))
        ],
        child: Consumer<Auth>(
            builder: (ctx, auth, _) => MaterialApp(
                title: 'MyShop',
                theme: ThemeData(
                  primarySwatch: Colors.purple,
                  accentColor: Colors.deepOrange,
                  fontFamily: 'Lato',
                  pageTransitionsTheme: PageTransitionsTheme(builders: {
                    TargetPlatform.android: CustomPageTransitionBuilder(),
                    TargetPlatform.iOS: CustomPageTransitionBuilder(),
                  }),
                ),
                routes: {
                  ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                  CartScreen.routeName: (cx) => CartScreen(),
                  OrdersScreen.routeName: (ctx) => OrdersScreen(),
                  UserProductsScreen.routeName: (cx) => UserProductsScreen(),
                  EditProduct.routeName: (ctx) => EditProduct(),
                  AuthScreen.routeName: (c) => AuthScreen(),
                },
                home: auth.isAuth
                    ? ProductOverviewScreen()
                    : FutureBuilder(
                        future: auth.tryAutoLogin(),
                        builder: (ctx, authResultSnapshot) =>
                            authResultSnapshot.connectionState ==
                                    ConnectionState.waiting
                                ? SplashScreen()
                                : AuthScreen(),
                      ))));
  }
}
