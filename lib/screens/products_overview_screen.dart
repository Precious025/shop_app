import 'package:flutter/material.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import '/screens/cart_screen.dart';
import '../providers/cart.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import 'package:provider/provider.dart';

enum filterOption { favorites, all }

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showFavoriteOnly = false;
  var _isInit = true;
  var _isLoading = false;

  // @override
  // void initState() {
  //   // Future.delayed(Duration.zero).then((_) {
  //   //   Provider.of<Products>(context).fetchProduct();
  //   // });
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context)
          .fetchAndSetProducts()
          .then((_) => setState(() {
                _isLoading = false;
              }));
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
        actions: [
          PopupMenuButton(
              onSelected: (filterOption selectedValue) {
                setState(() {
                  if (selectedValue == filterOption.favorites) {
                    _showFavoriteOnly = true;
                  } else {
                    _showFavoriteOnly = false;
                  }
                });
              },
              itemBuilder: (_) => [
                    const PopupMenuItem(
                      child: Text('Only Favorites'),
                      value: filterOption.favorites,
                    ),
                    const PopupMenuItem(
                      child: Text('All Items'),
                      value: filterOption.all,
                    ),
                  ]),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              color: Theme.of(context).colorScheme.secondary,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
                icon: const Icon(
                  Icons.shopping_cart,
                ),
              ),
              value: cart.itemCount.toString(),
              // key: null,
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showFavoriteOnly),
    );
  }
}
