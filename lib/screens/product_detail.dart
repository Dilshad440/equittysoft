import 'package:carousel_slider/carousel_slider.dart';
import 'package:equitysoft/bloc/product_bloc.dart';
import 'package:equitysoft/constant/app_colors..dart';
import 'package:equitysoft/response/product_response.dart';
import 'package:equitysoft/screens/add_product.dart';
import 'package:flutter/material.dart';

class ProductDetail extends StatelessWidget {
  ProductDetail(this.product, {Key? key}) : super(key: key);
  final ProductResponse product;
  final _bloc = ProductBloc.instance;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appTheme,
        title: const Text("Product Detail"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.234,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CarouselSlider(
                  items: product.img
                      ?.map(
                        (e) => Image.network(e.url ?? ""),
                      )
                      .toList(),
                  options: _carouselOptions(),
                ),
                Positioned(
                  bottom: 15,
                  child: StreamBuilder<int>(
                    stream: _bloc.currentIndex,
                    builder: (context, snapshot) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 0; i < product.img!.length; i++)
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                height: 7,
                                width: 7,
                                decoration: BoxDecoration(
                                    color: i == snapshot.data
                                        ? Colors.blue
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          _categoryPriceSection(),
          const SizedBox(height: 10),
          _companyQtySection(),
          const SizedBox(height: 20),
          _descriptionSection(),
          const SizedBox(height: 10),
          _buttonSection(product.id ?? '', context)
        ],
      ),
    );
  }

  CarouselOptions _carouselOptions() {
    return CarouselOptions(
      height: 300,
      onPageChanged: (index, p) {
        _bloc.currentIndex.add(index);
      },
      disableCenter: false,
      aspectRatio: 8 / 7,
      viewportFraction: 0.8,
      initialPage: 0,
      enableInfiniteScroll: true,
      reverse: false,
      autoPlay: true,
      autoPlayInterval: const Duration(seconds: 3),
      autoPlayAnimationDuration: const Duration(milliseconds: 800),
      autoPlayCurve: Curves.fastOutSlowIn,
      enlargeCenterPage: true,
      scrollDirection: Axis.horizontal,
    );
  }

  Row _buttonSection(String id, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: AppColors.appTheme,
            minimumSize: const Size(100, 40),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddProduct(
                  product: product,
                ),
              ),
            );
          },
          child: const Text("Edit"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: AppColors.appTheme,
            minimumSize: const Size(100, 40),
          ),
          onPressed: () {
            _bloc.deleteProduct(id).then((value) => Navigator.pop(context));
          },
          child: const Text("Delete"),
        )
      ],
    );
  }

  Column _descriptionSection() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Description",
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            product.dec ?? "",
            textAlign: TextAlign.start,
          ),
        )
      ],
    );
  }

  Widget _companyQtySection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          product.company ?? "",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        Text(
          "Qty: ${product.qty}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _categoryPriceSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${product.name}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Text(
              "${product.category}",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        Text(
          "Price: ${product.price}/-",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        )
      ],
    );
  }
}
