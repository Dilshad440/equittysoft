import 'package:equitysoft/bloc/product_bloc.dart';
import 'package:equitysoft/constant/app_colors..dart';
import 'package:equitysoft/state/company_state.dart';
import 'package:equitysoft/utils/widget/app_input_field.dart';
import 'package:flutter/material.dart';

class ManageCategory extends StatelessWidget {
  ManageCategory({Key? key}) : super(key: key);
  final _bloc = ProductBloc.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appTheme,
        title: const Text("Manage category"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            AppInputField(
              hintText: "Category name",
              onChanged: (value) {
                _bloc.categoryName.add(value);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: AppColors.appTheme,
                  minimumSize: const Size(double.infinity, 40)),
              child: const Text("Add"),
              onPressed: () {
                _bloc.addCategory();
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "List of Category",
                textAlign: TextAlign.start,
              ),
            ),
            StreamBuilder<CompanyState>(
                stream: _bloc.categoryList,
                builder: (context, snapshot) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data?.data?.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final category = snapshot.data?.data?[index];
                        return Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(category?.category ?? ""),
                              IconButton(
                                  onPressed: () {
                                    _bloc.deleteCategory(category!.id!);
                                  },
                                  icon: const Icon(Icons.delete))
                            ],
                          ),
                        );
                      },
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
