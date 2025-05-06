import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductForm extends StatefulWidget {
  final Product? product;
  final Function(Product) onSave;

  const ProductForm({Key? key, this.product, required this.onSave})
    : super(key: key);

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _priceController.text = widget.product!.price.toString();
      _stockController.text = widget.product!.stock.toString();
      _descController.text = widget.product!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.product == null ? 'Tambah Produk' : 'Edit Produk',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              _buildTextField(_nameController, 'Nama Produk'),
              _buildTextField(
                _priceController,
                'Harga',
                keyboardType: TextInputType.number,
              ),
              _buildTextField(
                _stockController,
                'Stok',
                keyboardType: TextInputType.number,
              ),
              _buildTextField(_descController, 'Deskripsi', maxLines: 2),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _onSave,
                  child: Text(widget.product == null ? 'Simpan' : 'Update'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
    int? maxLines,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
    );
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final newProduct = Product(
        id: widget.product?.id ?? '',
        name: _nameController.text.trim(),
        price: int.parse(_priceController.text),
        stock: int.parse(_stockController.text),
        description: _descController.text.trim(),
      );
      widget.onSave(newProduct);
    }
  }
}
