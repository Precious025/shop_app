import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import '../providers/order.dart' show Orders;
import '../widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/order';

  const OrderScreen({Key? key}) : super(key: key);

  // var _isLoading = false;
  // @override
  // void initState() {
  //   Future.delayed(Duration.zero).then((_) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders?>(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Yours Orders'),
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
            future:
                Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (dataSnapshot.error != null) {
                return const Center(
                  child: Text('An error ocurred!'),
                );
              } else {
                return Consumer<Orders?>(
                  builder: (ctx, orderData, child) => ListView.builder(
                    itemCount: orderData!.orders.length,
                    itemBuilder: (ctx, i) => OrderItem(
                      orderData.orders[i],
                    ),
                  ),
                );
              }
            }));
  }
}
