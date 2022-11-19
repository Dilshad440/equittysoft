import 'package:equitysoft/bloc/product_bloc.dart';
import 'package:equitysoft/constant/app_colors..dart';
import 'package:equitysoft/constant/button_constant.dart';
import 'package:equitysoft/screens/manage_category.dart';
import 'package:equitysoft/screens/manage_company.dart';
import 'package:equitysoft/screens/product_page.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _bloc = ProductBloc.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.getCompanies();
    _bloc.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appTheme,
        title: const Text("Home"),
      ),
      body: Column(
        children: ButtonConstant.buttonsList
            .map(
              (e) => GestureDetector(
                onTap: () => _navigateToPage(e, context),
                child: Card(
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: double.infinity,
                    decoration: BoxDecoration(color: AppColors.appTheme),
                    child: Text(
                      e,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  _navigateToPage(String e, BuildContext context) {
    if (e == ButtonConstant.buttonsList[0]) {
      return Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProductPage(),
          ));
    } else if (e == ButtonConstant.buttonsList[1]) {
      return Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ManageCategory(),
          ));
    } else {
      return Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ManageCompany(),
          ));
    }
  }
}
