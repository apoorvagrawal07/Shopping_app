import 'package:flutter/material.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import 'package:provider/provider.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import './cart_screen.dart';

enum FilterOptions {
  Favorites,
  All,
}
bool _isinit = true;
bool _isLoading = false;

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showOnlyFavorites = false;

  // @override
  // void initState() {
  //   // Provider.of<Products>(context).fetchProducts(); Wont Work
  //   Future.delayed(Duration.zero)
  //       .then((value) => Provider.of<Products>(context).fetchProducts());
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    if (_isinit) {
      _isLoading = true;
      Provider.of<Products>(context).fetchProducts().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MyShop'), actions: <Widget>[
        Consumer<Cart>(
          builder: (_, cart, ch) =>
              Badge(child: ch, value: cart.itemCount.toString()),
          child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              }),
        ),
        PopupMenuButton(
          onSelected: (FilterOptions selectedOption) {
            setState(() {
              if (selectedOption == FilterOptions.Favorites) {
                _showOnlyFavorites = true;
              } else {
                _showOnlyFavorites = false;
              }
            });
          },
          itemBuilder: (_) => [
            PopupMenuItem(
                child: Text('Only Favorites'), value: FilterOptions.Favorites),
            PopupMenuItem(child: Text('Show All'), value: FilterOptions.All),
          ],
          icon: Icon(Icons.more_vert),
        ),
      ]),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorites),
    );
  }
}
