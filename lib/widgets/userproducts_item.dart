import 'package:flutter/material.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class UserProductsItem extends StatelessWidget {
  final String? id;
  final String? title;
  final String imageUrl;

  const UserProductsItem(
      {Key? key, required this.id, required this.title, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    final mediaQ = MediaQuery.of(context).devicePixelRatio;
    // ignore: avoid_print
    print(mediaQ);
    return ListTile(
      title: Text(
        title!,
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          imageUrl,
        ),
      ),
      trailing: SizedBox(
        height: 200,
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              icon: const Icon(
                Icons.edit,
              ),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id!);
                } catch (error) {
                  scaffold.showSnackBar(
                    const SnackBar(
                      content: Text('Could not delete!'),
                    ),
                  );
                }
              },
              icon: const Icon(
                Icons.delete,
              ),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
