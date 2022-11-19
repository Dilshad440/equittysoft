import 'package:equitysoft/bloc/product_bloc.dart';
import 'package:equitysoft/constant/app_colors..dart';
import 'package:equitysoft/state/company_state.dart';
import 'package:equitysoft/utils/widget/app_input_field.dart';
import 'package:flutter/material.dart';

class ManageCompany extends StatefulWidget {
  const ManageCompany({Key? key}) : super(key: key);

  @override
  State<ManageCompany> createState() => _ManageCompanyState();
}

class _ManageCompanyState extends State<ManageCompany> {
  final _bloc = ProductBloc.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appTheme,
        title: Text("Manage Company"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            AppInputField(
              hintText: "Company name",
              onChanged: (value) {
                _bloc.companyName.add(value);
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
              onPressed: () async {
                await _bloc.addCompanies();
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "List of Companies",
                textAlign: TextAlign.start,
              ),
            ),
            StreamBuilder<CompanyState>(
              stream: _bloc.companyList,
              builder: (context, snapshot) {
                CompanyState? state = snapshot.data;
                if (state?.isLoading() ?? false) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state?.data?.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(state?.data?[index].company ?? ""),
                            IconButton(
                                onPressed: () {
                                  _bloc.deleteCompany(state!.data![index].id!);
                                },
                                icon: const Icon(Icons.delete))
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
