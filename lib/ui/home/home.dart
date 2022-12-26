import 'package:seven_learn_nick/data/repo/product_repository.dart';
import 'package:seven_learn_nick/data/repo/banner_repository.dart';
import 'package:seven_learn_nick/data/product_entity.dart';
import 'package:seven_learn_nick/ui/list/list.dart';
import 'package:seven_learn_nick/ui/product/product.dart';
import 'package:seven_learn_nick/ui/widget/error.dart';
import 'package:seven_learn_nick/ui/widget/slider.dart';
import 'package:seven_learn_nick/common/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'bloc/home_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final homeBloc = HomeBloc(
          bannerRepository: banerRepository,
          productRepository: productRepository,
        );
        homeBloc.add(HomeStarted());
        return homeBloc;
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeSuccess) {
                return ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  physics: defualtScrollPhysics,
                  itemBuilder: (BuildContext context, int index) {
                    switch (index) {
                      case 0:
                        return Container(
                          height: 56,
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/img/nike_logo.png',
                            height: 32,
                            fit: BoxFit.fitHeight,
                          ),
                        );
                      case 2:
                        return BannerSlider(
                          banners: state.banners,
                        );
                      case 3:
                        return _HorizontalProductList(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ProductListScreen(
                                    sort: ProductSort.latest)));
                          },
                          products: state.latestProducts,
                          title: 'جدیدترین',
                        );
                      case 4:
                        return _HorizontalProductList(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ProductListScreen(
                                    sort: ProductSort.popular)));
                          },
                          products: state.popularProducts,
                          title: 'پربازدیدترین',
                        );
                      default:
                        return Container(
                          color: Colors.blue,
                        );
                    }
                  },
                );
              } else if (state is HomeLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is HomeError) {
                return AppErrorWidget(
                  exception: state.exception,
                  onPressed: () {
                    BlocProvider.of<HomeBloc>(context).add(HomeRefresh());
                  },
                );
              } else {
                throw Exception('State is not supported');
              }
            },
          ),
        ),
      ),
    );
  }
}

class _HorizontalProductList extends StatelessWidget {
  final String title;
  final GestureTapCallback onTap;
  final List<ProductEntity> products;
  const _HorizontalProductList({
    Key? key,
    required this.onTap,
    required this.title,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: onTap,
                child: const Text('مشاهدی همه'),
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 290,
          child: ListView.builder(
              itemCount: products.length,
              physics: defualtScrollPhysics,
              padding: const EdgeInsets.only(right: 8.0, left: 8.0),
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                final product = products[index];
                return ProductItem(
                  product: product,
                  borderRadius: BorderRadius.circular(12.0),
                );
              }),
        )
      ],
    );
  }
}
