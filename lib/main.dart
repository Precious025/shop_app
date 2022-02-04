import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import './providers/order.dart';
import './screens/cart_screen.dart';
import '../providers/cart.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import 'package:provider/provider.dart';
import './providers/products.dart';
import './screens/order_screen.dart';
import './screens/userscreen.dart';
import './screens/auth_screen.dart';
import './providers/auth.dart';
import './helpers/custom_route.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate? cert, String? host, int? port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(),
          update: (ctx, auth, previousProducts) =>
              previousProducts!..update(auth.token, auth.userId),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders(),
          update: (ctx, auth, ordersData) =>
              ordersData!..update(auth.token, auth.userId),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'My Shop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            colorScheme: const ColorScheme.light(
              secondaryVariant: Colors.amberAccent,
            ),
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
                }
            ),
          ),
          home: auth.isAuth
              ? const ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
            CartScreen.routeName: (ctx) => const CartScreen(),
            OrderScreen.routeName: (ctx) => const OrderScreen(),
            UserProductsScreen.routeName: (ctx) => const UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => const EditProductScreen(),
          },
        ),
      ),
    );
  }
}
