import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/cart_view_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartViewModel>();

    if (cart.cartItems.isEmpty) return const Center(child: Text('Panier vide'));

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: cart.cartItems.length,
            itemBuilder: (context, index) {
              final article = cart.cartItems[index];
              return ListTile(
                leading: article.image.isNotEmpty
                    ? Image.network(article.image,
                        width: 50, height: 50, fit: BoxFit.cover)
                    : const Icon(Icons.image, size: 50),
                title: Text(article.title),
                subtitle: Text('${article.price} €'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () =>
                      context.read<CartViewModel>().removeFromCart(article),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Total : ${cart.totalPrice.toStringAsFixed(2)} €',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  context.read<CartViewModel>().checkout();
                },
                child: const Text('Valider'),
              )
            ],
          ),
        )
      ],
    );
  }
}
