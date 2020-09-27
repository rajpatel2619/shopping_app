import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/helpers/custom_route.dart';
import 'package:shopping_app/providers/auth.dart';
import 'package:shopping_app/providers/cart.dart';
import 'package:shopping_app/providers/orders.dart';
import 'package:shopping_app/providers/products.dart';
import 'package:shopping_app/screens/auth_screen.dart';
import 'package:shopping_app/screens/cart_screen.dart';
import 'package:shopping_app/screens/edit_product_screen.dart';
import 'package:shopping_app/screens/orders_screen.dart';
import 'package:shopping_app/screens/product_detail_screen.dart';
import 'package:shopping_app/screens/products_overview_screen.dart';
import 'package:shopping_app/screens/splash_screen.dart';
import 'package:shopping_app/screens/user_products_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (ctx) => Products('','', []),
            update: (ctx, auth, previousProducts) => Products(auth.token,auth.userId,
                previousProducts == null ? [] : previousProducts.items),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
           ChangeNotifierProxyProvider<Auth, Orders>(
            create: (ctx) => Orders('','', []),
            update: (ctx, auth, previousOrders) => Orders(auth.token,auth.userId,
                previousOrders == null ? [] : previousOrders.orders),
           )
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'Shopping app',
            theme: ThemeData(
                primarySwatch: Colors.purple,
                 pageTransitionsTheme: PageTransitionsTheme(
                  builders: {
                    TargetPlatform.android: CustomPageTransitionBuilder(),
                    // TargetPlatform.iOS
                  },
                ),
                 accentColor: Colors.deepOrange),
            // home: ProductsOverviewScreen(),
            home: 
            auth.isAuth 
            ? ProductsOverviewScreen() 
            : FutureBuilder(
              future: auth.tryAutoLogin(),
              builder:(ctx,authResultSnapshot)=> 
              authResultSnapshot.connectionState == ConnectionState.waiting ? SplashScreen() :  AuthScreen() ) ,
            routes: {
              ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              AuthScreen.routeName: (ctx) => AuthScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            },
          ),
        ));
  }
}
