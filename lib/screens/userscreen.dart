import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import '../widgets/userproducts_item.dart';
import '../providers/products.dart';
import 'edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-product';

  Future<void> _refreshProducts(BuildContext context) async {
    return await Provider.of<Products?>(context, listen: false)!
        .fetchAndSetProducts(true);
  }

  const UserProductsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Product'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (ctx, productsData, _) => Row(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemBuilder: (_, i) => SafeArea(
                                child: Card(
                                  elevation: 5,
                                  child: UserProductsItem(
                                    id: productsData.items[i].id,
                                    title: productsData.items[i].title,
                                    imageUrl: productsData.items[i].imageUrl!,
                                  ),
                                ),
                              ),
                              itemCount: productsData.items.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
