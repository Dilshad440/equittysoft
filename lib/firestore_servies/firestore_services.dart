import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equitysoft/response/company_response.dart';
import 'package:equitysoft/response/product_response.dart';
import 'package:uuid/uuid.dart';

class FirebaseService {
  final _service = FirebaseFirestore.instance;
  final uuid = Uuid();

  Future<void> addCompanies(String companyName) async {
    try {
      await _service.collection('companies').add({
        'id': uuid.v1(),
        'company': companyName,
      });
    } catch (e) {
      print(e);
    }
  }

  Stream<List<CompanyRes>> getCompanies() {
    return _service.collection('companies').snapshots().map((event) =>
        event.docs.map((e) => CompanyRes.fromJson(e.data(), false)).toList());
  }

  Future<void> deleteCompanies(String id) async {
    return await _service
        .collection('companies')
        .where('id', isEqualTo: id)
        .get()
        .then((value) {
      for (var c in value.docs) {
        c.reference.delete();
      }
    });
  }

  Future<void> addCategory(String categoryName) async {
    try {
      await _service.collection('categories').add({
        'id': uuid.v1(),
        'category': categoryName,
      });
    } catch (e) {
      print(e);
    }
  }

  Stream<List<CompanyRes>> getCategory() {
    return _service.collection('categories').snapshots().map(
          (event) => event.docs
              .map((e) => CompanyRes.fromJson(e.data(), true))
              .toList(),
        );
  }

  Future<void> deleteCategory(String id) async {
    return await _service
        .collection('categories')
        .where('id', isEqualTo: id)
        .get()
        .then(
      (value) {
        for (var c in value.docs) {
          c.reference.delete();
        }
      },
    );
  }

  Future<void> addProducts(ProductResponse product) async {
    try {
      await _service.collection('product').add(product.toJson());
    } catch (e) {
      print(e);
    }
  }

  Stream<List<ProductResponse>> getProducts() {
    return _service.collection('product').snapshots().map(
          (event) => event.docs
              .map((e) => ProductResponse.fromJson(e.data()))
              .toList(),
        );
  }

  Future<void> deleteProduct(String id) async {
    return await _service
        .collection('product')
        .where('id', isEqualTo: id)
        .get()
        .then(
      (value) {
        for (var c in value.docs) {
          c.reference.delete();
        }
      },
    );
  }

  Future<void> updateProduct(ProductResponse product, String id) async {
    try {
      await _service
          .collection('product')
          .where('id', isEqualTo: id)
          .get()
          .then((value) {
        for (var u in value.docs) {
          u.reference.update(product.toJson());
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
