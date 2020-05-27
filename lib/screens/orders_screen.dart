import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  // bool _isLoading = false;

  // @override
  // void initState() {
  //   //  Future.delayed(Duration.zero).then((_) async {

  //   _isLoading = true;
  //   Provider.of<Orders>(context, listen: false).fetchAndSetOrder().then((_) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(title: Text('Your Orders')),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future:
                Provider.of<Orders>(context, listen: false).fetchAndSetOrder(),
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (dataSnapshot.error != null) {
                  return Center(
                    child: Text('An error ocurred!'),
                  );
                } else {
                  return Consumer<Orders>(
                      builder: (cx, orderData, child) => Container(
                            child: orderData.orders.length != 0
                                ? ListView.builder(
                                    itemCount: orderData.orders.length,
                                    itemBuilder: (cx, i) =>
                                        OrderItem(orderData.orders[i]),
                                  )
                                : Container(
                                    height: double.infinity,
                                    child: Center(
                                      child: Text('No Orders placed :)'),
                                    ),
                                  ),
                          ));
                }
              }
            }));
  }
}
