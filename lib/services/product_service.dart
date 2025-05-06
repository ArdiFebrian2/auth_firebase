import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  final CollectionReference _productRef = FirebaseFirestore.instance.collection(
    'products',
  );

  Future<void> addProduct(Product product) async {
    await _productRef.add(product.toMap());
  }

  Stream<List<Product>> getProducts() {
    return _productRef.orderBy('createdAt', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        return Product.fromDocument(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> updateProduct(String id, Product product) async {
    await _productRef.doc(id).update(product.toMap());
  }

  Future<void> deleteProduct(String id) async {
    await _productRef.doc(id).delete();
  }
}
