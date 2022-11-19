import 'package:equitysoft/bloc/product_bloc.dart';
import 'package:equitysoft/constant/app_colors..dart';
import 'package:equitysoft/response/product_response.dart';
import 'package:equitysoft/screens/add_product.dart';
import 'package:equitysoft/screens/product_detail.dart';
import 'package:equitysoft/state/product_state.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _bloc = ProductBloc.instance;

  @override
  void initState() {
    _bloc.getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appTheme,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddProduct(),
                    ));
              },
              icon: const Icon(
                Icons.add,
                size: 35,
              ))
        ],
        title: const Text(
          "Product",
        ),
      ),
      body: StreamBuilder<ProductState>(
          stream: _bloc.productsList,
          builder: (context, snapshot) {
            ProductState? state = snapshot.data;
            if (state?.isLoading() ?? false) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state?.isError() ?? false) {
              return const Center(
                child: Text("Something went wrong"),
              );
            }
            if (state!.data!.isEmpty) {
              return const Center(
                child: Text("No data found"),
              );
            }
            return ListView.builder(
                itemCount: state.data?.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetail(state.data![index]),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 77,
                              width: 77,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.green,
                              ),
                              child: Image.network(
                                state.data?[index].img?.first.url ?? "",
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            _contentSection(state.data![index]),
                            const Spacer(),
                            _buttonSection(state.data![index])
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }

  Column _buttonSection(ProductResponse product) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(primary: AppColors.appTheme),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddProduct(product: product),
                ));
          },
          child: const Text("Edit "),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(primary: AppColors.appTheme),
          onPressed: () {
            _bloc.deleteProduct(product.id!);
          },
          child: const Text("Delete "),
        )
      ],
    );
  }

  Widget _contentSection(ProductResponse product) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name ?? "",
            style: TextStyle(
                fontSize: 16,
                color: AppColors.appTheme,
                fontWeight: FontWeight.w700),
          ),
          Text(
            product.dec ?? "",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 14,
                color: AppColors.appTheme,
                fontWeight: FontWeight.w600),
          ),
          Text(
            "Qty: ${product.qty}",
            style: TextStyle(
                fontSize: 14,
                color: AppColors.appTheme,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
