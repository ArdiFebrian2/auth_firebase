import 'package:auth_firebase/widgets/product_form.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ProductService _productService = ProductService();

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Hapus Produk'),
            content: const Text(
              'Apakah Anda yakin ingin menghapus produk ini?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  _productService.deleteProduct(id);
                  Navigator.pop(context);
                },
                child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manajemen Produk")),
      body: StreamBuilder<List<Product>>(
        stream: _productService.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Gagal memuat data'));
          } else if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!;
          if (products.isEmpty) {
            return const Center(child: Text('Belum ada produk'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemCount: products.length,
            itemBuilder: (_, i) {
              final p = products[i];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(p.name),
                  subtitle: Text('Rp${p.price} - Stok: ${p.stock}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showProductForm(product: p),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(p.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductForm(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showProductForm({Product? product}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => ProductForm(
            product: product,
            onSave: (newProduct) {
              if (product == null) {
                _productService.addProduct(newProduct);
              } else {
                _productService.updateProduct(product.id, newProduct);
              }
              Navigator.pop(context);
            },
          ),
    );
  }
}
