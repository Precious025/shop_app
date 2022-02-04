import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = 'product-detail';

  const ProductDetailScreen({Key? key}) : super(key: key);
  // final String id;
  // final String title;

  // ProductDetailScreen(this.id, this.title);

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedData =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedData.title!),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedData.title!),
              background: Hero(
                tag: loadedData.id as Object,
                child: Image.network(
                  loadedData.imageUrl!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            const SizedBox(height: 10),
            Text(
              '\$${loadedData.price}',
              style: const TextStyle(
                color: Colors.orangeAccent,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              width: double.infinity,
              child: Text(
                loadedData.description!,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            const SizedBox(
              height: 800,
            )
          ]))
        ],
      ),
    );
  }
}
