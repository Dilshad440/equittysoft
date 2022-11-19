import 'dart:io';

import 'package:equitysoft/firestore_servies/firestore_services.dart';
import 'package:equitysoft/response/company_response.dart';
import 'package:equitysoft/response/product_response.dart';
import 'package:equitysoft/state/company_state.dart';
import 'package:equitysoft/state/product_state.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:uuid/uuid.dart';

class ProductBloc {
  ProductBloc._();

  static final ProductBloc instance = ProductBloc._();
  final _service = FirebaseService();
  final companyName = BehaviorSubject<String>();
  final companyList = BehaviorSubject<CompanyState>();
  final selectedCompany = BehaviorSubject<CompanyRes>();
  final categoryName = BehaviorSubject<String>();
  final categoryList = BehaviorSubject<CompanyState>();
  final selectedCategory = BehaviorSubject<CompanyRes>();
  final productName = BehaviorSubject<String>();
  final productDesc = BehaviorSubject<String>();
  final price = BehaviorSubject<String>();
  final qty = BehaviorSubject<String>();
  final productsList = BehaviorSubject<ProductState>();
  final pickedImage = BehaviorSubject<List<XFile>>();
  final isLoading = BehaviorSubject<bool>.seeded(false);
  final List<XFile> files = [];

  Future<void> addCompanies() async {
    return await _service.addCompanies(companyName.valueOrNull!);
  }

  void getCompanies() {
    companyList.add(CompanyState.loading());
    _service
        .getCompanies()
        .map((data) => CompanyState.completed(data))
        .onErrorReturnWith((error, stackTrace) => CompanyState.error(error))
        .startWith(CompanyState.loading())
        .listen((state) {
      companyList.add(state);
    });
  }

  void deleteCompany(String id) async {
    return await _service.deleteCompanies(id);
  }

  Future<void> addCategory() async {
    return await _service.addCategory(categoryName.valueOrNull!);
  }

  void getCategories() {
    categoryList.add(CompanyState.loading());
    _service
        .getCategory()
        .map((data) => CompanyState.completed(data))
        .onErrorReturnWith((error, stackTrace) => CompanyState.error(error))
        .startWith(CompanyState.loading())
        .listen((state) {
      categoryList.add(state);
    });
  }

  void deleteCategory(String id) async {
    return await _service.deleteCategory(id);
  }

  Future<bool> addProduct() async {
    isLoading.add(true);
    final image = await getImage();
    final uuid = Uuid();
    final product = ProductResponse(
      name: productName.valueOrNull,
      category: selectedCategory.valueOrNull?.category,
      company: selectedCompany.valueOrNull?.company,
      dec: productDesc.valueOrNull,
      id: uuid.v1(),
      price: price.valueOrNull,
      img: [Img(url: image)],
      qty: qty.valueOrNull,
    );
    return _service.addProducts(product).then(
      (value) {
        isLoading.add(false);
        return true;
      },
    );
  }

  void getProducts() {
    productsList.add(ProductState.loading());
    _service
        .getProducts()
        .map((data) => ProductState.completed(data))
        .onErrorReturnWith((error, stackTrace) => ProductState.error(error))
        .startWith(ProductState.loading())
        .listen((state) {
      productsList.add(state);
    });
  }

  Future<bool> deleteProduct(String id) async {
    return await _service.deleteProduct(id).then((value) => true);
  }

  Future<bool> updateProduct(String id) async {
    isLoading.add(true);
    final image = await getImage();
    final uuid = Uuid();
    var product = ProductResponse(
      name: productName.valueOrNull,
      category: selectedCategory.valueOrNull?.category,
      company: selectedCompany.valueOrNull?.company,
      dec: productDesc.valueOrNull,
      id: uuid.v1(),
      price: price.valueOrNull,
      img: [Img(url: image)],
      qty: qty.valueOrNull,
    );
    return await _service.updateProduct(product, id).then((value) => true);
  }

  pickImage() async {
    final imagePicket = ImagePicker();
    final pickedFile = await imagePicket.pickMultiImage();
    if (pickedFile.isNotEmpty) {
      for (var p in pickedFile) {
        files.add(p);
        pickedImage.add(files);
      }
    } else {
      print("+++++++++++ERROR PICKED IMAGE");
    }
  }

  Future<String?> getImage() async {
    String? imageUrl;
    final storage = FirebaseStorage.instance;
    try {
      Reference ref = storage.ref().child("images${DateTime.now()}");
      for (var i in pickedImage.value) {
        await ref.putFile(File(i.path));
      }
      imageUrl = await ref.getDownloadURL();
      print(imageUrl);
    } catch (e) {
      isLoading.add(false);
    }
    return imageUrl;
  }
}
