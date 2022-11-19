import 'dart:io';

import 'package:equitysoft/bloc/product_bloc.dart';
import 'package:equitysoft/constant/app_colors..dart';
import 'package:equitysoft/response/company_response.dart';
import 'package:equitysoft/response/product_response.dart';
import 'package:equitysoft/utils/widget/app_input_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatelessWidget {
  AddProduct({Key? key, this.product}) : super(key: key);
  final ProductResponse? product;
  final _bloc = ProductBloc.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appTheme,
        title: Text(product != null ? "EditProduct" : "Add Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            AppInputField(
              initialValue: product?.name,
              hintText: "Product name",
              onChanged: (value) {
                _bloc.productName.add(value);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<CompanyRes>(
              stream: _bloc.selectedCategory,
              builder: (context, snapshot) {
                return Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.appTheme)),
                  height: 50,
                  child: DropdownButton<CompanyRes>(
                    value: _bloc.selectedCategory.valueOrNull,
                    underline: const SizedBox.shrink(),
                    isExpanded: true,
                    items: _bloc.categoryList.valueOrNull?.data
                        ?.map(
                          (e) => DropdownMenuItem<CompanyRes>(
                            value: e,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text(e.category!),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      _bloc.selectedCategory.add(v!);
                    },
                  ),
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<CompanyRes>(
              stream: _bloc.selectedCompany,
              builder: (context, snapshot) {
                return Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.appTheme)),
                  height: 50,
                  child: DropdownButton<CompanyRes>(
                    value: _bloc.selectedCompany.valueOrNull,
                    underline: const SizedBox.shrink(),
                    isExpanded: true,
                    items: _bloc.companyList.valueOrNull?.data
                        ?.map(
                          (e) => DropdownMenuItem<CompanyRes>(
                            value: e,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text(e.company!),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      _bloc.selectedCompany.add(v!);
                    },
                  ),
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            AppInputField(
              initialValue: product?.dec,
              maxLine: 4,
              hintText: "Description",
              onChanged: (value) {
                _bloc.productDesc.add(value);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            AppInputField(
              initialValue: product?.price,
              hintText: "price",
              onChanged: (value) {
                _bloc.price.add(value);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            AppInputField(
              initialValue: product?.qty,
              hintText: "Qty",
              onChanged: (qty) {
                _bloc.qty.add(qty);
              },
            ),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: StreamBuilder<List<XFile>>(
                  stream: _bloc.pickedImage,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 40,
                            width: 40,
                            padding: const EdgeInsets.all(2),
                            child: Image.file(
                                File(snapshot.data?[index].path ?? "")),
                          );
                        },
                      );
                    }
                    return SizedBox();
                  }),
            ),
            MaterialButton(
              elevation: 9,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: AppColors.appTheme),
                  borderRadius: BorderRadius.circular(2)),
              onPressed: () {
                _bloc.pickImage();
              },
              child: const Icon(Icons.add),
            ),
            StreamBuilder<List<XFile>>(
                stream: _bloc.pickedImage,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data?.isEmpty == true ||
                        snapshot.data!.length < 2) {
                      return const Text(
                        "Minimum two required",
                        textAlign: TextAlign.end,
                        style: TextStyle(color: Colors.redAccent),
                      );
                    }
                  }

                  return const SizedBox();
                }),
            (product != null)
                ? StreamBuilder<bool>(
                    stream: _bloc.isLoading,
                    builder: (context, snapshot) {
                      if (snapshot.data == true) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: AppColors.appTheme,
                              minimumSize: const Size(double.infinity, 40)),
                          onPressed: () async {
                            await _onUpdateClick(context);
                          },
                          child: const Text("Update"));
                    },
                  )
                : StreamBuilder<bool>(
                    stream: _bloc.isLoading,
                    builder: (context, snapshot) {
                      if (snapshot.data == true) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: AppColors.appTheme,
                              minimumSize: const Size(double.infinity, 40)),
                          onPressed: () async {
                            await _onSaveClick(context);
                          },
                          child: const Text("Save"));
                    },
                  ),
          ],
        ),
      ),
    );
  }

  _onSaveClick(BuildContext context) async {
    if (_bloc.pickedImage.valueOrNull!.length >= 2) {
      _bloc.addProduct().then(
            (value) => Navigator.pop(context),
          );
    }
  }

  _onUpdateClick(BuildContext context) async {
    if (_bloc.pickedImage.valueOrNull!.length >= 2) {
      await _bloc.updateProduct(product!.id!).then(
            (value) => Navigator.pop(context),
          );
    }
  }
}
