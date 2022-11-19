import 'dart:io';

import 'package:equitysoft/firestore_servies/firestore_services.dart';
import 'package:equitysoft/response/company_response.dart';
import 'package:equitysoft/response/product_response.dart';
import 'package:equitysoft/state/company_state.dart';
import 'package:equitysoft/state/product_state.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class ProductBloc {
  ProductBloc._();

  static final ProductBloc instance = ProductBloc._();
  final _service = FirebaseService();
  final companyList = BehaviorSubject<CompanyState>();
  final categoryList = BehaviorSubject<CompanyState>();
  final productsList = BehaviorSubject<ProductState>();
  final pickedImage = BehaviorSubject<List<XFile>>.seeded([]);
  final isLoading = BehaviorSubject<bool>.seeded(false);
  final companyName = BehaviorSubject<String>();
  final categoryName = BehaviorSubject<String>();
  final selectedCompany = BehaviorSubject<CompanyRes>();
  final selectedCategory = BehaviorSubject<CompanyRes>();
  final productName = BehaviorSubject<String>();
  final productDesc = BehaviorSubject<String>();
  final price = BehaviorSubject<String>();
  final qty = BehaviorSubject<String>();
  final List<XFile> files = [];
  final isValidImage = BehaviorSubject<bool>.seeded(false);
  final currentIndex = BehaviorSubject<int>.seeded(0);

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
    final image = await fetchImages();
    final uuid = Uuid();
    final product = ProductResponse(
      name: productName.valueOrNull,
      category: categoryName.valueOrNull,
      company: companyName.valueOrNull,
      dec: productDesc.valueOrNull,
      id: uuid.v1(),
      price: price.valueOrNull,
      img: image,
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
    final image = await fetchImages();
    final uuid = Uuid();
    var product = ProductResponse(
      name: productName.valueOrNull,
      category: selectedCategory.valueOrNull?.category,
      company: selectedCompany.valueOrNull?.company,
      dec: productDesc.valueOrNull,
      id: uuid.v1(),
      price: price.valueOrNull,
      img: image,
      qty: qty.valueOrNull,
    );
    return await _service.updateProduct(product, id).then((value) {
      isLoading.add(false);
      return true;
    });
  }

  pickImage() async {
    final imagePicket = ImagePicker();
    final pickedFile = await imagePicket.pickMultiImage();
    if (pickedFile.isNotEmpty) {
      for (var p in pickedFile) {
        files.add(p);
        pickedImage.add(files);
      }
      if (pickedImage.valueOrNull!.length >= 2) {
        isValidImage.add(false);
      }
    } else {
      print("+++++++++++ERROR PICKED IMAGE");
    }
  }

  Future<List<Img>> fetchImages() async {
    final uuid = Uuid().v1();

    final storage = FirebaseStorage.instance;
    List<Img> files = [];

    for (var i in pickedImage.value) {
      Reference ref = storage.ref().child(uuid);

      await ref.child("images${DateTime.now()}").putFile(File(i.path));
    }

    final result = await storage.ref().child(uuid).list();
    final List<Reference> allFiles = result.items;
    print(allFiles.length);

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      files.add(Img(url: fileUrl));
      print('result is $fileUrl');
    });

    return files;
  }
}
